import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:projecture/service/animayted_text.dart';
import 'package:projecture/service/wavy_text.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/view/auth/Drawer_BottomNavbar_screen.dart';
import 'package:projecture/view/auth/events_screen.dart';
import 'package:projecture/view/auth/onBorading_screen.dart';
import 'package:projecture/view/auth/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  String? cid;
  String? uid;
  setData() async {
    final pref = await SharedPreferences.getInstance();
    cid = pref.getString("companyId");
    uid = pref.getString("userId");
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          splash: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                color: ColorUtils.primaryColor,
                height: 10.w,
                width: 15.w,
              ),
              AnimatedCustomeTextKit(
                animatedTexts: [
                  WavyAnimatedText(" P r o j e c t u r e ",
                      textStyle: FontTextStyle.Proxima16Medium.copyWith(
                          fontWeight: FontWeightClass.extraB,
                          fontSize: 20.sp,
                          color: ColorUtils.primaryColor),
                      speed: const Duration(milliseconds: 210)),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
            ],
          ),
          duration: 4000,
          splashTransition: SplashTransition.sizeTransition,
          backgroundColor: ColorUtils.white,
          nextScreen: uid != null ? WalletScreen() : EventScreen()),
    );
  }
}
