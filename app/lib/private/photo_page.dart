import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:app/state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  // File? _image;
  // late String imagePath;
  // late String response;

  // Future<void> _sendFileToServer(MyAppState state) async {
  //   File imageFile = File(imagePath);
  //   List<int> imageData = await imageFile.readAsBytes();
  //   // Convert bytes to base64
  //   String base64Image = base64Encode(imageData);
  //   String result = state.preferences.toString();

  //   var url = Uri.parse('https://api.openai.com/v1/chat/completions');
  //   var requestBody = {
  //     "model": "gpt-4-vision-preview",
  //     "messages": [
  //       {
  //         "role": "user",
  //         "content": [
  //           {
  //             "type": "text",
  //             "text": "OUTPUT PARAMETERS: HEADER - bolded, DESCRIPTION - italic, BRACKETS - description of what to write, CURLY BRACKETS - as written"
  //                     "Is it food? IF NO RESPOND: {DO NOT EAT THAT [OBJECT]}" +
  //                 "IF FOOD RESPOND:" +
  //                 "HEADER[Food Name]" +
  //                 "DESCRIPTION[brief decription no more then 10 words]" +
  //                 "IF CONTAINS CONTENTS FROM THIS LIST: " +
  //                 result +
  //                 " HEADER{Your Allergens Detected:} + BULLET POINTS - [bullet points of allergens from the list]"
  //                     "HEADER{Other Potential Allergens:}" +
  //                 "BULLET POINTS - [bullet point specific food items or contents it is made out of that may cause allergies]" +
  //                 "HEADER{Estimated Caloric Content:}" +
  //                 "BULLET POINTS[Number of same food items if countable and estimated calloriesfor each]" +
  //                 "HEADER{Total Calories:}" +
  //                 "BULLET POINT[Estimate total calories of the all the foods]" +
  //                 "DESCRIPTION[Potential health beneifts and risks of the foods no more then 50 words]"
  //           },
  //           {
  //             "type": "image_url",
  //             "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
  //           }
  //         ]
  //       }
  //     ],
  //     "max_tokens": 300
  //   };
  // }

  // Future<void> _takePicture() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Camera Example'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           _image != null
  //               ? Image.file(_image!) // Display the image
  //               : Text('No image selected.'),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: _takePicture,
  //             child: Text('Take Picture'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  XFile? _pictureFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // Initialize the camera
  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {}); // Rebuild to show the camera preview
  }

  // Take a picture
  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController.takePicture();
      setState(() {
        _pictureFile = image;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController) // Show the camera preview
                : Center(child: CircularProgressIndicator()), // Loading state
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Take Picture'),
          ),
          if (_pictureFile != null)
            Image.file(File(_pictureFile!.path)) // Display the taken picture
        ],
      ),
    );
  }
}
