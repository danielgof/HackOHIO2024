import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:app/state.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  File? _image;
  // late String imagePath;
  // late String response;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image!) // Display the image
                : Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
