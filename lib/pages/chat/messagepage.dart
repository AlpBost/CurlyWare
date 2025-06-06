import 'package:flutter/material.dart';
import 'package:jjj/auth/auth_service.dart';
import 'package:jjj/pages/chat/chat_service.dart';
import 'package:jjj/pages/chat/user_tile.dart';
import 'chat_page.dart';

// This page shows the list of users to chat with
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // ChatService helps us get users
  final ChatService _chatService = ChatService();
  // AuthService gives us the current user
  final AuthService _authService = AuthService();

  // This list stores other users
  List<Map<String, dynamic>> _users = [];
  // This checks if users are loading
  bool _isLoading = true;
  // This checks if there is an error
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Get users when page opens
    _loadUsers();
  }

  // This function gets users from Firestore
  void _loadUsers() async {
    try {
      final users = await _chatService.getUsers();
      setState(() {
        // Remove current user from the list
        _users = users
            .where((userData) => userData["email"] != _authService.getCurrentUser())
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        // Show error if something went wrong
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Page title
      appBar: AppBar(title: const Text("Messages")),
      body: _isLoading
      // Show loading circle
          ? const Center(child: CircularProgressIndicator())
      // Show error message
          : _isError
          ? const Center(child: Text("Error loading users"))
      // Show message if no users found
          : _users.isEmpty
          ? const Center(child: Text("No users found"))
      // Show the user list
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final userData = _users[index];
          return _buildUserListItem(userData, context);
        },
      ),
    );
  }

  // This function builds a user item in the list
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["email"], // Show user email
      onTap: () {
        // When user is tapped, go to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              recieveEmail: userData["email"],
              recieverId: userData["uid"],
            ),
          ),
        );
      },
    );
  }
}
