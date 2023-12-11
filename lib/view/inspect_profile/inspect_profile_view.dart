import 'package:aral_mezunlar_mobile/controller/firebase_storage_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shimmer/shimmer.dart';


class InspectProfileView extends StatefulWidget {
  final String name;
  final String surname;
  final String about;
  final String profilePhotoUrl;
  final String profileBannerUrl;
  const InspectProfileView({super.key, required this.name, required this.surname, required this.about, required this.profilePhotoUrl, required this.profileBannerUrl});

  @override
  State<InspectProfileView> createState() => _InspectProfileViewState();
}

class _InspectProfileViewState extends State<InspectProfileView> {

  String bannerUrl = "";

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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<String>(
                          future: FirebaseStorageController.downloadUserBannerImage(widget.profileBannerUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              bannerUrl = snapshot.data!;
                              return CachedNetworkImage(
                                imageUrl: snapshot.data ?? '',
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: SizedBox(
                                    height: 120.h,
                                    width: ScreenUtil.defaultSize.width,
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
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else if(snapshot.connectionState == ConnectionState.waiting){
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 120.h,
                                  width: ScreenUtil.defaultSize.width,
                                ),
                              );
                            }
                            else {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SizedBox(
                                  height: 120.h,
                                  width: ScreenUtil.defaultSize.width,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
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
                          child: CachedNetworkImage(
                            imageUrl: widget.profilePhotoUrl,
                            placeholder: (context, url) => const CircularProgressIndicator(),
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text("${widget.name} ${widget.surname}", style: Theme.of(context).textTheme.displayLarge),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.w,),
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
                            child: Text(widget.about),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
