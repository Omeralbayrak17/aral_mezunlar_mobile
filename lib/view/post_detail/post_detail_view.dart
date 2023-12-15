import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/firebase_firestore_controller.dart';


class PostDetailView extends StatefulWidget {
  final String postUid;
  final String userProfileName;
  final String userProfileSurname;
  final String timeAgo;
  final String post;
  final List likeList;
  final String userProfilePhoto;
  const PostDetailView({required this.postUid, required this.userProfileName, required this.userProfileSurname, required this.timeAgo, required this.post, required this.likeList, required this.userProfilePhoto, super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {

  int likeCount = 0;

  @override
  void initState(){
    setState(() {
      likeCount=widget.likeList.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //    context,
                              //    NavigatorExtension.bottomToTopAnimation(InspectProfileView(name: userProfileName, surname: userProfileSurname, about: userProfileAbout, profilePhotoUrl: profilePhotoUrl, profileBannerUrl: userProfileBannerUrl))
                              // );
                            },
                            splashColor: Colors.blue,
                            hoverColor: Colors.purpleAccent,
                            borderRadius: BorderRadius.circular(32.sp),
                            child: CachedNetworkImage(
                              imageUrl: widget.userProfilePhoto,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: const CircleAvatar(
                                  radius: 24,
                                ),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(widget.userProfilePhoto),
                              ),
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(widget.userProfilePhoto),
                              ),
                            ),
                          )
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Row(
                            children: [
                              Text("${widget.userProfileName} ${widget.userProfileSurname}", style: Theme.of(context).textTheme.titleSmall),
                              const Text(" · "),
                              Text(widget.timeAgo, style: Theme.of(context).textTheme.headlineSmall),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 2, child: Visibility(visible: false, child: Text(""),)),
                      Expanded(flex: 9, child: Text(widget.post)),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.comment, color: CupertinoColors.systemGrey4, size: 18.sp,)),
                      const Spacer(),
                      IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.retweet, color: CupertinoColors.systemGrey4, size: 18.sp,)),
                      const Spacer(),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          List likes = userSnapshot.data?['likes'] ?? [];
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await FirebaseFirestoreController.addLikeToUser(FirebaseAuth.instance.currentUser!.uid, widget.postUid);
                                  int newLikeCount = await FirebaseFirestoreController.getLikeCount(widget.postUid);
                                  setState(() {
                                    likeCount = newLikeCount;
                                  });
                                  },
                                icon: Icon(
                                  likes.contains(widget.postUid) ? Icons.favorite : Icons.favorite_border,
                                  color: likes.contains(widget.postUid) ? Colors.red : CupertinoColors.systemGrey4,
                                  size: 18.sp,
                                ),
                              ),
                              Text(likeCount.toString(), style: Theme.of(context).textTheme.headlineSmall,)
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.bookmark, color: CupertinoColors.systemGrey4, size: 18.sp,)),
                      const Spacer(),
                    ],
                  ),
                  Divider(height: 1.h, color: CupertinoColors.systemGrey5),
                ],
              ),
              ),
            );
        });
  }
}