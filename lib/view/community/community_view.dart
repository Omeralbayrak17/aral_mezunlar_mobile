import 'package:aral_mezunlar_mobile/extension/navigator_extension.dart';
import 'package:aral_mezunlar_mobile/extension/url_launcher_extension.dart';
import 'package:aral_mezunlar_mobile/view/aral_gallery/aral_gallery_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/firebase_storage_controller.dart';
import '../inspect_profile/inspect_profile_view.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child){
          return Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  else if(snapshot.hasError){

                  }

                  List<QueryDocumentSnapshot> yonetimFilteredDocuments = [];

                  if (snapshot.data != null) {
                    for (QueryDocumentSnapshot document in snapshot.data!.docs) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      if (data['role'] == 'Yönetim') {
                        yonetimFilteredDocuments.add(document);
                      }
                    }
                  }

                  List<QueryDocumentSnapshot> uyeFilteredDocuments = [];

                  if (snapshot.data != null) {
                    for (QueryDocumentSnapshot document in snapshot.data!.docs) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      if (data['role'] == 'Uye') {
                        uyeFilteredDocuments.add(document);
                      }
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                        child: Text("Aral Mezunlar Derneği Üyelerimiz", style: Theme.of(context).textTheme.displayMedium,),
                      )),
                      SizedBox(height: 5.h,),
                      Divider(height: 1.h,),
                      SizedBox(height: 5.h,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Text("Yönetim Kurulu"),
                      ),
                      SizedBox(height: 5.h,),
                      SizedBox(
                        height: 125.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: yonetimFilteredDocuments.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data = yonetimFilteredDocuments[index].data() as Map<String, dynamic>;
                            String userName = data['name'] ?? '';
                            String userSurname = data['surname'];
                            String userAbout = data['about'] ?? '';
                            String userImageUrl = data['imageurl'] ?? '';
                            String userBannerUrl = data['bannerurl'] ?? '';
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Column(
                                children: [
                                  FutureBuilder<String>(
                                    future: FirebaseStorageController.downloadUserProfileImage(userImageUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        String userProfilePhotoUrl = snapshot.data ?? '';
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context, NavigatorExtension.bottomToTopAnimation(InspectProfileView(name: userName, surname: userSurname, about: userAbout, profilePhotoUrl: userProfilePhotoUrl, profileBannerUrl: userBannerUrl,)));                                      },
                                          splashColor: Colors.blue,
                                          hoverColor: Colors.purpleAccent,
                                          borderRadius: BorderRadius.circular(32.sp),
                                          child: CachedNetworkImage(
                                            imageUrl: userProfilePhotoUrl,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => GFAvatar(
                                              backgroundImage: const NetworkImage("https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png"),
                                              size: 52.sp,
                                            ),
                                            imageBuilder: (context, imageProvider) => GFAvatar(
                                              backgroundImage: imageProvider,
                                              size: 52.sp,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: GFAvatar(
                                            size: 52.sp,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(userName),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5.h,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Text("Üyeler"),
                      ),
                      SizedBox(height: 5.h,),
                      SizedBox(
                        height: 125.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: uyeFilteredDocuments.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data = uyeFilteredDocuments[index].data() as Map<String, dynamic>;
                            String userName = data['name'] ?? '';
                            String userSurname = data['surname'];
                            String userAbout = data['about'] ?? '';
                            String userImageUrl = data['imageurl'] ?? '';
                            String userBannerUrl = data['bannerurl'] ?? '';
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Column(
                                children: [
                                  FutureBuilder<String>(
                                    future: FirebaseStorageController.downloadUserProfileImage(userImageUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        String userProfilePhotoUrl = snapshot.data ?? '';
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context, NavigatorExtension.bottomToTopAnimation(InspectProfileView(name: userName, surname: userSurname, about: userAbout, profilePhotoUrl: userProfilePhotoUrl, profileBannerUrl: userBannerUrl,)));
                                          },
                                          splashColor: Colors.blue,
                                          hoverColor: Colors.purpleAccent,
                                          borderRadius: BorderRadius.circular(32.sp),
                                          child: CachedNetworkImage(
                                            imageUrl: userProfilePhotoUrl,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => GFAvatar(
                                              backgroundImage: const NetworkImage("https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png"),
                                              size: 52.sp,
                                            ),
                                            imageBuilder: (context, imageProvider) => GFAvatar(
                                              backgroundImage: imageProvider,
                                              size: 52.sp,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: GFAvatar(
                                            size: 52.sp,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                  ,
                                  SizedBox(height: 5.h),
                                  Text(userName),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
            },
          ),
                  Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          "Aral Galeri",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 120.h,
                          child: FutureBuilder<String>(
                            future: FirebaseStorageController.downloadImageFromStorage("admin", "aralgaleri"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                String userProfilePhotoUrl = snapshot.data ?? '';
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, NavigatorExtension.expandFromMiddleAnimation(AralGalleryView()));
                                    },
                                  splashColor: Colors.blue,
                                  hoverColor: Colors.purpleAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: userProfilePhotoUrl,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: SizedBox(
                                        height: 120.h,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: SizedBox(
                                        height: 120.h,
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) => Image(
                                      height: 120.h,
                                      width: ScreenUtil.defaultSize.width,
                                      image: imageProvider,
                                      fit: BoxFit.cover, // Tam ekranı kaplamak için
                                    ),
                                  ),
                                );
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: SizedBox(
                                    height: 120.h,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                      "Aral Sosyal Medya",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                        child: GFIconButton(
                          icon: const Icon(Icons.facebook),
                          onPressed: (){},
                          iconSize: 34.sp,
                          shape: GFIconButtonShape.circle,
                          highlightColor: Colors.white.withOpacity(0.4),
                          focusColor: Colors.white.withOpacity(0.4),
                          hoverColor: Colors.white.withOpacity(0.4),
                          splashColor: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(64, 93, 230, 1),
                                Color.fromRGBO(91, 81, 216, 1),
                                Color.fromRGBO(131, 58, 180, 1),
                                Color.fromRGBO(193, 53, 132, 1),
                                Color.fromRGBO(225, 48, 108, 1),
                                Color.fromRGBO(253, 29, 29, 1),
                                Color.fromRGBO(247, 119, 55, 1),
                                Color.fromRGBO(252, 175, 69, 1),
                                Color.fromRGBO(255, 220, 128, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: GFIconButton(
                            icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                            onPressed: () { UrlLauncherExtension.launchSocialMedia(context, "https://www.instagram.com/aralmezunlardernegi"); },
                            iconSize: 34.sp,
                            color: Colors.transparent, // Icon color should be transparent
                            shape: GFIconButtonShape.circle,
                            highlightColor: Colors.white.withOpacity(0.4),
                            focusColor: Colors.white.withOpacity(0.4),
                            hoverColor: Colors.white.withOpacity(0.4),
                            splashColor: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: GFIconButton(
                          icon: const FaIcon(FontAwesomeIcons.xTwitter),
                          onPressed: (){ UrlLauncherExtension.launchSocialMedia(context, "https://twitter.com/armed2001"); },
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          iconSize: 34.sp,
                          shape: GFIconButtonShape.circle,
                          highlightColor: Colors.white.withOpacity(0.4),
                          focusColor: Colors.white.withOpacity(0.4),
                          hoverColor: Colors.white.withOpacity(0.4),
                          splashColor: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: GFIconButton(
                          icon: FaIcon(FontAwesomeIcons.youtube, size: 28.sp,),
                          onPressed: (){},
                          color: Colors.red,
                          iconSize: 32.sp,
                          shape: GFIconButtonShape.circle,
                          highlightColor: Colors.white.withOpacity(0.4),
                          focusColor: Colors.white.withOpacity(0.4),
                          hoverColor: Colors.white.withOpacity(0.4),
                          splashColor: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 120.h,)
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
