import 'dart:async';
import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_auth_controller.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:aral_mezunlar_mobile/extension/navigator_extension.dart';
import 'package:aral_mezunlar_mobile/extension/popup_extension.dart';
import 'package:aral_mezunlar_mobile/view/post_detail/post_detail_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../controller/firebase_storage_controller.dart';
import '../inspect_profile/inspect_profile_view.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({Key? key}) : super(key: key);

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  late StreamController<QuerySnapshot> _postStreamController;
  late Stream<QuerySnapshot> _postStream;

  @override
  void initState() {
    super.initState();

    _postStreamController = StreamController<QuerySnapshot>();
    _postStream = _postStreamController.stream;

    FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots().listen((event) {
      _postStreamController.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    String? uid = FirebaseAuthController.getCurrentUser();
    final TextEditingController _controllerPost = TextEditingController();
    final FocusNode _focusNodePost = FocusNode();


    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child){
          return SafeArea(
            child: Scaffold(
              body: GestureDetector(
              onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          TextField(
                            maxLines: 6,
                            minLines: 5,
                            focusNode: _focusNodePost,
                            controller: _controllerPost,
                            maxLength: 180,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(fontSize: 12.sp),
                              hintText: "Nasıl gidiyor?",
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: GFButton(onPressed: (){ FirebaseFirestoreController.firestoreAddPost(uid!, context, _controllerPost.text); _controllerPost.clear(); _focusNodePost.unfocus(); }, shape: GFButtonShape.standard, color: ColorConstants.primaryButtonColor, child: const Text("Paylaş"),),
                            ),
                          ),
                        ],
                      ),

                      StreamBuilder<QuerySnapshot>(
                      stream: _postStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: RefreshProgressIndicator());
                        } else if (asyncSnapshot.hasError) {
                          return Text('Hata: ${asyncSnapshot.error}');
                        } else {
                          List<QueryDocumentSnapshot> documents = asyncSnapshot.data?.docs ?? [];

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              QueryDocumentSnapshot document = documents[index];
                              Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;

                              String postUid = document.id;
                              String post = data['post'] ?? '';
                              String uid = data['uid'] ?? '';
                              Timestamp? postTimeStamp = data['timestamp'];
                              List<dynamic> likesList = data['likes'] ?? [];
                              int likeCount = likesList.length;

                              String timeAgo = '';
                              if (postTimeStamp != null) {
                                DateTime postDate = DateTime.fromMillisecondsSinceEpoch(postTimeStamp.seconds * 1000);
                                Duration timePassedFromShare = DateTime.now().difference(postDate);
                                if (timePassedFromShare.inMinutes < 60) {
                                  timeAgo = '${timePassedFromShare.inMinutes} dk';
                                } else if (timePassedFromShare.inHours < 24) {
                                  timeAgo = '${timePassedFromShare.inHours} sa';
                                } else if (timePassedFromShare.inDays < 3) {
                                  timeAgo = '${timePassedFromShare.inDays} gn';
                                } else {
                                  DateTime paylasimTamTarih = postTimeStamp.toDate();
                                  timeAgo = DateFormat('dd.MM.yyyy').format(paylasimTamTarih);
                                }
                              } else {
                                timeAgo= '';
                              }

                              return StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                  String userProfileUrl = userSnapshot.data != null ? userSnapshot.data!['imageurl'] ?? '' : '';
                                  String userProfileName = userSnapshot.data != null ? userSnapshot.data!['name'] ?? '' : '';
                                  String userProfileSurname = userSnapshot.data != null ? userSnapshot.data!['surname'] ?? '' : '';
                                  String userProfileAbout = userSnapshot.data != null ? userSnapshot.data!['about'] ?? '' : '';
                                  String userProfileBannerUrl = userSnapshot.data != null ? userSnapshot.data!['bannerurl'] ?? '' : '';
                                  String profilePhotoUrl = "";
                                  return InkWell(
                                    onLongPress: (){
                                      if(FirebaseAuth.instance.currentUser!.uid == uid){
                                        PopUpExtension.showPostDeleteConfirmationDialog(context, postUid);
                                      }
                                    },
                                    onTap: (){
                                      Navigator.push(context, NavigatorExtension.sizeShrinkAnimation(PostDetailView(postUid: postUid, userProfileName: userProfileName, userProfileSurname: userProfileSurname, post: post, timeAgo: timeAgo, likeList: likesList, userProfilePhoto: profilePhotoUrl,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 22.0),
                                                  child: FutureBuilder<String>(
                                                    future: FirebaseStorageController.downloadUserProfileImage(userProfileUrl),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.done) {
                                                        profilePhotoUrl = snapshot.data!;
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              NavigatorExtension.bottomToTopAnimation(InspectProfileView(name: userProfileName, surname: userProfileSurname, about: userProfileAbout, profilePhotoUrl: profilePhotoUrl, profileBannerUrl: userProfileBannerUrl))
                                                            );
                                                          },
                                                          splashColor: Colors.blue,
                                                          hoverColor: Colors.purpleAccent,
                                                          borderRadius: BorderRadius.circular(32.sp),
                                                          child: CachedNetworkImage(
                                                            imageUrl: snapshot.data ?? '',
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
                                                              backgroundImage: NetworkImage(snapshot.data ?? "https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png"),
                                                            ),
                                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                                              radius: 24,
                                                              backgroundColor: Colors.transparent,
                                                              backgroundImage: NetworkImage(snapshot.data ?? "https://upload.wikimedia.org/wikipedia/en/d/db/Daryl_Dixon_Norman_Reedus.png"),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Shimmer.fromColors(
                                                          baseColor: Colors.grey[300]!,
                                                          highlightColor: Colors.grey[100]!,
                                                          child: const CircleAvatar(
                                                            radius: 24,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 15.h),
                                                  child: Row(
                                                    children: [
                                                      Text("$userProfileName $userProfileSurname", style: Theme.of(context).textTheme.titleSmall),
                                                      const Text(" · "),
                                                      Text(timeAgo, style: Theme.of(context).textTheme.headlineSmall),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(flex: 2, child: Visibility(visible: false, child: Text(""),)),
                                              Expanded(flex: 9, child: Text(post)),
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
                                                          await FirebaseFirestoreController.addLikeToUser(FirebaseAuth.instance.currentUser!.uid, postUid);
                                                        },
                                                        icon: Icon(
                                                          likes.contains(postUid) ? Icons.favorite : Icons.favorite_border,
                                                          color: likes.contains(postUid) ? Colors.red : CupertinoColors.systemGrey4,
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
                                          Padding(
                                            padding: EdgeInsets.only(top: 5.h,),
                                            child: const Divider(height: 2, color: CupertinoColors.systemGrey6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                      const SizedBox(height: 15,)
                    ],
                  ),
                ),
              ),
              ),
          );
        }
    );
  }
}