import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/view/auth/splash_screen.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
          title: 'Projecture',
          theme: ThemeData(
            progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: ColorUtils.primaryColor),
          ),
          debugShowCheckedModeBanner: false,
          // smartManagement: SmartManagement.full,
          home: const SplashScreen(),
          // home: LoyPitu(),
        );
      },
    );
  }
}
