import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jjj/chat/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch all users except the current user
  Future<List<Map<String, dynamic>>> getUsers() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Get all users from Firestore
    final snapshot = await FirebaseFirestore.instance.collection("Users").get();
    final allUsers = snapshot.docs.map((doc) => doc.data()).toList();

    // Filter out the current user from the list
    final otherUsers = allUsers.where((user) => user["uid"] != currentUserId).toList();

    return otherUsers;
  }

  // Send a message to another user in the chat room
  Future<void> sendMessage(String recieverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: recieverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, recieverId];
    ids.sort(); // Sort to ensure the chat room ID is consistent
    String chatRoomId = ids.join("_");

    // Add the message to the Firestore chat room
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Fetch all messages in a chat room once
  Future<List<Map<String, dynamic>>> getMessagesOnce(String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Get all messages from the Firestore chat room
    QuerySnapshot snapshot = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
