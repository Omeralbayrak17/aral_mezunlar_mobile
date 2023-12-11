import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CalendarDetailsView extends StatefulWidget {

  String title;
  String message;
  String googleMapsUrl;
  String whatsappShareMessage;
  String imageUrl;

  CalendarDetailsView({Key? key, required this.title, required this.message, required this.googleMapsUrl, required this.whatsappShareMessage, required this.imageUrl}) : super(key: key);


  @override
  State<CalendarDetailsView> createState() => _CalendarDetailsViewState();
}

class _CalendarDetailsViewState extends State<CalendarDetailsView> {


  @override
  Widget build(BuildContext context) {


    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {

          return Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 120.h,
                    decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              widget.imageUrl
                            )
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(flex: 10, child: Text(widget.title, style: Theme.of(context).textTheme.displayMedium,)),
                        Expanded(flex: 2,child: IconButton(icon: const Icon(Icons.share), onPressed: (){
                          launchWhatsAppUri() async {
                            WhatsAppUnilink link = WhatsAppUnilink(
                              phoneNumber: '+90-(507)8998837',
                              text: widget.whatsappShareMessage,
                            );
                            await launchUrl(link.asUri());
                          }
                          launchWhatsAppUri();
                        }, color: CupertinoColors.systemGrey6, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(CupertinoColors.activeGreen)),)),
                        SizedBox(width: 5.w,),
                        Expanded(flex: 2,child: IconButton(icon: const Icon(Icons.alt_route_sharp), onPressed: (){ launchUrl(Uri.parse(widget.googleMapsUrl)); }, color: CupertinoColors.systemGrey6, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(CupertinoColors.link)),))
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(widget.message),
                  ),
                  SizedBox(height: 15.h,),
                ],
              ),
            ),
          );
        });
  }
}
