// lib/screens/home_screen/visit_website_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../UI/colors.dart'; // Ensure this imports your custom color definitions

class VisitWebsiteCard extends StatelessWidget {
  final String url;
  final String text;

  VisitWebsiteCard({
    required this.url,
    this.text = 'Visit Website',
  });

  /// Opens the given [url] in the device's default browser.
  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Container(
        height: 60.0, // Thinner vertically compared to other cards
        decoration: BoxDecoration(
          color: AppColors.background, // Use your primary color
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.primary, // Use your background color for text
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
