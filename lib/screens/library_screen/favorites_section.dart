// lib/screens/library_screen/favorites_section.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart'; // Import AppColors

class FavoritesSection extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(int) onFavoriteTap;
  final bool isEmpty; // New parameter to handle empty state

  const FavoritesSection({
    Key? key,
    required this.favorites,
    required this.onFavoriteTap,
    this.isEmpty = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      // Display placeholder message when there are no favorites
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            "PDFs marked favorites will show up here.",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // If there are favorites, display them
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0),
        Container(
          height: 130.0, // Increased height from 120.0 to 130.0
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onFavoriteTap(index),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 1.0, // Set elevation to create shadow
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: AppColors.background, // Set to secondary color
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon Container
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
                                favorite['icon'], // Dynamic icon path
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // PDF Name with Text Overflow Handling
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              favorite['name'],
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1, // Limit to one line
                              overflow: TextOverflow.ellipsis, // Add ellipsis
                              softWrap: false, // Prevent text from wrapping
                            ),
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
