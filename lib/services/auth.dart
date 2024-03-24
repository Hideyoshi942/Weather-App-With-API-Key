import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // sign in with email & password
  Future<User?> loginUserWithEmailAndPassword(String strEmail, String strPassword) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: strEmail, password: strPassword);
      return credential.user;
    } catch (err) {
      print("Có lỗi đăng nhập: $err");
    }
  }

  // register with email & password
  Future<User?> registerUserWithEmailAndPassword(String strEmail, String strPassword) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: strEmail, password: strPassword);
      return credential.user;
    }
    catch(err){
      print("Có lỗi đăng ký: $err");
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print("Có lỗi đăng xuất: $err");
    }
  }
}
