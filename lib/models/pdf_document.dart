class PdfDocClass {
  final String filePath;
  final String pdfName;
  final String category;
  final String subcategory;
  bool isFavorite;
  final String version;
  final String? fileDriveId;

  PdfDocClass({
    required this.filePath,
    required this.pdfName,
    required this.category,
    required this.subcategory,
    this.isFavorite = false,
    this.version = "test",
    this.fileDriveId = "null",
  });

  // Note: categoryName and subcategoryName are passed in from the caller.
  factory PdfDocClass.fromJson(
    Map<String, dynamic> json,
    String categoryName,
    String subcategoryName,
  ) {
    return PdfDocClass(
      filePath: json['filePath'] as String,
      pdfName: json['pdfName'] as String,
      version: json['version'] as String,
      fileDriveId: json['fileDriveID'] as String?,
      category: categoryName,
      subcategory: subcategoryName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'pdfName': pdfName,
      'category': category,
      'subcategory': subcategory,
      'version': version,
      'fileDriveId': fileDriveId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDocClass &&
          runtimeType == other.runtimeType &&
          pdfName == other.pdfName &&
          filePath == other.filePath;

  @override
  int get hashCode => pdfName.hashCode ^ filePath.hashCode;
}
