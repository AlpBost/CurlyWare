import 'package:flutter/material.dart';
import 'package:jjj/auth/auth_service.dart';
import 'package:jjj/bottombar.dart';
import 'package:jjj/chat/chat_service.dart';
import 'package:jjj/chat/user_tile.dart';
import 'package:jjj/pages/mainpage/projecttypes.dart';
import 'package:jjj/pages/mainpage/tasks.dart';
import 'package:jjj/pages/reportpage/reportspage.dart';

import 'chat_page.dart';




class MessagePage extends StatelessWidget{
   MessagePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(title: Text("Message123"),),
      body: _buildUserList(),

        );
    }

    Widget _buildUserList(){
      return StreamBuilder(
          stream: _chatService.getUsersStram(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              return const Text("Error");
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Text("Loading...");
            }

            return ListView(
              children: snapshot.data!.map<Widget>((userData)=> _buildUserListItem(userData,context)).toList(),);
          });
    }

    Widget _buildUserListItem(Map<String,dynamic> userData,BuildContext context){
      if(userData["email"] !=_authService.getCurrentUser()){
        return UserTile(
            text: userData["email"],
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=> ChatPage(
                      recieveEmail: userData["email"],
                      recieverId: userData["uid"],
                    ),));
            });
      }else{
        return Container();
      }
      }
}