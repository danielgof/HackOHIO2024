import 'package:flutter/material.dart';

class MessagingPagePublic extends StatelessWidget {
  const MessagingPagePublic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdfe4d7),  // Set background color to green
      body: const SafeArea(
        child: Center(
          child: Text(
            'Please, log in to see your messages',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
