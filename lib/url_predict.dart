import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'about.dart';

class UrlPredictionPage extends StatefulWidget {
  const UrlPredictionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UrlPredictionPageState createState() => _UrlPredictionPageState();
}

class _UrlPredictionPageState extends State<UrlPredictionPage> {
  TextEditingController urlController = TextEditingController();
  Color urlColor = Colors.white; // Default color for TextField background
  String predictionResult = '';
  String message = '';
  bool isLoading = false; // Track loading state

  Future<void> predictURL() async {
    setState(() {
      isLoading = true; // Set loading to true when the prediction starts
    });

    const String apiUrl = 'http://35.154.253.128/predictsimilarity';
    final String inputUrl = urlController.text;

    if (inputUrl.isNotEmpty) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': inputUrl}),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final result = jsonDecode(response.body);
        setState(() {
          message = result['message'];
          predictionResult =
              result['phishing_probability'] >= 0.5 ? message : message;
          // Update color based on prediction
          urlColor =
              result['phishing_probability'] > 0.5 ? Colors.red : Colors.green;
          isLoading =
              false; // Set loading to false after receiving the response
        });
      } else {
        setState(() {
          predictionResult = 'Failed to fetch prediction.';
          isLoading = false; // Set loading to false if the prediction fails
        });
      }
    } else {
      setState(() {
        predictionResult = 'Please enter a URL.';
        isLoading = false; // Set loading to false if no URL is entered
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 64, 136),
        elevation: 0,
        title: const Text(
          'URL Prediction',
          style: TextStyle(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            icon: const Icon(Icons.info_outline), // Icon for AboutPage
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: "Enter URL",
                filled: true,
                fillColor: urlColor, // Set background color based on prediction
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 105, 141, 240),
                    Color.fromARGB(255, 42, 67, 136),
                  ], // Replace with your gradient colors
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                onPressed: predictURL,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // Make button transparent
                  shadowColor: Colors.transparent, // Remove shadow
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Predict'),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator() // Show a loading indicator while loading
                : Text(
                    predictionResult,
                    style: const TextStyle(
                      color: Colors.white, // Set text color to white
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
