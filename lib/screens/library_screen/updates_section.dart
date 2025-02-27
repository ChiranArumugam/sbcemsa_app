// lib/screens/library_screen/updates_section.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart'; // Import AppColors

class UpdatesSection extends StatelessWidget {
  final VoidCallback onTap;

  const UpdatesSection({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent, // Keeps the background transparent to focus on Container color
        elevation: 1.0, // Adjust elevation as needed
        borderRadius: BorderRadius.circular(15.0), // Matches Container radius for consistent shape
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.accent, // Background color of the card
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Feature Released!",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background, // Text color assuming it contrasts with accent
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "Check out the latest features in our library. Click to learn more.",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70, // Adjusted for better contrast with the accent color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
