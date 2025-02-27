// lib/widgets/custom_toggle_switch.dart

import 'package:flutter/material.dart';
import '../UI/colors.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onToggle;

  const CustomToggleSwitch({
    Key? key,
    required this.isSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 160.0,
        height: 35.0,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: AppColors.primary, width: 2.0),
        ),
        child: Stack(
          children: [
            // Sliding background highlight
            AnimatedAlign(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 80.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            // Labels with animated text style
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      child: Text('Adult'),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      child: Text('Pediatric'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
