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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '📜 Terms & Conditions\n\n'
          'Welcome to our application. By using this app, you agree to the following terms and conditions:\n\n'
          '1. 📱 Use of the App: You agree to use the app only for lawful purposes and in a way that does not infringe the rights of others.\n'
          '2. 📝 User Content: You are responsible for any content you upload or share through the app. Ensure that it does not violate any laws or regulations.\n'
          '3. 🔒 Privacy: We respect your privacy and are committed to protecting your personal information. Please review our privacy policy for more details.\n'
          '4. 🔄 Changes to Terms: We may update these terms from time to time. Continued use of the app constitutes acceptance of the updated terms.\n\n'
          'If you have any questions or concerns about these terms, please contact us at support@example.com.',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}