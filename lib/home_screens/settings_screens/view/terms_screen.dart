import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📜 Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTermItem(
              '📱 Use of the App',
              'You agree to use the app only for lawful purposes and in a way that does not infringe the rights of others.',
            ),
            const Divider(),
            _buildTermItem(
              '📝 User Content',
              'You are responsible for any content you upload or share through the app. Ensure that it does not violate any laws or regulations.',
            ),
            const Divider(),
            _buildTermItem(
              '🔒 Privacy',
              'We respect your privacy and are committed to protecting your personal information. Please review our privacy policy for more details.',
            ),
            const Divider(),
            _buildTermItem(
              '🔄 Changes to Terms',
              'We may update these terms from time to time. Continued use of the app constitutes acceptance of the updated terms.',
            ),
            const SizedBox(height: 16),
            const Text(
              'If you have any questions or concerns about these terms, please contact us at support@example.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}