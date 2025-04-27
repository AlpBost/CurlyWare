import 'package:flutter/material.dart';
import 'package:jjj/auth/auth_service.dart';
import 'package:jjj/chat/chat_service.dart';
import 'package:jjj/chat/user_tile.dart';
import 'chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load users from Firestore
  void _loadUsers() async {
    try {
      final users = await _chatService.getUsers();
      setState(() {
        _users = users
            .where((userData) => userData["email"] != _authService.getCurrentUser())
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
          ? const Center(child: Text("Error loading users"))
          : _users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final userData = _users[index];
          return _buildUserListItem(userData, context);
        },
      ),
    );
  }

  // Build a user tile for each user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["email"],
      onTap: () {
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
