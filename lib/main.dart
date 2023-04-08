import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/provider/user_contact_provider.dart';
import 'package:projecture/utils/const/function/local_notification_services.dart';
import 'package:projecture/view/auth/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("message:::::: $message");
  await Firebase.initializeApp();

  // LocalNotificationServices.display(message);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp();
  LocalNotificationServices.initialize();
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    print('on refresh token');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    FirebaseFirestore.instance.collection('user').doc(currentUser.uid).update({
      'fcmToken': fcmToken
    });
    // TODO: If necessary send token to application server.

    // token is generated.
  }).onError((err) {
    // Error getting token.
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  print("token:::::: ${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessageOpenedApp:onmessage $message ${message.data['phoneNumber']}");

    log("111111111::::: ${message}${message.data}");
    if (message.notification != null) {
      log("111111111::::: ${message.data}");

      LocalNotificationServices.display(message);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModelTheme()),
        ChangeNotifierProvider(create: (context) => UserContactProvider()),
      ],
      child: Consumer<ModelTheme>(builder: (context, ModelTheme themeNotifier, child) {
        return Sizer(
          builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
            return GetMaterialApp(
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: child!,
                );
              },
              title: 'Projecture',
              theme: themeNotifier.isDark ? ThemeData(brightness: Brightness.dark) : ThemeData(brightness: Brightness.light),
              debugShowCheckedModeBanner: false,
              // smartManagement: SmartManagement.full,
              home: const SplashScreen(),
            );
          },
        );
      }),
    );
  }
}
