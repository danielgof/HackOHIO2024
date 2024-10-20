import 'dart:convert'; // For Base64 encoding
import 'dart:io'; // For File I/O
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // To make the HTTP request

enum PageType {
  CameraPage,
  PicturePage,
  WaitPage,
  ResponsePage,
}

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  XFile? imageFile;
  PageType state = PageType.CameraPage; // Set initial state to CameraPage
  late String response;
  late String imagePath;
  late Future<void> _initializeControllerFuture;

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
      _initializeControllerFuture = _controller!.initialize();

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
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var requestBody = {
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "user",
          "content": [
            {"type": "text", "text": "Some text here"}, // Example
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
            }
          ]
        }
      ],
      "max_tokens": 300
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setResult(jsonDecode(response.body)['choices'][0]['message']['content']);
      setResponsePage();
    } else {
      print('Error: ${response.statusCode}');
      print(response.body);
    }
  }

  void setWaitPage() {
    setState(() {
      state = PageType.WaitPage;
    });
  }

  void setResponsePage() {
    setState(() {
      state = PageType.ResponsePage;
    });
  }

  void setCameraPage() {
    setState(() {
      state = PageType.CameraPage;
    });
  }

  void setResult(String res) {
    setState(() {
      response = res;
    });
  }

  // Take a picture and start the process
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Take a picture
      final image = await _controller!.takePicture();
      setState(() {
        imageFile = image;
        imagePath = image.path;
      });

      // Switch to wait page
      setWaitPage();

      // Convert image to Base64 and send to ChatGPT
      final base64Image = await _convertImageToBase64(image);
      await _sendToChatGPT(base64Image);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Camera Input')),
        body: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case PageType.CameraPage:
        return _buildCameraPreview();
      case PageType.WaitPage:
        return _buildWaitPage();
      case PageType.ResponsePage:
        return _buildResponsePage();
      default:
        return Container();
    }
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    child: Center(child: CameraPreview(_controller!)),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: ElevatedButton(
                      onPressed: _takePicture,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Icon(Icons.camera_alt,
                          size: 100.0, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  Widget _buildWaitPage() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildResponsePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            response,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          ElevatedButton(
            onPressed: () {
              setCameraPage();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Icon(Icons.home, size: 100.0, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
