import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? resultText; // To store the classification result
  File? selectedFile; // To store the uploaded file
  Uint8List? imageBytes; // Binary data for the spectrogram image

  final String classifyEndpoint = 'http://10.0.2.2:5000/classify';
  final String spectrogramEndpoint = 'http://10.0.2.2:5000/image';

  @override
  void initState() {
    super.initState();
    resultText = null;
  }

  void clearOutput() {
    setState(() {
      resultText = null;
      selectedFile = null;
      imageBytes = null;
    });
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected successfully!')),
      );
    }
  }

  Future<void> fetchSpectrogram() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file first!')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(spectrogramEndpoint),
      );
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedFile!.path));
      var response = await request.send().timeout(
        const Duration(seconds: 180),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      ;
      await Future.delayed(const Duration(seconds: 5));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        log(responseData.toString());
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          imageBytes = responseData.bodyBytes;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch spectrogram!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching spectrogram: $e')),
      );
    }
  }

  Future<void> fetchResult() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file first!')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(classifyEndpoint));
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedFile!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        setState(() {
          resultText = jsonResponse['class'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch classification result!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching result: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spectrogram & Classification'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Analysis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: uploadFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: fetchSpectrogram,
                icon: const Icon(Icons.image),
                label: const Text('View Spectrogram'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: fetchResult,
                icon: const Icon(Icons.insights),
                label: const Text('View Classification Result'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: clearOutput,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (imageBytes != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Spectrogram:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.memory(imageBytes!),
                  ],
                ),
              if (resultText != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Classification Result:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      resultText!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
