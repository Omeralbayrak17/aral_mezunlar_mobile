import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddImageGalleryView extends StatefulWidget {
  const AddImageGalleryView({super.key});

  @override
  State<AddImageGalleryView> createState() => _AddImageGalleryViewState();
}

final TextEditingController _controllerTitle = TextEditingController();

class _AddImageGalleryViewState extends State<AddImageGalleryView> {
  final picker = ImagePicker();
  String galleryImageUrl = "";
  XFile? pickedFile;

  Future<void> _pickImage() async {
    pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 900,
    );

    if (pickedFile != null) {
      setState(() {
        galleryImageUrl = pickedFile!.path;
      });
    }
  }

  Future<void> _addImageToFirestore(String title) async {
    try {
      if (pickedFile == null) {
        return;
      }

      File imageFile = File(pickedFile!.path);

      DocumentReference documentReference = await FirebaseFirestore.instance.collection('aralgaleri').add({
        'description': title,
        'timestamp': Timestamp.now(),
      });

      String documentName = documentReference.id;
      String imageName = "$documentName.jpg";

      Reference storageReference = FirebaseStorage.instance.ref().child("aralgaleri").child(imageName);
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        String fileURL = await storageReference.getDownloadURL();
        setState(() {
          galleryImageUrl = fileURL;
        });
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Fotoğraf Oluştur'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 160.h,
              child: pickedFile != null
                  ? Image.file(
                File(pickedFile!.path),
                fit: BoxFit.cover,
              )
                  : Placeholder(
                fallbackHeight: 160.h,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5.h,),
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
              },
              child: const Text('Fotoğraf Seç'),
            ),
            SizedBox(height: 5.h,),
            TextField(
              controller: _controllerTitle,
              decoration: const InputDecoration(hintText: 'Fotoğraf Başlığı'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            _addImageToFirestore(_controllerTitle.text);
            _controllerTitle.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Gönder'),
        ),
      ],
    );
  }
}
