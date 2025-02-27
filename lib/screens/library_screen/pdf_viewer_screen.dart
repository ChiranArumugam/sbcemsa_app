// lib/screens/pdf_viewer_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

import '../../models/pdf_document.dart'; // Adjust the path as needed
import '../../view_models/library_view_model.dart';
import '../../UI/colors.dart'; // Assuming AppColors is defined here

class PdfViewerScreen extends StatefulWidget {
  final PdfDocClass pdf;
  final int initialPage;
  final String query;

  PdfViewerScreen({
    required this.pdf,
    this.initialPage = 1,
    this.query = "",
  });

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;
  String? _pdfPath;
  late PdfViewerController _controller;
  late PdfTextSearcher _textSearcher;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _textSearcher = PdfTextSearcher(_controller)..addListener(_updateSearch);
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final assetPath = widget.pdf.filePath;
      String actualPath = assetPath;
      // Debug: Print asset path
      // print('Asset Path: $assetPath');

      if(widget.pdf.fileDriveId == null)
      {
        // Load the PDF from assets
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();

        // Write the PDF to a temporary file
        final tempDir = await getTemporaryDirectory();
        final fileName = assetPath.split('/').last; // Extract the file name
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(bytes, flush: true);

        // Debug: Print temporary file path and size
         print('Temporary File Path: ${tempFile.path}');
        actualPath = tempFile.path;
        final fileSize = await tempFile.length();
         print('Temporary PDF file size: $fileSize bytes');

        if (!await tempFile.exists()) {
          throw Exception('PDF file not found at path: ${tempFile.path}');
        }
      }
      else {
        print(widget.pdf.fileDriveId);
      }

      setState(() {
        _pdfPath = actualPath; // Use the temporary file's path
        _isLoading = false;
      });

      // Debug: Print PDF path being loaded
       print('Loading PDF from: $_pdfPath');

      // If a query is provided, perform the search
      if (widget.query.isNotEmpty) {
        _searchText(widget.query);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle PDF loading error with more details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF from ${widget.pdf.filePath}: $e')),
      );
    }
  }

  void _updateSearch() {
    if (mounted) {
      setState(() {});
    }
  }

  void _searchText(String query) {
    if (query.isNotEmpty) {
      _textSearcher.startTextSearch(query);
    }
  }

  @override
  void dispose() {
    _textSearcher.removeListener(_updateSearch);
    _textSearcher.dispose();
    //_controller.dispose();
    super.dispose();
  }

  /// Toggles the favorite status of the PDF.
  void _toggleFavorite(LibraryViewModel viewModel) {
    viewModel.toggleFavorite(widget.pdf);
  }

  /// Shares the PDF using native share options.
  void _sharePdf() async {
    if (_pdfPath != null && await File(_pdfPath!).exists()) {
      try {
        await Share.shareXFiles(
          [XFile(_pdfPath!)],
          subject: 'Check out this PDF: ${widget.pdf.pdfName}',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF file is not available to share.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryViewModel>(
      builder: (context, viewModel, child) {
        bool isFavorite = viewModel.favorites.contains(widget.pdf);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.pdf.pdfName),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red, // Customize the color as needed
                ),
                onPressed: () => _toggleFavorite(viewModel),
                tooltip: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              ),
              IconButton(
                icon: Icon(CupertinoIcons.share),
                onPressed: () => _sharePdf(),
                tooltip: 'Share PDF',
              ),
            ],
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _pdfPath != null
                  ? PdfViewer.file(
                      _pdfPath!,
                      controller: _controller,
                      params: PdfViewerParams(
                        enableTextSelection: true,
                        minScale: 1.0,
                        maxScale: 3.0,
                        pagePaintCallbacks: [
                          _textSearcher.pageTextMatchPaintCallback,
                        ],
                      ),
                    )
                  : Center(child: Text('Failed to load PDF.')),
        );
      },
    );
  }
}
