// lib/screens/library_screen/recently_searched_section.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart'; // Import AppColors

class RecentlySearchedSection extends StatelessWidget {
  final List<String> recentlySearched;
  final Function(String) onSearchTap;

  const RecentlySearchedSection({
    Key? key,
    required this.recentlySearched,
    required this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If there are no recently searched items, you might choose to show nothing or a placeholder.
    if (recentlySearched.isEmpty) {
      // Display placeholder message when there are no favorites
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            "Recently viewed PDFs will show up here.",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recently Searched",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12.0),
        Container(
          height: 50.0, // Fixed height for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlySearched.length,
            itemBuilder: (context, index) {
              final query = recentlySearched[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onSearchTap(query),
                  child: Chip(
                    label: Text(query),
                    backgroundColor: AppColors.accent.withOpacity(0.7),
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
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
