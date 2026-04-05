import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('Email Us'),
              subtitle: Text('support@sharpcut.demo.com'),
            ),
            const ListTile(
              leading: Icon(Icons.phone_outlined),
              title: Text('Call Us'),
              subtitle: Text('+1 (555) 123-4567'),
            ),
            const SizedBox(height: 24),
            Text(
              'Send us a message',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message sent successfully! (Mock)'),
                    ),
                  );
                },
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
