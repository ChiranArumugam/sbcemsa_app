// lib/screens/home_screen/usage_screen.dart

import 'package:flutter/material.dart';

class UsageScreen extends StatelessWidget {
  final List<String> usageSteps = [
    '1. Open the app and sign in.',
    '2. Navigate through the home screen to access various features.',
    '3. Use the settings to customize your preferences.',
    '4. Contact support if you encounter any issues.',
    // Add more steps as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usage'),
        backgroundColor: Colors.blue, // Customize as needed
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: usageSteps.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text(usageSteps[index]),
          );
        },
      ),
    );
  }
}
