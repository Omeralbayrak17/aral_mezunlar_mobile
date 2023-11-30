import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController{

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  static String? getCurrentUser() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
    }
  }

}