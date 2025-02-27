// lib/screens/home_screen/faqs_screen.dart

import 'package:flutter/material.dart';

class FAQsScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I reset my password?',
      'answer': 'To reset your password, go to Settings > Account > Reset Password.',
    },
    {
      'question': 'How to contact support?',
      'answer': 'You can contact support by emailing support@example.com.',
    },
    // Add more FAQs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Colors.blue, // Customize as needed
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            leading: Icon(Icons.question_answer, color: Colors.blue),
            title: Text(faqs[index]['question']!),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(faqs[index]['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
