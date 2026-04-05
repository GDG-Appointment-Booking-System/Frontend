import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About SharpCut')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our Story', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'SharpCut was founded with the mission to modernize the grooming experience. '
              'We connect premium grooming services with straightforward, hassle-free booking. '
              'No more calling around—just find your perfect moment and book instantly.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Meet the Team',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Julian (Admin/Barber)'),
              subtitle: Text('Master Barber with 10 years experience.'),
            ),
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('GDG Capstone Team'),
              subtitle: Text(
                'Developers dedicated to modernizing appointment booking.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
