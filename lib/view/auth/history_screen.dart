import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
          appBar: AppBar(
            title: const Text("History"),
            centerTitle: true,
            backgroundColor: themeNotifier.isDark
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            iconTheme: const IconThemeData(color: ColorUtils.white),
          ),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child:
                        Lottie.asset("assets/icons/history.json", height: 50.w),
                  ),
                  ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.w, horizontal: 5.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 3.h,
                                    width: 6.w,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        border: Border.all(
                                            color: themeNotifier.isDark
                                                ? ColorUtils.white
                                                : ColorUtils.primaryColor)),
                                    child: Center(
                                      child: Text(
                                        "${1}",
                                        style: FontTextStyle.Proxima14Regular
                                            .copyWith(
                                                fontWeight:
                                                    FontWeightClass.extraB,
                                                color: themeNotifier.isDark
                                                    ? ColorUtils.white
                                                    : ColorUtils.primaryColor),
                                      ),
                                    ),
                                  ),
                                  SizeConfig.sW3,
                                  Center(
                                    child: Text(
                                      "Project Name",
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              fontWeight:
                                                  FontWeightClass.extraB,
                                              fontSize: 13.sp,
                                              color: themeNotifier.isDark
                                                  ? ColorUtils.white
                                                  : ColorUtils.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: ColorUtils.greyCE,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
