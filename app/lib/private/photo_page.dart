import 'dart:convert'; // For Base64 encoding
import 'dart:io'; // For File I/O
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
    String userSex = "";
    String userName = "";
    String userAge = "";
    String userHealthRisks = "";

    String txt =
        "DESCRIPTION: you are a helpfull health AI which will analyze injurys from a photo and give advice for the user OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written is there an injury? IF NO RESPOND: {no injurys detected :D stay safe} IF INJURY RESPOND: BULLET POINTS - " +
            userName +
            userAge +
            userSex +
            " HEADER[Injury Name] DESCRIPTION[brief decription no more then 10 words] IF CONTAINS CONTENTS FROM THIS LIST: " +
            userHealthRisks +
            " HEADER{Your Health Risks Detected:} + BULLET POINTS - [bullet points of health risks from the list] HEADER{Other Health Risks if not treated:} BULLET POINTS - [steps to take to treat the injury] is injury serious? IF YES RESPONS: HEADER{THIS IS A SERIOUS INJURY CALL 911 IMIDIETLY} HEADER{Estimated recovery time:} BULLET POINTS[Estimated recovery time for the user and how much faster the recovery will be if treated properly]";
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var requestBody = {
      "model": "gpt-4-vision-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": txt,
            },
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
          'Bearer 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',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('ChatGPT Response: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void setResponsePage() {
    setState(() {
      // state = PageType.ResponsePage;
    });
  }

  void setResult(String res) {
    setState(() {
      // response = res;
    });
  }

  // Take a picture
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
