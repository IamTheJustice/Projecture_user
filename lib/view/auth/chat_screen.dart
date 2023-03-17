import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        backgroundColor:
            themeNotifier.isDark ? Colors.black.withOpacity(0.8) : Colors.white,
        body: Center(
          child: SvgPicture.asset(
            'assets/icons/test.svg',
            color: themeNotifier.isDark ? ColorUtils.white : ColorUtils.black,
          ),
        ),
      );
    });
  }
}
