import 'package:flutter/material.dart';
import 'home_page.dart';
import 'url_predict.dart';
import 'scraper.dart'; // Import your scraper page file
import 'similar_domains.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const UrlPredictionPage(),
    const MyHomePage(), // Add your ScraperPage here
    const SimilarDomainsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0a1034),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification Prediction',
              backgroundColor: Color.fromARGB(255, 42, 64, 136),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.link),
              label: 'URL Prediction',
              backgroundColor: Color.fromARGB(255, 42, 64, 136),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.agriculture),
              label: 'Scraper',
              backgroundColor: Color.fromARGB(255, 42, 64, 136),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Similar Domains',
              backgroundColor: Color.fromARGB(255, 42, 64, 136),
            )
          ],
        ),
      ),
    );
  }
}
