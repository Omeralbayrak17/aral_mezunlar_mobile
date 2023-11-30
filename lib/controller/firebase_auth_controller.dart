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

}