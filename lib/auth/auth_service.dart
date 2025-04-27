import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Used for authentication of users info with database
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This function signs in the user using email and password
  Future<UserCredential> signInWithEmailPassword(String email,String pass) async{
    try{

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: pass
      );

      // Save user info (uid and email) to Firestore database
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
  User? getCurrentUser(){
    return _auth.currentUser;
  }

}
