import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(
        name: 'Dr. Alice Johnson, MD',
        lastMessage:
            "I’m glad to hear that! Let's keep working on a healthy diet and exercise."),
    Contact(
        name: 'Nurse Bob Smith',
        lastMessage: 'Please remember to take your medication.'),
    Contact(
        name: 'Dr. Charlie Brown, PhD',
        lastMessage: 'Can you confirm your appointment for next week?'),
    Contact(
        name: 'Dr. Daisy Ridley, MD',
        lastMessage: 'Let’s discuss your treatment options.'),
    // Add more contacts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFf5f5f5), // Lighter background color for contrast
      appBar: AppBar(
        title: Text('Messages',
            style: TextStyle(color: Colors.black)), // Change title color
        backgroundColor: const Color(0xFFdfe4d7),
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 214, 211, 211),
            width: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black), // Change icon color
            onPressed: () {
              // Add functionality here
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
          color: Color.fromARGB(255, 214, 211, 211),
          width: 1.0,
        ),
      ),
      title: Text(contact.name,
          style: TextStyle(fontWeight: FontWeight.bold)), // Bold name
      subtitle: Text(contact.lastMessage,
          style: TextStyle(
              color: Colors.grey[600])), // Grey color for last message
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingScreen(),
          ),
        );
      },
    );
  }
}

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<MessageBubbleData> messages = [
    MessageBubbleData(
      text: 'Hello, this is Dr. Alice. How can I assist you today?',
      isMe: false,
    ),
    MessageBubbleData(
      text: 'Hi Dr. Alice! I have some questions about my recent test results.',
      isMe: true,
    ),
    MessageBubbleData(
      text:
          'Of course! Your test results indicate everything is normal, but let’s discuss any concerns you might have.',
      isMe: false,
    ),
    MessageBubbleData(
      text: 'That’s a relief! I was worried about my cholesterol levels.',
      isMe: true,
    ),
    MessageBubbleData(
      text:
          "I’m glad to hear that! Let's keep working on a healthy diet and exercise.",
      isMe: false,
    ),
  ];

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        messages
            .add(MessageBubbleData(text: text, isMe: true)); // Add sent message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages',
            style: TextStyle(color: Colors.black)), // Change title color
        backgroundColor: const Color(0xFFdfe4d7),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding:
                  EdgeInsets.symmetric(vertical: 10.0), // Add vertical padding
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  text: messages[index].text,
                  isMe: messages[index].isMe,
                );
              },
            ),
          ),
          MessageInputField(onSend: _sendMessage), // Pass the callback function
        ],
      ),
    );
  }
}

class MessageBubbleData {
  final String text;
  final bool isMe;

  MessageBubbleData({required this.text, required this.isMe});
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
          color: isMe ? const Color(0xFFdfe4d7) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isMe
              ? [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
              : [], // Add shadow to messages from user
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final Function(String) onSend; // Callback function for sending messages

  MessageInputField({Key? key, required this.onSend}) : super(key: key);

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
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0), // Padding inside text field
              ),
            ),
          ),
          IconButton(
            icon:
                Icon(Icons.send, color: Colors.green), // Change send icon color
            onPressed: () {
              onSend(_controller.text); // Call the onSend function
              _controller.clear(); // Clear the input field
            },
          ),
        ],
      ),
    );
  }
}
