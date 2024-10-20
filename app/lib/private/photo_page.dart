// import 'dart:convert';
// import 'package:camera/camera.dart';
// import 'package:app/state.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class CameraWidget extends StatefulWidget {
//   @override
//   _CameraWidgetState createState() => _CameraWidgetState();
// }

// class _CameraWidgetState extends State<CameraWidget> {
//   File? _image;
//   late String imagePath;
//   late String response;

//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   XFile? _pictureFile;

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   // Initialize the camera
//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
//     await _cameraController.initialize();
//     setState(() {}); // Rebuild to show the camera preview
//   }

//   Future<void> _sendFileToServer(MyAppState state) async {
//     File imageFile = File(imagePath);
//     List<int> imageData = await imageFile.readAsBytes();
//     // Convert bytes to base64
//     String base64Image = base64Encode(imageData);
//     String result = state.preferences.toString();
//     // print(result);
//     // print(base64Image);

//     var url = Uri.parse('https://api.openai.com/v1/chat/completions');
//     var requestBody = {
//       "model": "gpt-4-vision-preview",
//       "messages": [
//         {
//           "role": "user",
//           "content": [
//             {
//               "type": "text",
//               "text": "OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written"
//                       "Is it food? IF NO RESPOND: {DO NOT EAT THAT [OBJECT]}" +
//                   "IF FOOD RESPOND:" +
//                   "HEADER[Food Name]" +
//                   "DESCRIPTION[brief decription no more then 10 words]" +
//                   "IF CONTAINS CONTENTS FROM THIS LIST: " +
//                   result +
//                   " HEADER{Your Allergens Detected:} + BULLET POINTS - [bullet points of allergens from the list]"
//                       "HEADER{Other Potential Allergens:}" +
//                   "BULLET POINTS - [bullet point specific food items or contents it is made out of that may cause allergies]" +
//                   "HEADER{Estimated Caloric Content:}" +
//                   "BULLET POINTS[Number of same food items if countable and estimated calloriesfor each]" +
//                   "HEADER{Total Calories:}" +
//                   "BULLET POINT[Estimate total calories of the all the foods]" +
//                   "DESCRIPTION[Potential health beneifts and risks of the foods no more then 50 words]"
//             },
//             {
//               "type": "image_url",
//               "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
//             }
//           ]
//         }
//       ],
//       "max_tokens": 300
//     };

//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization':
//           'Bearer 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',
//     };

//     var response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(requestBody),
//     );

//     print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
//     if (response.statusCode == 200) {
//       setResult(jsonDecode(response.body)['choices'][0]['message']['content']);
//       print(
//           'Response body: ${jsonDecode(response.body)['choices'][0]['message']['content']}');
//       setResponsePage();
//     } else {
//       print('Request failed with status: ${response.statusCode}');
//       print(response.body);
//     }
//   }

//   void setResponsePage() {
//     setState(() {
//       // state = PageType.ResponsePage;
//     });
//   }

//   void setResult(String res) {
//     setState(() {
//       // response = res;
//     });
//   }

//   // Take a picture
//   Future<void> _takePicture() async {
//     if (!_cameraController.value.isInitialized) {
//       return;
//     }

//     try {
//       final image = await _cameraController.takePicture();
//       setState(() {
//         _pictureFile = image;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image != null
//                 ? Image.file(_image!) // Display the image
//                 : Text('No image selected.'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Take Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
