import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget{
  final String recieveEmail;
  const ChatPage({
    super.key,
    required this.recieveEmail,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recieveEmail),),
    );
  }
}