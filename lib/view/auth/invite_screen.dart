import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class InviteScreen extends StatefulWidget {
  String id;
  InviteScreen({super.key, required this.id});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    setData();
    super.initState();
  }

  String? cid;
  String? uid;
  String? token;
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
    String id = widget.id;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Project List"),
          centerTitle: true,
          backgroundColor:
              themeNotifier.isDark ? ColorUtils.black : ColorUtils.primaryColor,
          iconTheme: const IconThemeData(color: ColorUtils.white),
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(id)
                    .doc(id)
                    .collection('user')
                    .doc(_auth.currentUser!.uid)
                    .collection('Invite')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, i) {
                          var data = snapshot.data!.docs[i];
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.w, horizontal: 3.w),
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorUtils.white),
                                  child: Theme(
                                    data: ThemeData(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      iconColor: ColorUtils.primaryColor,
                                      title: Text(
                                        data['PROJECT NAME'],
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: ColorUtils.primaryColor),
                                      ),
                                      children: <Widget>[
                                        SizedBox(
                                          width: Get.width,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 3.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w,
                                                        right: 3.w,
                                                        top: 1.h),
                                                    child: Text(
                                                      data['DESCRIPTION'],
                                                      style: TextStyle(
                                                          fontSize: 10.sp),
                                                    ),
                                                  ),
                                                  SizeConfig.sH3,
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 2.w),
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Alert',
                                                                      style: FontTextStyle.Proxima16Medium.copyWith(
                                                                          color: ColorUtils
                                                                              .primaryColor,
                                                                          fontWeight: FontWeightClass
                                                                              .extraB,
                                                                          fontSize:
                                                                              15.sp),
                                                                    ),
                                                                    SizeConfig
                                                                        .sH1,
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                    'are you sure you want to join Project?',
                                                                    style: FontTextStyle
                                                                            .Proxima16Medium
                                                                        .copyWith(
                                                                            color:
                                                                                ColorUtils.primaryColor)),
                                                                actions: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      final QuerySnapshot result = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              id)
                                                                          .doc(
                                                                              id)
                                                                          .collection(
                                                                              'user')
                                                                          .get();
                                                                      final List<
                                                                              DocumentSnapshot>
                                                                          documents =
                                                                          result
                                                                              .docs;

                                                                      for (var doc
                                                                          in documents) {
                                                                        print(
                                                                            "id is  ${doc.id}");
                                                                        if (_auth.currentUser!.uid ==
                                                                            doc.id) {
                                                                          token =
                                                                              doc.get('fcmToken');
                                                                          break;
                                                                        }
                                                                      }
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              id)
                                                                          .doc(
                                                                              id)
                                                                          .collection(data['PROJECT NAME']
                                                                              .toString())
                                                                          .doc(_auth
                                                                              .currentUser!
                                                                              .uid)
                                                                          .set({
                                                                        'fcmToken':
                                                                            token,
                                                                        "Name":
                                                                            data['name'],
                                                                        "Email":
                                                                            data['Email'],
                                                                        "Uid": _auth
                                                                            .currentUser!
                                                                            .uid,
                                                                        //"EMAIL": data["email"],
                                                                        //"EMAIL": data["email"],
                                                                      });
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              id)
                                                                          .doc(
                                                                              id)
                                                                          .collection(
                                                                              'user')
                                                                          .doc(_auth
                                                                              .currentUser!
                                                                              .uid)
                                                                          .collection(
                                                                              'Current Project')
                                                                          .doc(data[
                                                                              'PROJECT NAME'])
                                                                          .set({
                                                                        'Project Name':
                                                                            data['PROJECT NAME'],
                                                                        'Description':
                                                                            data['DESCRIPTION'],
                                                                        'Platform':
                                                                            data['PLATFORM'],
                                                                      }).whenComplete(
                                                                              () {
                                                                        snapshot
                                                                            .data!
                                                                            .docs[i]
                                                                            .reference
                                                                            .delete();
                                                                      });
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          10.w,
                                                                      width:
                                                                          25.w,
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              8.0)),
                                                                          color:
                                                                              ColorUtils.primaryColor),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            Text(
                                                                          "Done",
                                                                          style:
                                                                              TextStyle(color: ColorUtils.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          10.w,
                                                                      width:
                                                                          25.w,
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              8.0)),
                                                                          color:
                                                                              ColorUtils.primaryColor),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            Text(
                                                                          "Cancle",
                                                                          style:
                                                                              TextStyle(color: ColorUtils.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          height: 12.w,
                                                          width: 30.w,
                                                          decoration: const BoxDecoration(
                                                              color: ColorUtils
                                                                  .primaryColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8.0))),
                                                          child: Center(
                                                            child: Text(
                                                              "Accept",
                                                              style: FontTextStyle
                                                                      .Proxima16Medium
                                                                  .copyWith(
                                                                      color: ColorUtils
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeightClass
                                                                              .semiB),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                        color: ColorUtils.primaryColor,
                      ),
                    );
                  }
                }),
          ),
        ),
      );
    });
  }
}
