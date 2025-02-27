// lib/screens/home_screen/pediatric_drug_card.dart

import 'package:flutter/material.dart';
import 'pediatric_dose_calculator_page.dart';
import '../../UI/colors.dart';

class PediatricDrugCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PediatricDrugCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double squareSize = MediaQuery.of(context).size.width / 2 - 24.0;

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PediatricDoseCalculatorPage()),
            );
          },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: squareSize,
        height: squareSize - 15,
        child: Card(
          color: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calculate,
                  size: 40.0,
                  color: AppColors.accent,
                  semanticLabel: 'Pediatric Drug Calculator Icon',
                ),
                SizedBox(height: 8.0),
                Text(
                  'Pediatric Drugs',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                  semanticsLabel: 'Pediatric Drugs',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
