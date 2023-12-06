import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../extension/flushbar_extension.dart';

class FirebaseFirestoreController {

  static firestoreProfileSaveChanges(String uid, String name, String surname, String about) {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'surname': surname,
      'about': about
    },);
  }

  static firestoreAddPost(String uid, BuildContext context, String post,) {
    FirebaseFirestore.instance.collection('posts').add({
      'uid': uid,
      'post': post,
      'timestamp': FieldValue.serverTimestamp()
    }).then((value) {
      FlushbarExtension.oneMessageFlushbar(context, "Gönderi eklendi");
    }).catchError((error) {
      FlushbarExtension.oneMessageFlushbar(context, "Hata: Gönderi eklenemedi");
    });
  }

  static firestoreDeletePost(BuildContext context, String documentId){

    FirebaseFirestore.instance.collection('posts').doc(documentId).delete()
        .then((value) {
      FlushbarExtension.oneMessageFlushbar(context, "Gönderi silindi");
    })
        .catchError((error) {
      FlushbarExtension.oneMessageErrorFlushbar(context, "Gönderi silinemedi");
    });

  }

  static firestoreAddEvent(String title, String message, String mapsUrl, String shareMessage, String imageUrl, DateTime eventDate){

    print("date time $eventDate");

    FirebaseFirestore.instance.collection('events').add({
      'title': title,
      'message': message,
      'locationurl': mapsUrl,
      'sharemessage': shareMessage,
      'eventimageurl': imageUrl,
      'timestamp': Timestamp.fromDate(eventDate),
    },);

  }

  static Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        String userRole = documentSnapshot['role'];
        return userRole;
      } else {
        return "Uye";
      }
    } catch (e) {
      return "Uye";
    }
  }

  static firestoreDeleteEvent(BuildContext context, String documentId){

    FirebaseFirestore.instance.collection('events').doc(documentId).delete()
        .then((value) {

    })
        .catchError((error) {
      if(context.mounted) FlushbarExtension.oneMessageFlushbar(context, "Etkinlik silindi");
    });

  }

  static firestoreAddSuggestion(BuildContext context, String uid, String message,){

    FirebaseFirestore.instance.collection('suggestions').add({
      'uid': uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp()
    },);

  }

  static Future<void> addLikeToUser(String userUid, String postUid) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users')
        .doc(userUid);

    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      List<dynamic> likes = userSnapshot['likes'] ?? [];

      if (!likes.contains(postUid)) {
        likes.add(postUid);
        await userRef.update({'likes': likes});
      }
      else{
        await userRef.update({
          'likes': FieldValue.arrayRemove([postUid])
        });
      }
    }
  }
}