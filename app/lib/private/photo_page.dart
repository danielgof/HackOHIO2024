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
            onPressed: () {},
            child: Text('Take Picture'),
          ),
          if (_pictureFile != null)
            Image.file(File(_pictureFile!.path)) // Display the taken picture
        ],
      ),
    );
  }
}
