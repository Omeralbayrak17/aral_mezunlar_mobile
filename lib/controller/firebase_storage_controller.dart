import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageController{

  static Future<String> downloadUserProfileImage(String uid) async {

    final Reference ref = FirebaseStorage.instance.ref().child('profiles/$uid');

    if(uid.length > 10){

      final String url = await ref.getDownloadURL();
      return url;

    }
    else{

      final Reference defaultRef = FirebaseStorage.instance.ref().child('profiles/default.jpg');
      return defaultRef.getDownloadURL();

    }

  }

  static Future<String> downloadUserBannerImage(String uid) async {

    final Reference ref = FirebaseStorage.instance.ref().child('profilebanners/$uid');


    if(uid != ""){
      final String url = await ref.getDownloadURL();
      return url;
    }
    else{
      final Reference defaultRef = FirebaseStorage.instance.ref().child('profiles/default.jpg');
      return defaultRef.getDownloadURL();
    }

  }

  static Future<String> downloadEventImage(String imageType) async {

    final Reference ref = FirebaseStorage.instance.ref().child('events/$imageType.jpg');

      final String url = await ref.getDownloadURL();
      return url;
  }

}