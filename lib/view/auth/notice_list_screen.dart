import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class NoticeListScreen extends StatefulWidget {
  NoticeListScreen({Key? key});

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  List<Map<String, dynamic>> noticeList = <Map<String, dynamic>>[
    {"text": 'Stress level'},
    {"text": 'Anger/lrritability'},
    {"text": 'Repressed emotions'},
    {"text": 'Conflict'},
  ];
  String? cid;

  setData() async {
    final pref = await SharedPreferences.getInstance();
    cid = pref.getString("companyId");
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);

    log("cid   ${cid}");
    setState(() {});
    // String? cid = pref.getString("companyId");
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          "Notice",
          style: FontTextStyle.Proxima16Medium.copyWith(
              fontSize: 17.sp, color: ColorUtils.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorUtils.white),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Lottie.asset("assets/icons/notice.json", height: 50.w),
              ),
              cid != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(cid!)
                          .doc(cid)
                          .collection('Notice')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 2.h),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = snapshot.data!.docs[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.w, horizontal: 4.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorUtils.greyBB
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorUtils.white),
                                        child: Theme(
                                          data: ThemeData(
                                              dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            iconColor: ColorUtils.primaryColor,
                                            title: Row(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        ColorUtils.primaryColor,
                                                    radius: 20.0,
                                                    child: Image.asset(
                                                      "assets/images/noticelist.png",
                                                      color: ColorUtils.white,
                                                      scale: 3.w,
                                                    )),
                                                SizeConfig.sW2,
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['Notice Title'],
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: ColorUtils
                                                              .primaryColor),
                                                    ),
                                                    Text(
                                                      data['Date'],
                                                      style: FontTextStyle
                                                              .Proxima12Regular
                                                          .copyWith(
                                                              color: ColorUtils
                                                                  .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            children: <Widget>[
                                              SizedBox(
                                                width: Get.width,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 3.w,
                                                                  right: 3.w),
                                                          child: const Divider(
                                                            color: ColorUtils
                                                                .greyCE,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.w,
                                                                  right: 3.w,
                                                                  top: 1.h),
                                                          child: Text(
                                                            data['Description'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    10.sp),
                                                          ),
                                                        ),
                                                        SizeConfig.sH1,
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 1.1,
                          ));
                        }
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
