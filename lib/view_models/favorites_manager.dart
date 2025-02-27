// File: lib/view_models/features/favorites_manager.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../models/pdf_document.dart';
import '../models/pdf_library.dart';

class FavoritesManager {
  List<PdfDocClass> _favorites = [];
  List<PdfDocClass> get favorites => _favorites;

  void toggleFavorite(PdfDocClass pdf) {
    if (_favorites.contains(pdf)) {
      _favorites.remove(pdf);
      pdf.isFavorite = false;
    } else {
      _favorites.add(pdf);
      pdf.isFavorite = true;
    }
    saveFavorites();
  }

  Future<void> loadFavorites(PdfLibrary pdfLibrary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteFilePaths = prefs.getStringList('favorites');

    if (favoriteFilePaths != null) {
      for (var pdf in pdfLibrary.categories.values
          .expand((c) => c.subcategories.values)
          .expand((s) => s.pdfs)) {
        if (favoriteFilePaths.contains(pdf.filePath)) {
          _favorites.add(pdf);
          pdf.isFavorite = true;
        }
      }
    }
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteFilePaths = _favorites.map((pdf) => pdf.filePath).toList();
    await prefs.setStringList('favorites', favoriteFilePaths);
  }
}