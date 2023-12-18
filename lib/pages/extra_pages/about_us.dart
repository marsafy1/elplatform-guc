import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/configs/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About $appName"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ElPlatform App',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to ElPlatform, your go-to app for all things GUC!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: Text('1. Confessions'),
                subtitle:
                    Text('Post anonymously or as yourself. Comment on posts.'),
              ),
              ListTile(
                title: Text('2. Academic Questions'),
                subtitle: Text(
                    'Ask about courses, books, professors, and rate them. Image upload allowed.'),
              ),
              ListTile(
                title: Text('3. Lost and Found'),
                subtitle:
                    Text('Post about lost and found items. Images allowed.'),
              ),
              ListTile(
                title: Text('4. Offices and Outlets'),
                subtitle: Text(
                    'Search for professors, TAs, offices, food outlets, and get directions.'),
              ),
              ListTile(
                title: Text('5. Important Phone Numbers'),
                subtitle: Text(
                    'Search and call important numbers directly from the app.'),
              ),
              ListTile(
                title: Text('6. News, Events, and Clubs'),
                subtitle:
                    Text('User-approved content. Posts can contain images.'),
              ),
              SizedBox(height: 16),
              Text(
                'Developers:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('- Mohamed Khalid', style: TextStyle(fontSize: 16)),
              Text('- Abdelarhman Elsalh', style: TextStyle(fontSize: 16)),
              Text('- Ahmed Nasser', style: TextStyle(fontSize: 16)),
              Text('- Ziad Sadek', style: TextStyle(fontSize: 16)),
              // Add more team members if applicable
            ],
          ),
        ),
      ),
    );
  }
}
