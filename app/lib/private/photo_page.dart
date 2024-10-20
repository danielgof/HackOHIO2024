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
    String userSex = "Male";
    String userName = "Brutus Buckeye";
    String userAge = "25";
    String userHealthRisks = "Allergies";
    String txt =
        "DESCRIPTION: you are a helpful health AI which will analyze injuries from a photo and give advice for the user. OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written. Is there an injury? IF NO RESPOND: {no injuries detected :D stay safe} IF INJURY RESPOND: BULLET POINTS - " +
            userName +
            " " +
            userAge +
            " " +
            userSex +
            " HEADER[Injury Name] DESCRIPTION[brief description no more than 10 words] IF CONTAINS CONTENTS FROM THIS LIST: " +
            userHealthRisks +
            " HEADER{Your Health Risks Detected:} + BULLET POINTS - [bullet points of health risks if they can be affected by injury or if the injury was caused by them] HEADER{Other Health Risks if not treated:} BULLET POINTS - [steps to take to treat the injury] Is the injury serious? HEADER{Estimated recovery time:} BULLET POINTS[Estimated recovery time and how much faster recovery will be if treated properly]";
    
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var requestBody = {
      "model": "gpt-4o-mini",
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
      'Authorization': 'Bearer sk-KZH5IMALdV2J2KhmBFx_V846ABm5WaEjhepFY2t53zT3BlbkFJ0tAE082wxBTmHGjw0PsxxUrwhT3Ju3CtN-jXF5f-sA',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setResult(json.decode(response.body)['choices'][0]['message']['content']);
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
        appBar: AppBar(
          title: const Text('Boo-boo scan'),
          // backgroundColor: Colors.blue,
        ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.9, // Responsive width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 10.0,
                  shadowColor: Colors.blueAccent,
                ),
                child: Icon(Icons.camera_alt, size: 50.0),
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Analysis Result",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              response,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: setCameraPage,
              icon: Icon(Icons.home, color: Colors.white),
              label: Text('Retake', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
