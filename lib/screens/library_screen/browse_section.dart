// lib/screens/library_screen/browse_section.dart

import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../UI/colors.dart'; // Import AppColors

class BrowseSection extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategoryTap;

  const BrowseSection({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Browse",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 18.0,
        //     color: AppColors.primary,
        //   ),
        // ),
        SizedBox(height: 12.0),
        Container(
          height: 120.0, // Fixed height for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onCategoryTap(category),
                  child: Material(
                    color: Colors.transparent, // Makes the Material background transparent
                    elevation: 1.0, // Set the desired elevation
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: AppColors.background, // Background color
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Using Image.asset for custom icons
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.background, // Background for the icon
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/${category.name.toLowerCase()}.png', // Ensure corresponding icons exist
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary, // Assuming background is contrasting
                            ),
                            textAlign: TextAlign.center,
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
      ],
    );
  }
}
