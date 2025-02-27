import 'package:shared_preferences/shared_preferences.dart';
import '../models/pdf_document.dart';
import '../models/pdf_library.dart';

class RecentlyViewedManager {
  static const int maxRecentlyViewed = 8;
  List<PdfDocClass> _recentlyViewed = [];
  List<PdfDocClass> get recentlyViewed => _recentlyViewed;

  void addRecentlyViewed(PdfDocClass pdf) {
    _recentlyViewed.remove(pdf);
    _recentlyViewed.insert(0, pdf);
    if (_recentlyViewed.length > maxRecentlyViewed) {
      _recentlyViewed = _recentlyViewed.sublist(0, maxRecentlyViewed);
    }
    saveRecentlyViewed();
  }

  Future<void> loadRecentlyViewed(PdfLibrary pdfLibrary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recentlyViewedFilePaths = prefs.getStringList('recentlyViewed');

    if (recentlyViewedFilePaths != null) {
      for (var filePath in recentlyViewedFilePaths) {
        for (var pdf in pdfLibrary.categories.values
            .expand((c) => c.subcategories.values)
            .expand((s) => s.pdfs)) {
          if (pdf.filePath == filePath) {
            _recentlyViewed.add(pdf);
            break;
          }
        }
      }
    }
  }

  Future<void> saveRecentlyViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentlyViewedFilePaths = _recentlyViewed.map((pdf) => pdf.filePath).toList();
    await prefs.setStringList('recentlyViewed', recentlyViewedFilePaths);
  }
}
