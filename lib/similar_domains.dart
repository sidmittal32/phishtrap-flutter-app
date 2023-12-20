// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class SimilarDomainsPage extends StatefulWidget {
  const SimilarDomainsPage({Key? key}) : super(key: key);

  @override
  _SimilarDomainsPageState createState() => _SimilarDomainsPageState();
}

class _SimilarDomainsPageState extends State<SimilarDomainsPage> {
  TextEditingController urlController = TextEditingController();
  File? uploadedFile;
  List<dynamic>? similarities;
  bool isLoading = false;

  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
    });

    // Replace this with your actual API endpoint
    Uri uploadUrl = Uri.parse('http://35.154.253.128/findsimilar');

    var request = http.MultipartRequest('POST', uploadUrl);
    request.files.add(await http.MultipartFile.fromPath('file', uploadedFile!.path));
    request.fields['url'] = urlController.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      setState(() {
        similarities = json.decode(responseData);
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Similar Domains'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        uploadedFile = File(result.files.single.path!);
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text('Upload File'),
                ),
                if (uploadedFile != null)
                  Text(
                    'File Selected: ${uploadedFile!.path.split('/').last}',
                    style: const TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (uploadedFile != null && urlController.text.isNotEmpty) {
                  await _uploadFile();
                } else {
                  // Handle case when URL or file is not selected
                }
              },
              child: const Text('Check Similarity'),
            ),
            const SizedBox(height: 20.0),
            if (isLoading)
              const CircularProgressIndicator() // Show loading indicator when fetching data
            else if (similarities != null)
              Expanded(
                child: ListView.builder(
                  itemCount: similarities!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(similarities![index][0]),
                      subtitle: Text('Similarity: ${similarities![index][1].toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
