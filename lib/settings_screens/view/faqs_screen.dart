import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '❓ Frequently Asked Questions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFAQItem('🔑 How do I reset my password?', 'To reset your password, go to the login screen and click on "Forgot Password". Follow the instructions to reset your password.'),
            _buildFAQItem('📝 How do I update my profile?', 'To update your profile, go to the settings screen and click on "Profile". You can update your personal information there.'),
            _buildFAQItem('📧 How do I contact support?', 'You can contact support by emailing us at support@example.com. We are here to help you with any issues you may have.'),
          ],
        ),
      ),
    );
  }

  static Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}