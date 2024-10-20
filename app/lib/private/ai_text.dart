import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = []; // List to hold messages
  String? apiKey;

  Future<void> sendMessage(String message) async {
    // Add user message to the list
    setState(() {
      _messages.add(Message(content: message, isUser: true));
    });
    String userSex = "Male";
    String userName = "Brutus Buckeye";
    String userAge = "25";
    String userHealthRisks = "Allregies";

    final formattedMessage =
        'The users name is $userName, age: $userAge, sex: $userSex, and they have these health risks: $userHealthRisks, as a medical professional, please respond to the following inquiry: $message';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ', // Use your API key
      },
      body: json.encode({
        'model': 'gpt-4o-mini', // Make sure this is a valid model
        'messages': [
          {'role': 'user', 'content': formattedMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Add ChatGPT's response to the list
      setState(() {
        _messages.add(Message(
            content: data['choices'][0]['message']['content'], isUser: false));
      });
    } else {
      setState(() {
        _messages.add(
            Message(content: 'Error: ${response.statusCode}', isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask Advice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _messages
                      .map((message) => _buildMessageBubble(message))
                      .toList(),
                ),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build message bubbles
  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft, // Align based on user
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0), // Add horizontal margin for spacing
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

// Message class to represent a chat message
class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
