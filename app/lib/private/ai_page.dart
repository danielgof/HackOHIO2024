import 'package:app/private/photo_page.dart';
import 'package:flutter/material.dart';

class AiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Camera Input Page')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Camera Button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraWidget(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt, // Camera icon
                            size: 100.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text Input Box
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add chat functionality
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.message, // chat icon
                            size: 100.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
