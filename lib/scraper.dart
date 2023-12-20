import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_indicator/loading_indicator.dart'; // Import the loading_indicator package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Scraper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0a1034),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _title = '';
  String _body = '';
  Color _urlColor = Colors.white;
  String _predictionResult = '';
  bool _isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      _title = ''; // Clear title when fetching new data
      _body = ''; // Clear body when fetching new data
    });

    const String apiUrl = 'http://35.154.253.128/predictsimilarity';
    final String inputUrl = _urlController.text;

    if (inputUrl.isNotEmpty) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': inputUrl}),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final result = jsonDecode(response.body);
        setState(() {
          _predictionResult =
              result['phishing_probability'] >= 0.5 ? result['message'] : '';
          _urlColor =
              result['phishing_probability'] > 0.5 ? Colors.red : Colors.green;
          _isLoading = false;
        });

        if (_predictionResult.isEmpty) {
          try {
            String fetchDataUrl = 'http://35.154.253.128/getcontent';

            var fetchDataResponse = await http.post(
              Uri.parse(fetchDataUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'url': inputUrl}),
            );

            if (fetchDataResponse.statusCode == 200) {
              var data = jsonDecode(fetchDataResponse.body);
              if (data['ok'] == true) {
                setState(() {
                  _title = data['title'];
                  _body = data['body'];
                });
              } else {
                setState(() {
                  _title = '';
                  _body = 'Error: ${data['error']}';
                });
              }
            } else {
              setState(() {
                _title = '';
                _body =
                    'Request failed with status: ${fetchDataResponse.statusCode}';
              });
            }
          } catch (e) {
            setState(() {
              _title = '';
              _body = 'Error: $e';
            });
          }
        }
      } else {
        setState(() {
          _predictionResult = 'Failed to fetch prediction.';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _predictionResult = 'Please enter a URL.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Scraper'),
        backgroundColor: const Color.fromARGB(255, 42, 64, 136),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _urlController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter URL",
                  filled: true,
                  fillColor: _urlColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 105, 141, 240),
                      Color.fromARGB(255, 42, 67, 136),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: fetchData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Fetch Data'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Title: $_title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Body: $_body',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                        ),
                      ),
                    )
                  : Text(
                      _predictionResult,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
