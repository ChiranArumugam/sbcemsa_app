// lib/models/search_result.dart

import 'pdf_document.dart';

class SearchResult {
  final PdfDocClass pdf;
  final int pageNumber;
  final String snippet;

  SearchResult({
    required this.pdf,
    required this.pageNumber,
    required this.snippet,
  });
}
