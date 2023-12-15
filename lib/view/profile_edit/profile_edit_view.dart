import 'dart:io';
import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../extension/flushbar_extension.dart';

class ProfileEditView extends StatefulWidget {
  final String uid;
  final String name;
  final String surname;
  final String about;
  String profilePhotoUrl;
  String imageUrl;
  String profileBannerUrl;
  String bannerUrl;
  ProfileEditView({Key? key, required this.uid, required this.name, required this.surname, required this.about, required this.profilePhotoUrl, required this.imageUrl, required this.profileBannerUrl, required this.bannerUrl}) : super(key: key);

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();


  @override
  void initState() {
    nameController.text = widget.name;
    surnameController.text = widget.surname;
    aboutController.text = widget.about;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final picker = ImagePicker();


  Future<void> _uploadImageToFirebase() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxHeight: 600, maxWidth: 600);
    final DateTime now = DateTime.now();
    final String date = now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString();

    if (pickedFile == null) {
      return;
    }

    File imageFile = File(pickedFile.path);
    String imageName = '${widget.uid + date}.jpg';

    if (widget.imageUrl != null && widget.imageUrl != " ") {
      Reference oldImageReference = FirebaseStorage.instance.ref().child("profiles").child(widget.imageUrl);
      await oldImageReference.delete();
    }

    Reference storageReference = FirebaseStorage.instance.ref().child("profiles").child(imageName);
    UploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      String fileURL = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'imageurl': imageName,
      });

      setState(() {
        widget.profilePhotoUrl = fileURL;
        widget.imageUrl = imageName;
      });
    });
  }

  Future<void> _uploadBannerToFirebase() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxHeight: 400, maxWidth: 900);
    final DateTime now = DateTime.now();
    final String date = now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString();

    if (pickedFile == null) {
      return;
    }

    File imageFile = File(pickedFile.path);
    String imageName = '${widget.uid + date}.jpg';

    if (widget.bannerUrl != null && widget.bannerUrl.isNotEmpty) {
      Reference oldImageReference = FirebaseStorage.instance.ref().child("profilebanners").child(widget.bannerUrl);
      await oldImageReference.delete();
    }

    Reference storageReference = FirebaseStorage.instance.ref().child("profilebanners").child(imageName);
    UploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      String fileURL = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'bannerurl': imageName,
      });

      setState(() {
        widget.profileBannerUrl = fileURL;
        widget.bannerUrl = imageName;
      });
    });
  }




  @override
  Widget build(BuildContext context) {


    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CachedNetworkImage(
                                imageUrl: widget.profileBannerUrl,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 120.h,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.network(
                                  "https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png",
                                  fit: BoxFit.cover,
                                ),
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: (){ _uploadBannerToFirebase(); },
                                  icon: const Icon(Icons.edit),
                                  iconSize: 16.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.profilePhotoUrl,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: GFAvatar(
                                size: 66.sp,
                                shape: GFAvatarShape.standard,
                              ),
                            ),
                            errorWidget: (context, url, error) => GFAvatar(
                              size: 66.w,
                              shape: GFAvatarShape.standard,
                            ),
                            imageBuilder: (context, imageProvider) => GFAvatar(
                              backgroundImage: imageProvider,
                              size: 66.w,
                              shape: GFAvatarShape.standard,
                            ),
                          ),
                          Positioned(
                            right: 2.w,
                            bottom: 2.h,
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: (){ _uploadImageToFirebase(); },
                                icon: const Icon(Icons.edit),
                                iconSize: 16.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Ad",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TextField(
                    controller: surnameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Soyad",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TextField(
                    controller: aboutController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: "Hakkımda",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 10.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GFButton(
                    size: 48.sp,
                    shape: GFButtonShape.standard,
                    color: ColorConstants.primaryButtonColor,
                    onPressed: () {
                      FirebaseFirestoreController.firestoreProfileSaveChanges(widget.uid, nameController.text, surnameController.text, aboutController.text);
                      Navigator.pop(context);
                      FlushbarExtension.oneMessageFlushbar(context, "Değişiklikleriniz kaydedildi!");
                    },
                    child: const Text("Kaydet"),
                  ),
                ),
                SizedBox(height: 10.h,)
              ],
            ),
          ),
        );
      },
    );
  }
}