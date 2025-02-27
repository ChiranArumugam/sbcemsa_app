import 'subcategory.dart';

class Category {
  final String name;
  final Map<String, Subcategory> subcategories;

  Category({
    required this.name,
    required this.subcategories,
  });

  factory Category.fromJson(String categoryName, Map<String, dynamic> json) {
    final subs = <String, Subcategory>{};
    final subcategoriesJson = json['subcategories'] as Map<String, dynamic>;

    subcategoriesJson.forEach((subName, pdfsJson) {
      subs[subName] = Subcategory.fromJson(subName, pdfsJson as List<dynamic>, categoryName);
    });

    return Category(
      name: categoryName,
      subcategories: subs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subcategories': subcategories.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
