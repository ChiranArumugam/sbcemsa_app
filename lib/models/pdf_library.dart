import 'dart:convert';
import 'package:flutter/services.dart';
import 'category.dart';

class PdfLibrary {
  final Map<String, Category> categories;

  PdfLibrary({required this.categories});

  factory PdfLibrary.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as Map<String, dynamic>;
    final categoryMap = <String, Category>{};

    categoriesJson.forEach((categoryName, catData) {
      categoryMap[categoryName] = Category.fromJson(categoryName, catData);
    });

    return PdfLibrary(categories: categoryMap);
  }

  static Future<PdfLibrary> loadFromAsset(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return PdfLibrary.fromJson(jsonData);
  }

  List<Category> getAllCategories() {
    return categories.values.toList();
  }

  Category? getCategory(String name) {
    return categories[name];
  }
}
