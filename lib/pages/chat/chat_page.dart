import 'package:flutter/material.dart';
import 'package:jjj/auth/auth_service.dart';
import 'package:jjj/pages/chat/chat_service.dart';

// This page shows the chat screen
class ChatPage extends StatefulWidget {
  // These are the email and ID of the person we are talking to
  final String recieveEmail;
  final String recieverId;

  ChatPage({super.key, required this.recieveEmail, required this.recieverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // This is the controller for the message input box
  final TextEditingController _messageController = TextEditingController();
  // ChatService helps to get and send messages
  final ChatService _chatService = ChatService();
  // AuthService gives us the current user
  final AuthService _authService = AuthService();

  // This list stores messages
  List<Map<String, dynamic>> _messages = [];
  // This checks if we are still loading the messages
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // We get the messages when the page starts
    _fetchMessages();
  }

  // This function gets messages from the server
  Future<void> _fetchMessages() async {
    try {
      // Get current user's ID
      String senderId = _authService.getCurrentUser()!.uid;
      // Get messages between users
      List<Map<String, dynamic>> messages = await _chatService.getMessagesOnce(widget.recieverId, senderId);
      setState(() {
        _messages = messages; // Save messages
        _isLoading = false;   // We are done loading
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // This function sends the message
  void sendMessage() async {
    // Check if the message is not empty
    if (_messageController.text.isNotEmpty) {
      // Send the message
      await _chatService.sendMessage(widget.recieverId, _messageController.text);
      // Clear the input box
      _messageController.clear();
      // Get new messages again
      _fetchMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the receiver's email in the title
      appBar: AppBar(title: Text(widget.recieveEmail.split('@').first)),
      body: Column(
        children: [
          // Show messages or loading circle
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),
          // Show the message input box
          _buildUserInput(),
        ],
      ),
    );
  }

  // This function builds one message item
  Widget _buildMessageItem(Map<String, dynamic> data) {
    // Check if the message is from current user
    bool isCurrentUser = data["senderId"] == _authService.getCurrentUser()!.uid;

    // Align the message to left or right
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var crossAxisAlignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Blue for your messages, grey for others
              color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data["message"] ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // This function shows the message input box and send button
  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Message text input
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message...', // Placeholder text
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              obscureText: false,
              textInputAction: TextInputAction.send,
              // Send message when user presses enter
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          // Send button (arrow icon)
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
