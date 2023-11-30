import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:aral_mezunlar_mobile/controller/firebase_storage_controller.dart';
import 'package:aral_mezunlar_mobile/extension/popup_extension.dart';
import 'package:aral_mezunlar_mobile/view/calendar_details/calendar_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Text("Yaklaşan Etkinlikler", style: Theme.of(context).textTheme.displayLarge,),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('events').orderBy('timestamp', descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> eventSnapshot) {
                      if (eventSnapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      } else if (eventSnapshot.hasError) {
                        return Text('Hata: ${eventSnapshot.error}');
                      } else {
                        List<QueryDocumentSnapshot> documents = eventSnapshot.data?.docs ?? [];

                        // Geçmiş ve gelecek etkinlikleri ayırmak için iki ayrı liste oluştur
                        List<QueryDocumentSnapshot> pastEvents = [];
                        List<QueryDocumentSnapshot> upcomingEvents = [];

                        DateTime now = DateTime.now();

                        // Tarihe göre etkinlikleri ayır
                        for (QueryDocumentSnapshot document in documents) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          Timestamp eventStamp = data['timestamp'];
                          DateTime eventDateStamp = eventStamp.toDate();

                          // Etkinlik tarihi geçmişse pastEvents listesine ekle, değilse upcomingEvents listesine ekle
                          if (eventDateStamp.isBefore(now)) {
                            pastEvents.add(document);
                          } else {
                            upcomingEvents.add(document);
                          }
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: upcomingEvents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> data = upcomingEvents[index].data() as Map<String, dynamic>;

                                  String title = data['title'] ?? '';
                                  String message = data['message'] ?? '';
                                  String locationUrl = data['locationurl'] ?? '';
                                  String shareMessage = data['sharemessage'] ?? '';
                                  String eventImage = data['eventimageurl'] ?? '';
                                  Timestamp eventStamp = data['timestamp'];
                                  DateTime eventDateStamp = eventStamp.toDate();
                                  String formattedHour = eventDateStamp.hour.toString();
                                  String formattedMinute = eventDateStamp.minute.toString().padLeft(2, '0');
                                  String eventDate = "${eventDateStamp.day}.${eventDateStamp.month}.${eventDateStamp.year} $formattedHour:$formattedMinute";

                                  return FutureBuilder(
                                    future: FirebaseStorageController.downloadEventImage(eventImage),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const LinearProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Hata: ${snapshot.error}');
                                      } else if (!snapshot.hasData || snapshot.data == null) {
                                        // Veri yoksa veya null ise bir hata mesajı veya yerine geçecek bir widget gösterilebilir.
                                        return const Text('Veri bulunamadı');
                                      } else {
                                        return InkWell(
                                          splashColor: Colors.white,
                                          highlightColor: Colors.white,
                                          onLongPress: () async {
                                            String userRole = await FirebaseFirestoreController.getUserRole(FirebaseAuth.instance.currentUser!.uid);
                                            if(userRole == "Yönetim"){
                                              if(context.mounted) PopUpExtension.showEventDeleteConfirmationDialog(context, upcomingEvents[index].id);
                                            }
                                          },
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CalendarDetailsView(title: title, message: message, imageUrl: snapshot.data, googleMapsUrl: locationUrl, whatsappShareMessage: shareMessage,)),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                              Container(
                                                height: 120.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black, width: 1),
                                                  color: CupertinoColors.systemGrey5,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(snapshot.data),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.h,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Text(
                                                      title,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(flex: 3, child: Text(eventDate, textAlign: TextAlign.right,))
                                                ],
                                              ),
                                              const Padding(padding: EdgeInsets.only(bottom: 15)),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            if (pastEvents.isNotEmpty)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                  child: Text("Geçmiş Etkinlikler",
                                    style: Theme.of(context).textTheme.displayLarge,),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: pastEvents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> data = pastEvents[index].data() as Map<String, dynamic>;
                                  String title = data['title'] ?? '';
                                  String message = data['message'] ?? '';
                                  String locationUrl = data['locationurl'] ?? '';
                                  String shareMessage = data['sharemessage'] ?? '';
                                  String eventImage = data['eventimageurl'] ?? '';
                                  Timestamp eventStamp = data['timestamp'];
                                  DateTime eventDateStamp = eventStamp.toDate();
                                  String formattedHour = eventDateStamp.hour.toString();
                                  String formattedMinute = eventDateStamp.minute.toString().padLeft(2, '0');
                                  String eventDate = "${eventDateStamp.day}.${eventDateStamp.month}.${eventDateStamp.year} $formattedHour:$formattedMinute";

                                  return FutureBuilder(
                                    future: FirebaseStorageController.downloadEventImage(eventImage),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const LinearProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Hata: ${snapshot.error}');
                                      } else if (!snapshot.hasData || snapshot.data == null) {
                                        // Veri yoksa veya null ise bir hata mesajı veya yerine geçecek bir widget gösterilebilir.
                                        return const Text('Veri bulunamadı');
                                      } else {
                                        return InkWell(
                                          splashColor: Colors.white,
                                          highlightColor: Colors.white,
                                          onLongPress: () async {
                                            String userRole = await FirebaseFirestoreController.getUserRole(FirebaseAuth.instance.currentUser!.uid);
                                            if(userRole == "Yönetim"){
                                              if(context.mounted) PopUpExtension.showEventDeleteConfirmationDialog(context, pastEvents[index].id);
                                            }
                                          },
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CalendarDetailsView(title: title, message: message, imageUrl: snapshot.data, googleMapsUrl: locationUrl, whatsappShareMessage: shareMessage,)),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                              Container(
                                                height: 120.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black, width: 1),
                                                  color: CupertinoColors.systemGrey5,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(snapshot.data),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.h,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Text(
                                                      title,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(flex: 3, child: Text(eventDate, textAlign: TextAlign.right,))
                                                ],
                                              ),
                                              const Padding(padding: EdgeInsets.only(bottom: 15)),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}