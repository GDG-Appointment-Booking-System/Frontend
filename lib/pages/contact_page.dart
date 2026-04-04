import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '// TODO(team): Add support phone, email, and optional contact form.',
        ),
      ),
    );
  }
}
