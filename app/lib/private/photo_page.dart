import 'dart:convert';  // For Base64 encoding
import 'dart:io';       // For File I/O
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // To make the HTTP request

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras
    cameras = await availableCameras();

    if (cameras != null && cameras!.isNotEmpty) {
      // Initialize the first available camera
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller?.initialize();

      if (!mounted) return;

      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Convert image to Base64 string
  Future<String> _convertImageToBase64(XFile image) async {
    final bytes = await File(image.path).readAsBytes(); // Read file as bytes
    return base64Encode(bytes); // Convert to Base64 string
  }

  // Send Base64 string to ChatGPT API
  Future<void> _sendToChatGPT(String base64Image) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_KEY', // Replace with your API key
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'user', 'content': 'This is an image in Base64: $base64Image'},
        ],
      }),
    );

    if (response.statusCode == 200) {
      print('ChatGPT Response: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Take a picture
      final image = await _controller!.takePicture();
      setState(() {
        imageFile = image;
      });

      // Convert image to Base64 and send to ChatGPT
      final base64Image = await _convertImageToBase64(image);
      await _sendToChatGPT(base64Image);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture here'),
      ),
      body: Column(
        children: [
          Center(
            child: Expanded(
              child: _controller != null && _controller!.value.isInitialized
                  ? CameraPreview(_controller!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (imageFile != null)
            Image.file(
              File(imageFile!.path),
              width: 100,
              height: 100,
            ),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Capture Image'),
          ),
        ],
      ),
    );
  }
}
