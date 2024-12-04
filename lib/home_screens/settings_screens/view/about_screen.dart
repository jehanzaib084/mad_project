import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'ℹ️ About This App\n\n'
          'Welcome to our application. This app is designed to provide users with an exceptional experience through its innovative features and user-friendly interface.\n\n'
          '✨ Features\n\n'
          '1. 🖥️ User-Friendly Interface: Our app is designed with simplicity and ease of use in mind.\n'
          '2. 🚀 High Performance: Enjoy a smooth and fast experience with our optimized app.\n'
          '3. 🔒 Secure: We prioritize your security and privacy in all aspects of the app.\n\n'
          '🎯 Our Mission\n\n'
          'Our mission is to deliver high-quality applications that meet the needs of our users and exceed their expectations. We are committed to continuous improvement and innovation.\n\n'
          '📞 Contact Us\n\n'
          'If you have any questions or feedback about this app, please contact us at support@example.com. We value your input and look forward to hearing from you.',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}