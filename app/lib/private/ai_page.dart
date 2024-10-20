import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app/private/photo_page.dart'; // Assuming this is your camera page
import 'package:app/private/ai_text.dart'; // Assuming this is your text input page

class AiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space between widgets
          children: [
            // Top section with Camera and Text buttons
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row
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
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 8.0,
                          shadowColor: Colors.black26,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 80.0,
                              color: Colors.green,
                            ),
                            SizedBox(
                                height: 8.0), // Space between icon and text
                            Text(
                              'Camera',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                              builder: (context) => ChatWidget(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 8.0,
                          shadowColor: Colors.black26,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message,
                              size: 80.0,
                              color: Colors.green,
                            ),
                            SizedBox(
                                height: 8.0), // Space between icon and text
                            Text(
                              'Text Input',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer to push the microphone button to the bottom
            Spacer(flex: 1),
            // Microphone Button at the bottom
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showRecordingDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 8.0,
                      shadowColor: Colors.black26,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic,
                          size: 80.0,
                          color: Colors.green,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Microphone',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the alert dialog and start recording
  void _showRecordingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Recording"),
          content: Text("Audio recording has started..."),
          actions: [
            TextButton(
              onPressed: () {
                // Stop recording and analyze results
                Navigator.of(context).pop();
                _analyzeAudio(
                    context); // Show analysis result after recording stops
              },
              child: Text("Stop Recording"),
            ),
          ],
        );
      },
    );
    // Simulate audio recording start
    _startAudioRecording();
  }

  // Placeholder function for starting audio recording
  void _startAudioRecording() {
    // Actual audio recording logic should go here
    print("Audio recording started...");
  }

  // Function to analyze audio and show a result dialog
  void _analyzeAudio(BuildContext context) {
    // Simulate analyzing the audio and generating a percentage of certainty
    final Random random = Random();
    int certaintyPercentage =
        random.nextInt(41) + 60; // Generates a number between 60 and 100
    bool isDrunk = certaintyPercentage >=
        80; // Simulate "drunk" if certainty is 80% or more

    String resultMessage = isDrunk
        ? "You might be drunk with $certaintyPercentage% certainty."
        : "You seem sober with $certaintyPercentage% certainty.";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Analysis Result"),
          content: Text(resultMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
