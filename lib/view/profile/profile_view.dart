import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/extension/navigator_extension.dart';
import 'package:aral_mezunlar_mobile/view/add_suggestion/add_suggestion_view.dart';
import 'package:aral_mezunlar_mobile/view/choose_auth/choose_auth_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/firebase_auth_controller.dart';
import '../../controller/firebase_storage_controller.dart';
import '../add_event/add_event_view.dart';
import '../profile_edit/profile_edit_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {

    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
        builder: (context, child){
          return Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

                        if(snapshot.connectionState == ConnectionState.waiting){
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 120.h,
                              child: const Text("abcc"),
                            ),
                          );                        }
                        else if(snapshot.hasError){

                        }

                        String uid = FirebaseAuth.instance.currentUser!.uid;

                        String userName = snapshot.data?['name'] ?? '';

                        String userSurname = snapshot.data?['surname'] ?? '';

                        String userAbout = snapshot.data?['about'] ?? '';

                        String userRole = snapshot.data?['role'] ?? '';

                        String userProfileUrl = snapshot.data?['imageurl'] ?? '';

                        String userBannerUrl = snapshot.data?['bannerurl'] ?? '';

                        String profilePhotoUrl = "";

                        String profileBannerUrl = "";

                        return Column(
                          children: [
                            //BANNER WIDGET
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FutureBuilder<String>(
                                    future: FirebaseStorageController.downloadUserBannerImage(userBannerUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        profileBannerUrl = snapshot.data!;
                                        return CachedNetworkImage(
                                          imageUrl: snapshot.data ?? '',
                                          placeholder: (context, url) => Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: SizedBox(
                                              height: 120.h,
                                              child: const Text("abcc"),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Image.network(
                                            "https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png",
                                            height: 120.h,
                                            fit: BoxFit.cover,
                                          ),
                                          imageBuilder: (context, imageProvider) => Image(
                                            height: 120.h,
                                            width: ScreenUtil.defaultSize.width,
                                            image: imageProvider,
                                            fit: BoxFit.cover, // Tam ekranı kaplamak için
                                          ),
                                        );
                                      } else {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: SizedBox(
                                            height: 120.h,
                                            child: const Text("abcc"),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            //PROFILE PHOTO WIDGET
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Container(
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
                                    child: FutureBuilder<String>(
                                      future: FirebaseStorageController.downloadUserProfileImage(userProfileUrl),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          profilePhotoUrl = snapshot.data!;
                                          return InkWell(
                                            onTap: () {
                                            },
                                            splashColor: Colors.blue,
                                            hoverColor: Colors.purpleAccent,
                                            borderRadius: BorderRadius.circular(32.sp),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data ?? '',
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: GFAvatar(
                                                  size: 66.sp,
                                                  shape: GFAvatarShape.standard,
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => GFAvatar(
                                                backgroundImage: const NetworkImage("https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png"),
                                                size: 66.sp,
                                                shape: GFAvatarShape.standard,
                                              ),
                                              imageBuilder: (context, imageProvider) => GFAvatar(
                                                backgroundImage: imageProvider,
                                                size: 66.sp,
                                                shape: GFAvatarShape.standard,
                                              ),
                                            ),
                                          );
                                        }
                                        else if (snapshot.connectionState == ConnectionState.waiting){
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: GFAvatar(
                                              size: 66.sp,
                                              shape: GFAvatarShape.standard,
                                            ),
                                          );
                                        }
                                        else {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: GFAvatar(
                                              size: 66.sp,
                                              shape: GFAvatarShape.standard,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            //NAME AND EDIT WIDGET
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: Text("$userName $userSurname", style: Theme.of(context).textTheme.displayLarge,),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: GFIconButton(onPressed: (){
                                      Navigator.push(context, NavigatorExtension.bottomToTopAnimation(ProfileEditView(uid: uid, name: userName, surname: userSurname, about: userAbout, profilePhotoUrl: profilePhotoUrl, imageUrl: userProfileUrl, profileBannerUrl: profileBannerUrl, bannerUrl: userBannerUrl,)));
                                      },
                                        type: GFButtonType.outline2x, color: ColorConstants.primaryButtonColor, tooltip: "Profili Düzenle", icon: const Icon(Icons.edit), iconSize: 16.sp),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            //ABOUT WIDGET
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: const Text("Hakkımda"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                            colors: [
                                              CupertinoColors.systemGrey5,
                                              CupertinoColors.systemGrey6,
                                            ]
                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                                      child: Text(userAbout),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            //ADMIN PANEL WIDGET
                            Visibility(
                              visible: userRole == "Yönetim",
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    borderRadius: BorderRadius.circular(6.sp),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: CupertinoColors.systemGrey3,
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0.1,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AddEventView();
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.event, color: ColorConstants.primaryButtonColorAlternative,),
                                            SizedBox(width: 8.w,),
                                            const Text("Etkinlik Oluştur", style: TextStyle(color: ColorConstants.primaryButtonColorAlternative)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //SETTINGS WIDGET
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(6.sp),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: CupertinoColors.systemGrey3,
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                      spreadRadius: 0.1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.nights_stay_outlined, color: ColorConstants.primaryButtonColorAlternative),
                                          SizedBox(width: 8.w,),
                                          const Text("Uygulama Teması (Yakında)", style: TextStyle(color: ColorConstants.primaryButtonColorAlternative),),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AddSuggestionView();
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.help_outline_outlined, color: ColorConstants.primaryButtonColorAlternative,),
                                          SizedBox(width: 8.w,),
                                          const Text("Bize Ulaşın", style: TextStyle(color: ColorConstants.primaryButtonColorAlternative)),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        FirebaseAuthController.signOut();
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.logout, color: ColorConstants.primaryButtonColorAlternative,),
                                          SizedBox(width: 8.w,),
                                          const Text("Çıkış Yap", style: TextStyle(color: ColorConstants.primaryButtonColorAlternative),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
          );
        }
    );
  }
}
