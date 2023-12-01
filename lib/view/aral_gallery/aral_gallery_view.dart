import 'package:aral_mezunlar_mobile/controller/firebase_storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AralGalleryView extends StatefulWidget {
  @override
  _AralGalleryViewState createState() => _AralGalleryViewState();
}

class _AralGalleryViewState extends State<AralGalleryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<String>>(
        stream: FirebaseStorageController.getAllDownloadUrls("aralgaleri").asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            List<String>? downloadUrls = snapshot.data;

            return (downloadUrls != null && downloadUrls.isNotEmpty)
                ? ListView.builder(
              itemCount: downloadUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w, top: 5.h), // Öğeler arasındaki boşlukları ayarlayabilirsiniz
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        downloadUrls[index],
                        fit: BoxFit.cover,
                        height: 150.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text('Gösterilecek dosya yok.');
          }
        },
      ),
    );
  }
}
