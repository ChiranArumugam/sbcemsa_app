import 'package:flutter/material.dart';
import '../../UI/colors.dart';

class HospitalsCard extends StatelessWidget {
  final VoidCallback onTap;

  const HospitalsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double squareSize = MediaQuery.of(context).size.width / 2 - 24.0;

    return InkWell(
      onTap: onTap,
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
              children: [
                Icon(
                  Icons.local_hospital,
                  size: 40,
                  color: AppColors.accent,
                  semanticLabel: 'Hospitals Icon',
                ),
                SizedBox(height: 8),
                Text(
                  'Hospitals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                  semanticsLabel: 'Hospitals',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
