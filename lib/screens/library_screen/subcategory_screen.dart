// lib/screens/library_screen/subcategory_screen.dart

import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/subcategory.dart';
import 'pdf_list_screen.dart';
import '../../UI/colors.dart'; // Ensure this path is correct

class SubcategoryScreen extends StatelessWidget {
  final Category category;

  SubcategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Subcategory> subcategories = category.subcategories.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name}/Subcategories'),
        backgroundColor: AppColors.background, // Set AppBar color
      ),
      body: Container(
        color: AppColors.background, // Set overall background color
        child: ListView.builder(
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            final subcategory = subcategories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Material(
                elevation: 1.0, // Set elevation for shadow
                borderRadius: BorderRadius.circular(15.0),
                color: AppColors.background, // Card background color
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfListScreen(
                          category: category.name,
                          subcategory: subcategory.name,
                          pdfs: subcategory.pdfs,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Row(
                      children: [
                        // Optional: Add an icon or image representing the subcategory
                        Icon(
                          Icons.folder,
                          color: AppColors.accent,
                          size: 30.0,
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            subcategory.name,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.primary, // Set text color
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
