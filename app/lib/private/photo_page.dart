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
