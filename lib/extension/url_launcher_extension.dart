import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'flushbar_extension.dart';

class UrlLauncherExtension {

  static Future<void> launchSocialMedia(BuildContext context, String socialMediaUrl) async {
    Uri url = Uri.parse(socialMediaUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      FlushbarExtension.oneMessageFlushbar(context, "İstenilen sosyal medya uygulamasına bağlanılamıyor.");
    }

  }

  static Future<void> launchWebView(String url) async {

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

}
