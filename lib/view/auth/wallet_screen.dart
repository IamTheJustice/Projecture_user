import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallet"),
          centerTitle: true,
          backgroundColor: ColorUtils.primaryColor,
          iconTheme: const IconThemeData(color: ColorUtils.white),
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizeConfig.sH2,
                Center(
                  child: Text(
                    "130 Points",
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        fontSize: 17.sp,
                        color: ColorUtils.greyCE,
                        fontWeight: FontWeightClass.extraB),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizeConfig.sH2,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Container(
                              height: 10.h,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 9.0,
                                        spreadRadius: 0.5,
                                        color:
                                            ColorUtils.black.withOpacity(0.2))
                                  ],
                                  color: ColorUtils.purple,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "FIREBASE AUTHENTICATION",
                                          style: FontTextStyle.Proxima14Regular
                                              .copyWith(
                                                  color: ColorUtils.white),
                                        ),
                                        Text(
                                          "IN FLUTTER",
                                          style: FontTextStyle.Proxima14Regular
                                              .copyWith(
                                                  color: ColorUtils.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "+ 30",
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.green40,
                                            fontSize: 13.sp),
                                  ),
                                  SizeConfig.sW3,
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
