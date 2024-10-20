import 'package:app/private/photo_page.dart';
import 'package:flutter/material.dart';
import 'package:app/private/ai_text.dart';
// import 'package:app/private/audio_input.dart'; // Assuming you have a widget for handling microphone input

class AiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Camera Input Page')),
        body: Column(
          children: [
            // Top section with Camera and Text buttons
            Expanded(
              child: Row(
                children: [
                  // Camera Button
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
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
                          backgroundColor: Colors.white,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt, // Camera icon
                            size: 100.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text Input Button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatWidget(), // Navigate to ChatWidget
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 2.0,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.message, // Text icon
                            size: 100.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer to push the microphone button to the bottom
            Spacer(),
            // Microphone Button at the bottom
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Uncomment and add navigation when the widget is ready
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AudioInputWidget(), // Navigate to AudioInputWidget
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.mic, // Microphone icon
                    size: 100.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
