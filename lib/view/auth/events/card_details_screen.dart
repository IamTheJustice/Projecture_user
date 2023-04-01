import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../app_mode/model_theme.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/font_style_utils.dart';
import '../../../utils/size_config_utils.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  String? id;
  String? uid;
  final _auth = FirebaseAuth.instance;

  setData() async {
    final pref = await SharedPreferences.getInstance();
    id = pref.getString("companyId");
    uid = pref.getString("userId");
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Card"),
            centerTitle: true,
            backgroundColor: themeNotifier.isDark
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            iconTheme: const IconThemeData(color: ColorUtils.white),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeConfig.sH4,
              Center(
                child: Text("Frontbit solution aa company name",
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: ColorUtils.primaryColor, fontSize: 14.sp)),
              ),
              SizeConfig.sH2,
              id != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(id!)
                          .doc(id)
                          .collection('user')
                          .where('Uid', isEqualTo: _auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            child: ListView.builder(
                                itemCount: 1,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  var data = snapshot.data!.docs[i];
                                  return Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorUtils.purple,
                                                  width: 3)),
                                          child: Image.network(
                                            data['ProfileImage'],
                                            height: 15.h,
                                            width: 30.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(data['Name'],
                                            style: FontTextStyle.Proxima16Medium
                                                .copyWith(
                                                    color:
                                                        ColorUtils.primaryColor,
                                                    fontSize: 16.sp)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.w, top: 1.h),
                                        child: Text(data['City'],
                                            style: FontTextStyle.Proxima16Medium
                                                .copyWith(
                                              color: ColorUtils.primaryColor,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 9.w, top: 1.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("DOB : ",
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                                Text(data['DOB'],
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                              ],
                                            ),
                                            SizeConfig.sH05,
                                            Row(
                                              children: [
                                                Text("phone no : ",
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                                Text(data['Phone'],
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                              ],
                                            ),
                                            SizeConfig.sH05,
                                            Row(
                                              children: [
                                                Text("Email : ",
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                                Text(data['Email'],
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                      color: ColorUtils
                                                          .primaryColor,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          );
                        } else
                          return CircularProgressIndicator();
                      })
                  : SizedBox(),
              SizeConfig.sH2,
            ],
          ),
        ),
      );
    });
  }
}
