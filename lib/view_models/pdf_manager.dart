import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:read_pdf_text/read_pdf_text.dart';

import '../models/pdf_document.dart';
import '../models/pdf_library.dart';
import '../models/category.dart';
import '../database/database_helper.dart';
import '../widgets/notification_popup.dart';
import 'library_view_model.dart';


class PdfManager {
  PdfLibrary? pdfLibrary; // Nullable to handle asynchronous loading
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> loadPdfLibrary(String jsonPath) async {
    try {
      pdfLibrary = await PdfLibrary.loadFromAsset(jsonPath);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initializeDatabase(List<PdfDocClass> pdfs) async {
    bool isEmpty = await _dbHelper.isDatabaseEmpty();
    if (!isEmpty) return;

    for (var pdf in pdfs) {
      try {
        // Insert PDF metadata into the database
        int pdfId = await _dbHelper.upsertPDF({
          'pdfName': pdf.pdfName,
          'filePath': pdf.filePath,
          'category': pdf.category,
          'subcategory': pdf.subcategory,
          'version': pdf.version,
          'fileDriveId': pdf.fileDriveId,
        });

        // Prepare temporary file path
        Directory tempDir = await getTemporaryDirectory();
        String sanitizedPdfName = pdf.pdfName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
        String tempPath = '${tempDir.path}/${sanitizedPdfName}_${pdfId}.pdf';
        File tempFile = File(tempPath);

        // Load ByteData from assets
        ByteData bytes = await rootBundle.load(pdf.filePath);

        // Write to temporary file
        await tempFile.writeAsBytes(bytes.buffer.asUint8List());
        print('Written to temporary file: $tempPath');
        // Extract text from the PDF
        try {
          print("pdf name:  ${pdf.pdfName}");
          List<String> pdfText = [];
          try {
            pdfText = await ReadPdfText.getPDFtextPaginated(tempFile.path);
          } on PlatformException {
            print('Failed to get PDF text.');
          }
          int numPages = pdfText.length;

          // Insert extracted text into the database
          for (int page = 1; page <= numPages; page++) {
            String pageText = pdfText[page - 1].toString();
            await _dbHelper.insertPDFText({
              'pdfId': pdfId,
              'pageNumber': page,
              'content': pageText,
            });
          }
        }  on PlatformException {
          print('Failed to get PDF text.');
          // Handle PDF text extraction error gracefully
          print('Error extracting text from PDF: ${pdf.pdfName}');
        } finally {
          // Delete the temporary file to clean up
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      } catch (e) {
        print('Error initializing PDF: ${pdf.pdfName}, Error: $e');
      }
    }
  }



  Future<List<Map<String, dynamic>>> searchPdfs(String query) async {
    try {
      return await _dbHelper.searchPdfs(query);
    } catch (e) {
      return [];
    }
  }

   Future<void> loadBaselineJsonAndSave(String localJsonPath) async {
    final jsonString = await rootBundle.loadString('assets/pdf_library_baseline.json');
    final baselineJson = jsonDecode(jsonString);

    // Save baseline JSON to local storage
    await File(localJsonPath).writeAsString(jsonEncode(baselineJson), flush: true);

    // Load into pdfLibrary
    pdfLibrary = await PdfLibrary.loadFromAsset(localJsonPath);
  }

  Future<void> checkForUpdatesWithViewModel({
    required VoidCallback onUpdateStart,
    required ValueChanged<double> onUpdateProgress,
    required VoidCallback onUpdateEnd,
    required LibraryViewModel libraryViewModel, // Add this parameter
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print("Connectivity result: $connectivityResult");
    if (connectivityResult.contains(ConnectivityResult.none)) {
      print("no connection");
      onUpdateEnd();
      return;
    }

    onUpdateStart();
    await checkForUpdates(
       onUpdateProgress,
       libraryViewModel,
    );
    onUpdateEnd();
  }



  Future<void> checkForUpdates(ValueChanged<double> onUpdateProgress, LibraryViewModel libraryViewModel) async {
    const remoteJsonFileID = '1vaZ7dTDH1WrOU25UpFyUxSQ767UJFHqM';
    final directory = await getApplicationDocumentsDirectory();
    final localJsonPath = '${directory.path}/pdf_library_local.json';

    // Total progress is divided into weighted increments for each step
    const double fetchJsonWeight = 0.5; // 50%
    const double comparePdfsWeight = 0.2; // 20%
    const double downloadPdfsWeight = 0.2; // 30%

    // Step 1: Fetch remote JSON (20%)
    await Future.delayed(Duration(milliseconds: 100));
    onUpdateProgress(0.20); // Start progress
    //onUpdateProgress(0.1);
    final remoteJson = await _fetchRemoteJson(remoteJsonFileID);
    onUpdateProgress(fetchJsonWeight);
    await Future.delayed(Duration(milliseconds: 100));
    print("json fetched.");

    // Step 2: Load local JSON and compare with remote (30%)
    final localJsonFile = File(localJsonPath);
    final localJson = jsonDecode(await localJsonFile.readAsString());
    final updatedPdfs = await _compareAndDownloadUpdatesWithWeightedProgress(
      onUpdateProgress,
      fetchJsonWeight,
      comparePdfsWeight,
      downloadPdfsWeight,
      localJson,
      remoteJson,
      libraryViewModel,
    );

    // Step 3: Save updated local JSON
    await localJsonFile.writeAsString(jsonEncode(localJson), flush: true);

    // Step 4: Update database with updated PDFs
    pdfLibrary = await PdfLibrary.loadFromAsset(localJsonPath);
    await initializeDatabase(getAllPdfs(pdfLibrary!.getAllCategories()));

    // Ensure progress reaches 100% at the end
    onUpdateProgress(1.0);
  }

  Future<List<Map<String, dynamic>>> _compareAndDownloadUpdatesWithWeightedProgress(
    ValueChanged<double> onUpdateProgress,
    double fetchJsonWeight,
    double comparePdfsWeight,
    double downloadPdfsWeight,
    Map<String, dynamic> localJson,
    Map<String, dynamic> remoteJson,
    LibraryViewModel libraryViewModel, // Pass the view model here
  ) async {
    final updatedPdfs = <Map<String, dynamic>>[];
    final updatedPdfDetails = <Map<String, String>>[]; // Collect updated PDFs with details


    final localCategories = localJson['categories'] as Map<String, dynamic>;
    final remoteCategories = remoteJson['categories'] as Map<String, dynamic>;

    int totalPdfsToProcess = 0;
    int processedPdfs = 0;

    // Calculate the total number of PDFs to process
    for (final categoryKey in remoteCategories.keys) {
      final remoteSubcategories = remoteCategories[categoryKey]['subcategories'] as Map<String, dynamic>;
      for (final subcategoryKey in remoteSubcategories.keys) {
        final remotePdfs = remoteSubcategories[subcategoryKey] as List<dynamic>;
        totalPdfsToProcess += remotePdfs.length;
      }
    }

    // Step 2: Compare PDFs (30% of progress distributed across PDFs)
    double compareStepStart = fetchJsonWeight;
    double compareStepEnd = fetchJsonWeight + comparePdfsWeight;

    for (final categoryKey in remoteCategories.keys) {
      final remoteSubcategories = remoteCategories[categoryKey]['subcategories'] as Map<String, dynamic>;
      final localSubcategories = localCategories[categoryKey]['subcategories'] as Map<String, dynamic>;

      for (final subcategoryKey in remoteSubcategories.keys) {
        final remotePdfs = remoteSubcategories[subcategoryKey] as List<dynamic>;
        final localPdfs = localSubcategories[subcategoryKey] as List<dynamic>;

        for (final remotePdf in remotePdfs) {
          processedPdfs++;
          double compareProgress = compareStepStart +
              (processedPdfs / totalPdfsToProcess) * (compareStepEnd - compareStepStart);
          onUpdateProgress(compareProgress);
          print("comparing progress.");


          // Compare and update logic
          final pdfName = remotePdf['pdfName'];
          final remoteVersion = remotePdf['version'];
          final remoteFileDriveID = remotePdf['fileDriveID'];

          if (remoteFileDriveID == null || remoteFileDriveID.isEmpty) {
            continue;
          }

          final localPdfIndex = localPdfs.indexWhere((p) => p['pdfName'] == pdfName);
          if (localPdfIndex == -1) {
            // New PDF
            final newLocalPath = await _downloadAndSavePdf(remotePdf);
            remotePdf['filePath'] = newLocalPath;
            await _dbHelper.upsertPDF(remotePdf);
            localPdfs.add(remotePdf);
            updatedPdfs.add(remotePdf);
          } else {
            final localPdf = localPdfs[localPdfIndex];
            final localVersion = localPdf['version'];

            if (remoteVersion != localVersion) {
              // Updated PDF
              final newLocalPath = await _downloadAndSavePdf(remotePdf);
              remotePdf['filePath'] = newLocalPath;
              await _dbHelper.upsertPDF(remotePdf);
              localPdfs[localPdfIndex] = remotePdf;
              updatedPdfs.add(remotePdf);
              updatedPdfDetails.add({
                'pdfName': pdfName,
                'version': remoteVersion,
              });
            }
          }
        }
      }
    }

    // Step 3: Download PDFs (50% of progress distributed across PDFs)
    double downloadStepStart = compareStepEnd;
    double downloadStepEnd = compareStepEnd + downloadPdfsWeight;

    for (int i = 0; i < updatedPdfs.length; i++) {
      double downloadProgress = downloadStepStart +
          ((i + 1) / updatedPdfs.length) * (downloadStepEnd - downloadStepStart);
      onUpdateProgress(downloadProgress);
      print("downloading progress.");
      final pdf = updatedPdfs[i];
      await _downloadAndSavePdf(pdf);
    }
    if(updatedPdfs.length > 0) {
      await libraryViewModel.addUpdatedPdfs(updatedPdfDetails);
    }

    return updatedPdfs;
  }


  Future<Map<String, dynamic>> _fetchRemoteJson(String fileDriveID) async {
    try {
      final url = 'https://drive.google.com/uc?export=download&id=$fileDriveID';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch remote JSON. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching remote JSON: $e');
      throw Exception('Network or parsing error occurred.');
    }
  }

  Future<String> _downloadAndSavePdf(Map<String, dynamic> pdf) async {
    final fileDriveID = pdf['fileDriveID'];
    final pdfName = pdf['pdfName'];
    final sanitizedName = sanitizeFileName(pdfName);

    final directory = await getApplicationDocumentsDirectory();
    final localSavePath = '${directory.path}/saved_pdfs';
    await Directory(localSavePath).create(recursive: true);
    final filePath = '$localSavePath/$sanitizedName.pdf';

    final url = 'https://drive.google.com/uc?export=download&id=$fileDriveID';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception("Failed to download updated PDF for $pdfName");
    }
  }

  String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  List<PdfDocClass> getAllPdfs(List<Category> categories) {
    List<PdfDocClass> allPdfs = [];
    for (var category in categories) {
      for (var subcategory in category.subcategories.values) {
        allPdfs.addAll(subcategory.pdfs);
      }
    }
    return allPdfs;
  }
}
