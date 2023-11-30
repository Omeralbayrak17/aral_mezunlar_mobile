import 'package:aral_mezunlar_mobile/controller/firebase_auth_controller.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:flutter/material.dart';

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