import 'dart:async';
import 'package:notification_reader/notification_reader.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getPrediction(String body) async {
  var url = Uri.parse('http://35.154.253.128/predictsms');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type':
          'application/json; charset=UTF-8', // Set JSON content type
    },
    body: jsonEncode({'body': body}), // Encode data to JSON format
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    return jsonResponse['prediction'];
  } else {
    throw Exception('Failed to load prediction');
  }
}

Future<void> classifyNotification(
    NotificationData notification, Map<String, String> predictionResults) async {
  String prediction = await getPrediction(notification.body ?? "");
  predictionResults[notification.body ?? ""] = prediction;
}
