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

  static Future<String> downloadImageFromStorage(String folderName, String imageName) async {

    final Reference ref = FirebaseStorage.instance.ref().child('$folderName/$imageName.jpg');

    final String url = await ref.getDownloadURL();
    return url;
  }

  static Future<List<String>> getAllDownloadUrls(String folderPath) async {
    try {
      List<String> downloadUrls = [];
      Reference storageReference = FirebaseStorage.instance.ref().child(folderPath);

      ListResult result = await storageReference.listAll();

      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  static Future<void> deleteImageFromStorage(String collection, String documentId) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(collection).child("$documentId.jpg");
      await storageReference.delete();
    } catch (e) {
      return;
    }
  }

}