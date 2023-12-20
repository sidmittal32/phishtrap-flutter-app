import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 64, 136),
        title: const Text('About PhishTrap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: About Page
              const Text(
                'About Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color set to white
                ),
              ),

              const SizedBox(height: 15),

              // Description: PhishTrap
              const Text(
                'PhishTrap is a powerful system of browser extension and application designed to help protect you from phishing attacks.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color set to white
                ),
              ),

              const SizedBox(height: 20),

              // Main Points Section
              const Text(
                'One Stop Solution to Phishing Security',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color set to white
                ),
              ),
              const SizedBox(height: 10),
              // List of main points
              _buildListItem('The main \'thrust\' is to focus on the development of a robust and accurate system that can effectively detect and prevent phishing attacks.'),
              _buildListItem('URL Analysis'),
              _buildListItem('Content Analysis'),
              _buildListItem('Real-Time Detection'),
              _buildListItem('Website Analysis'),
              _buildListItem('Page Ranking'),
              _buildListItem('Machine Learning'),

              const SizedBox(height: 20),

              // Detailed Points Section
              const Text(
                'Robust and Accurate Detection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color set to white
                ),
              ),
              const SizedBox(height: 10),
              // List of detailed points with sub-bullets
              _buildSubListItem('A combination of advanced ML techniques and feature engineering.'),
              _buildSubListItem('Real-time analysis of website content and user behavior.'),

              const SizedBox(height: 20),

              // Usability and User Feedback
              const Text(
                'Usability and User Feedback',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color set to white
                ),
              ),
              const SizedBox(height: 10),
              // List of points under Usability and User Feedback
              _buildSubListItem('Designed with usability in mind.'),
              _buildSubListItem('Provides clear and actionable feedback.'),
              _buildSubListItem('Allows users to report suspicious activity.'),

              const SizedBox(height: 20),

              // Evolving Threat Protection
              const Text(
                'Evolving Threat Protection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color set to white
                ),
              ),
              const SizedBox(height: 10),
              // List of points under Evolving Threat Protection
              _buildSubListItem('Regularly updated and maintained.'),
              _buildSubListItem('Effective against evolving threats.'),
              _buildSubListItem('Protects against identity theft, financial loss, and data breaches.'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create a bullet point
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.brightness_1, size: 8, color: Colors.white), // Icon color set to white
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white), // Text color set to white
            ),
          ),
        ],
      ),
    );
  }

  // Widget to create a sub-bullet point
  Widget _buildSubListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.arrow_right, size: 18, color: Colors.white), // Icon color set to white
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white), // Text color set to white
            ),
          ),
        ],
      ),
    );
  }
}
