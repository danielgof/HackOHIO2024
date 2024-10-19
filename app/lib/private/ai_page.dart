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
                          // Add camera functionality
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
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text here',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add submit functionality
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Text('Submit'),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
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
