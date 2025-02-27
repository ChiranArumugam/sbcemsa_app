// lib/screens/home_screen/medication_content.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart';
import '../../models/medication.dart'; // Import the Medication model

class MedicationContent extends StatelessWidget {
  final Medication medication;
  final bool isPediatric;

  const MedicationContent({
    Key? key,
    required this.medication,
    required this.isPediatric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content = isPediatric
        ? medication.pediatricInfo
        : medication.adultInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medication Name
        Text(
          medication.name,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12.0),
        // Medication Content
        Text(
          content,
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
