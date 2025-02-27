import 'package:flutter/material.dart';
import '../UI/colors.dart';

class NotificationPopup extends StatelessWidget {
  final String message;
  final double progress;

  const NotificationPopup({
    Key? key,
    required this.message,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Stack(
            children: [
              // Background of the progress bar
              Container(
                height: 4,
                width: double.infinity,
                color: Colors.white.withOpacity(0.3),
              ),
              // Animated progress bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: (MediaQuery.of(context).size.width * progress)
                    .clamp(0.0, double.infinity),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
