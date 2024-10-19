import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: 'Dr. Alice Johnson, MD', lastMessage: 'Your test results are ready.'),
    Contact(name: 'Nurse Bob Smith', lastMessage: 'Please remember to take your medication.'),
    Contact(name: 'Dr. Charlie Brown, PhD', lastMessage: 'Can you confirm your appointment for next week?'),
    Contact(name: 'Dr. Daisy Ridley, MD', lastMessage: 'Let’s discuss your treatment options.'),
    // Add more contacts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdfe4d7),
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: const Color(0xFFdfe4d7),
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 214, 211, 211), // Set the color of the bottom border
            width: 1.0, // Set the width of the border
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add), // Plus icon
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactTile(contact: contacts[index]);
        },
      ),
    );
  }
}

class Contact {
  final String name;
  final String lastMessage;

  Contact({
    required this.name,
    required this.lastMessage,
  });
}

class ContactTile extends StatelessWidget {
  final Contact contact;

  const ContactTile({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
        bottom: BorderSide(
          color: Color.fromARGB(255, 214, 211, 211), // Set the color of the bottom border
          width: 1.0, // Set the width of the border
        ),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.lastMessage),
      onTap: () {
        // Navigate to the messaging screen for this contact
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingScreen(contact: contact),
          ),
        );
      },
    );
  }
}

class MessagingScreen extends StatelessWidget {
  final Contact contact;

  const MessagingScreen({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        backgroundColor: const Color(0xFFdfe4d7),
      ),
      body: Center(
        child: Text('Chat with ${contact.name}'), // Placeholder for messaging UI
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageBubble({Key? key, required this.text, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Handle send button pressed
              print('Message sent: ${_controller.text}');
              _controller.clear(); // Clear the input field
            },
          ),
        ],
      ),
    );
  }
}
