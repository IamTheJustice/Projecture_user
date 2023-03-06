import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

class InviteScreen extends StatefulWidget {
  String id;
  InviteScreen({required this.id});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  List<Map<String, dynamic>> inviteList = <Map<String, dynamic>>[
    {"text": 'Stress level'},
    {"text": 'Anger/lrritability'},
    {"text": 'Repressed emotions'},
    {"text": 'Conflict'},
  ];
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project List"),
        centerTitle: true,
        backgroundColor: ColorUtils.primaryColor,
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
                                  vertical: 2.w, horizontal: 3.w),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            ColorUtils.greyBB.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
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
                                                SizeConfig.sH1,
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
                                                                        fontWeight:
                                                                            FontWeightClass
                                                                                .extraB,
                                                                        fontSize:
                                                                            13.sp),
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
                                                                  onTap: () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            id)
                                                                        .doc(id)
                                                                        .collection(data['PROJECT NAME']
                                                                            .toString())
                                                                        .doc(_auth
                                                                            .currentUser!
                                                                            .uid)
                                                                        .set({
                                                                      "Name": data[
                                                                          'name'],
                                                                      "Email": data[
                                                                          'Email'],
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
                                                                        .doc(id)
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
                                                                          data[
                                                                              'PROJECT NAME'],
                                                                      'Description':
                                                                          data[
                                                                              'DESCRIPTION'],
                                                                      'Platform':
                                                                          data[
                                                                              'PLATFORM'],
                                                                    }).whenComplete(
                                                                            () {
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              i]
                                                                          .reference
                                                                          .delete();
                                                                    });
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        10.w,
                                                                    width: 25.w,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                8.0)),
                                                                        color: ColorUtils
                                                                            .primaryColor),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        "Done",
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorUtils.white),
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
                                                                    width: 25.w,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                8.0)),
                                                                        color: ColorUtils
                                                                            .primaryColor),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        "Cancle",
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorUtils.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        height: 12.w,
                                                        width: 30.w,
                                                        decoration: const BoxDecoration(
                                                            color: ColorUtils
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        8.0))),
                                                        child: Center(
                                                          child: Text(
                                                            "Invite",
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
                } else
                  return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
