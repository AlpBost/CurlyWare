import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Used for authentication of users info with database
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailPassword(String email,String pass) async{
    try{

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: pass
      );
      //uid is user id
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          'email':email,
        }
      );
      return userCredential;

    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  String? getCurrentUser(){
    return _auth.currentUser?.email;
  }
}
