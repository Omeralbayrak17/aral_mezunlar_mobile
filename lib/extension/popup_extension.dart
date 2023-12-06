import 'package:aral_mezunlar_mobile/controller/firebase_auth_controller.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/firebase_storage_controller.dart';
import 'flushbar_extension.dart';

class PopUpExtension{

  static void showEventDeleteConfirmationDialog(BuildContext context, String eventUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Etkinliği Sil'),
          content: const Text('Bu etkinliği silmek istiyor musunuz?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestoreController.firestoreDeleteEvent(context, eventUid);
                Navigator.of(context).pop();
                if(context.mounted) FlushbarExtension.oneMessageFlushbar(context, "Etkinlik silindi");
              },
              child: const Text('Evet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hayır'),
            ),
          ],
        );
      },
    );
  }

  static void showGalleryImageDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğrafı Sil'),
          content: const Text('Bu fotoğrafı silmek istiyor musunuz?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                try {
                  FirebaseFirestore.instance.collection('aralgaleri').doc(documentId).delete();

                  FirebaseStorageController.deleteImageFromStorage("aralgaleri", documentId);

                } catch (e) {
                  return;
                }
                Navigator.of(context).pop();
                if(context.mounted) FlushbarExtension.oneMessageFlushbar(context, "Fotoğraf silindi");
              },
              child: const Text('Evet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hayır'),
            ),
          ],
        );
      },
    );
  }

  static void showPostDeleteConfirmationDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gönderiyi Sil'),
          content: const Text('Bu gönderiyi silmek istiyor musunuz?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestoreController.firestoreDeletePost(context, postId);
                Navigator.of(context).pop();
                if(context.mounted) FlushbarExtension.oneMessageFlushbar(context, "Gönderi silindi");
              },
              child: const Text('Evet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hayır'),
            ),
          ],
        );
      },
    );
  }


  static void showForgetPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifremi Unuttum'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Lütfen e-postanızı girin"
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseAuthController.resetPassword(emailController.text);
                Navigator.of(context).pop();
                if(context.mounted) FlushbarExtension.oneMessageFlushbar(context, "Şifre Sıfırlama Talebi Gönderildi");
              },
              child: const Text('Gönder'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

}