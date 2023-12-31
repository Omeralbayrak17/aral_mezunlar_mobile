import 'package:aral_mezunlar_mobile/controller/firebase_storage_controller.dart';
import 'package:aral_mezunlar_mobile/extension/popup_extension.dart';
import 'package:aral_mezunlar_mobile/view/add_image_gallery/add_image_gallery_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AralGalleryView extends StatefulWidget {
  const AralGalleryView({super.key});

  @override
  _AralGalleryViewState createState() => _AralGalleryViewState();
}

class _AralGalleryViewState extends State<AralGalleryView> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('aralgaleri').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                documents.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    String description = documents[index]['description'];
                    String documentId = documents[index].id;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w, top: 5.h),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                              child: FutureBuilder<String>(
                                future: FirebaseStorageController.downloadImageFromStorage("aralgaleri", documentId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    String aralGalleryImage = snapshot.data ?? '';
                                    return InkWell(
                                      onTap: () async {
                                        String userRole = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc) {
                                          return doc['role'] as String;
                                        });
                                        if(userRole == "Yönetim"){
                                          if(mounted) PopUpExtension.showGalleryImageDeleteConfirmationDialog(context, documentId);
                                        }
                                      },
                                      onLongPress: () async {
                                        PopUpExtension.showImageSaveConfirmationDialog(context, aralGalleryImage);
                                      },
                                      splashColor: Colors.blue,
                                      hoverColor: Colors.purpleAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: aralGalleryImage,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: SizedBox(
                                            height: 180.h,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: SizedBox(
                                            height: 180.h,
                                          ),
                                        ),
                                        imageBuilder: (context, imageProvider) => Image(
                                          height: 180.h,
                                          width: double.infinity,
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: SizedBox(
                                        height: 180.h,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                description,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
            floatingActionButton: FloatingActionButton(
            onPressed: (){
              showDialog(context: context, builder: (context) => const AddImageGalleryView(),);
            },
            child: const Icon(Icons.add_a_photo),
          ),
        );
      },
    );
  }
}
