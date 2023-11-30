import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSuggestionView extends StatefulWidget {
  const AddSuggestionView({super.key});

  @override
  State<AddSuggestionView> createState() => _AddSuggestionViewState();
}

final TextEditingController _controllerMessage = TextEditingController();
final String uid = FirebaseAuth.instance.currentUser!.uid ?? '';


class _AddSuggestionViewState extends State<AddSuggestionView> {

  @override
  void dispose() {
    // Controller'ları temizle
    _controllerMessage.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
      title: const Text('Yeni Öneri Oluştur'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(
              controller: _controllerMessage,
              maxLines: 5,
              minLines: 2,
              maxLength: 600,
              decoration: const InputDecoration(hintText: 'Soru/Görüş/Önerinizi yazın'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialog kapatılır
          },
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestoreController.firestoreAddSuggestion(context, uid, _controllerMessage.text);
            _controllerMessage.clear();
            Navigator.of(context).pop(); // Dialog kapatılır
          },
          child: const Text('Gönder'),
        ),
      ],
    );
  }
}
