import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message != null) {
    print("Background message received:");
  } else {
    print("Background message is null.");
  }
}

class FirebaseNotificationsApi {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> requestPermissions() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
    } else if (status.isDenied) {

      PermissionStatus permissionStatus = await Permission.notification.request();

      if (permissionStatus.isGranted) {
      } else {
        print('Notification permission denied');
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bildirim İzni"),
          content: const Text("Uygulamadan gelen bildirimleri görmek için Lütfen Bildirimlere izin verin."),
          actions: [
            ElevatedButton(
              child: const Text("Tamam"),
              onPressed: () {
                requestPermissions();
                Navigator.of(_scaffoldKey.currentContext!).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    var permissionGranted = await _firebaseMessaging.requestPermission();
    if (permissionGranted == PermissionStatus.granted) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
      } else {
        FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
      }
    } else {
        FirebaseNotificationsApi().requestPermissions();
    }
  }

}