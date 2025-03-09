import 'package:firebase_auth/firebase_auth.dart';

//Used for authentication of users info with database
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(String email,String pass) async{
    try{

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: pass
      );
      return userCredential;

    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
}
