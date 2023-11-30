import 'package:aral_mezunlar_mobile/api/firebase_api.dart';
import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/view/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:aral_mezunlar_mobile/view/choose_auth/choose_auth_view.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.primaryButtonColor,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotificationsApi().initNotifications();
  FirebaseNotificationsApi().requestPermissions();
  await FirebaseAppCheck.instance.activate(

    webProvider: ReCaptchaV3Provider('894824180910'),
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Aral Mezunlar Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(primary: ColorConstants.primaryButtonColor, onSecondary: ColorConstants.secondaryButtonColor),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 22
          ),
          displayMedium: TextStyle(
              fontSize: 18
          ),
          displaySmall: TextStyle(
              fontSize: 14
          ),
          // HeadlineMedium == ChooseAuthView'daki Giriş Yap fontunu temsil ediyor. Beyaz renginden anlaşılır
          headlineMedium: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
          //HeadlineSmall == Tweetleri silerken sil  butonu gibi veya tweet tarihini gösteren tarih gibi küçük gri yazılara verilir
          headlineSmall: TextStyle(
            fontSize: 10,
            color: CupertinoColors.systemGrey3,
          )
        )
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return const BottomNavigationBarView();
          } else {
            return const ChooseAuthView();
          }
        },
      ),
    );
  }
}