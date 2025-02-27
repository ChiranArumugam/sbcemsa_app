// lib/screens/home_screen/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'faqs_screen.dart';
import '../UI/colors.dart';
import 'usage_screen.dart';

class SettingsScreen extends StatelessWidget {
  // Replace with your actual developer email
  final String developerEmail = 'chiran.aru@icloud.com';
  final String appName = 'SBCEMSA';
  // Replace with your app's website URL
  final String appWebsite = 'https://www.yourappwebsite.com';

  // Replace with your Privacy Policy and Terms of Service URLs
  final String privacyPolicyUrl = 'https://www.yourappwebsite.com/privacy';
  final String termsOfServiceUrl = 'https://www.yourappwebsite.com/terms';

  // Replace with your App Store URL
  final String appStoreUrl = 'https://apps.apple.com/app/idXXXXXXXXX';

  // Function to send an email
  Future<void> _sendEmail(String subject, String body, BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: developerEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Show a snackbar if the email client cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the email client.')),
      );
    }
  }

  // Function to launch URLs
  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Optionally, show a snackbar on successful launch
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening the URL...')),
      );
    } else {
      // Show a snackbar if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL.')),
      );
    }
  }

  // Function to share the app
  void _shareApp(BuildContext context) {
    Share.share(
      'Check out $appName App: https://www.yourappwebsite.com',
      subject: 'Download $appName App',
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('App link shared successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share the app.')),
      );
    });
  }

  // Function to rate the app
  void _rateApp(BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl), mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening the App Store...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the App Store.')),
      );
    }
  }

  // Function to show FAQs
  void _showFAQs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FAQsScreen()),
    );
  }

  // Function to show Usage
  void _showUsage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UsageScreen()),
    );
  }

  // Custom Elevated Button Widget
  Widget _buildSettingsButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.primary, backgroundColor: AppColors.background, // Text and icon color
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 1.0,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.background,
              size: 24.0,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Contact the Developer Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Contact the Developer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        _buildSettingsButton(
          icon: Icons.bug_report,
          iconColor: AppColors.accent,
          title: 'Bug Report',
          subtitle: 'Report any issues or bugs',
          onPressed: () {
            _sendEmail(
              'Bug Report',
              'Describe the bug here...',
              context,
            );
          },
        ),
        _buildSettingsButton(
          icon: Icons.lightbulb_outline,
          iconColor: Colors.yellow[700],
          title: 'Feature Suggestion',
          subtitle: 'Suggest new features',
          onPressed: () {
            _sendEmail(
              'Feature Suggestion',
              'Describe the feature you would like to see...',
              context,
            );
          },
        ),

        // Help & Support Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Help & Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        _buildSettingsButton(
          icon: Icons.question_answer,
          iconColor: AppColors.secondary,
          title: 'FAQs',
          subtitle: 'Frequently Asked Questions',
          onPressed: () => _showFAQs(context),
        ),
        _buildSettingsButton(
          icon: Icons.info,
          iconColor: AppColors.primary,
          title: 'Usage',
          subtitle: 'How to use the app',
          onPressed: () => _showUsage(context),
        ),

        // Love SBCEMSA? Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Love $appName?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        _buildSettingsButton(
          icon: Icons.share,
          iconColor: Colors.green,
          title: 'Share App',
          subtitle: 'Share $appName with your friends',
          onPressed: () => _shareApp(context),
        ),
        _buildSettingsButton(
          icon: Icons.star_rate,
          iconColor: Colors.orange,
          title: 'Rate it on the App Store',
          subtitle: 'Give us a rating',
          onPressed: () => _rateApp(context),
        ),

        // Legal Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Legal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        _buildSettingsButton(
          icon: Icons.privacy_tip,
          iconColor: Colors.purple,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onPressed: () => _launchURL(privacyPolicyUrl, context),
        ),
        _buildSettingsButton(
          icon: Icons.description,
          iconColor: Colors.teal,
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          onPressed: () => _launchURL(termsOfServiceUrl, context),
        ),

        SizedBox(height: 20), // Extra spacing at the bottom
      ],
    );
  }
}
