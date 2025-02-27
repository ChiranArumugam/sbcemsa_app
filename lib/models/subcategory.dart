import 'pdf_document.dart';

class Subcategory {
  final String name;
  final List<PdfDocClass> pdfs;

  Subcategory({
    required this.name,
    required this.pdfs,
  });

  factory Subcategory.fromJson(String subcategoryName, List<dynamic> jsonList, String categoryName) {
    List<PdfDocClass> pdfList = jsonList
        .map((pdfJson) => PdfDocClass.fromJson(pdfJson as Map<String, dynamic>, categoryName, subcategoryName))
        .toList();

    return Subcategory(
      name: subcategoryName,
      pdfs: pdfList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pdfs': pdfs.map((pdf) => pdf.toJson()).toList(),
    };
  }
}
