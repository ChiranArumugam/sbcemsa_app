// lib/screens/home_screen/medications_card.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart'; // Ensure correct path

class MedicationsCard extends StatelessWidget {
  final VoidCallback onTap;

  const MedicationsCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a fixed size for the square card, ensuring it fits in the available space
    final double squareSize = MediaQuery.of(context).size.width / 2 - 24.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0), // Match the card's border radius
      child: Container(
        width: squareSize,
        height: squareSize - 15,
        child: Card(
          color: AppColors.background, // Background color for consistency
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medication,
                  size: 40.0,
                  color: AppColors.accent, // Use accent color to match the theme
                  semanticLabel: 'Medications Icon',
                ),
                SizedBox(height: 8.0),
                Text(
                  'Medications',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent, // Use accent color for text
                  ),
                  semanticsLabel: 'Medications',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
