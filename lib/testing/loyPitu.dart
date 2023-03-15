import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoyPitu extends StatefulWidget {
  String id;
  String Project;
  LoyPitu({required this.id, required this.Project});

  @override
  State<LoyPitu> createState() => _LoyPituState();
}

class _LoyPituState extends State<LoyPitu> {
  final _auth = FirebaseAuth.instance;
  var selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    String Project = widget.Project;
    late String Name;
    late String Email;
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
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(id)
                    .doc(id)
                    .collection('user')
                    .doc(_auth.currentUser!.uid)
                    .collection('Current Project')
                    .doc(Project)
                    .collection('Process')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 2.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, i) {
                          var data = snapshot.data!.docs[i];
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorUtils.white),
                                  child: Theme(
                                    data: ThemeData(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      iconColor: ColorUtils.primaryColor,
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Task Name : ${data['Task']}",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: ColorUtils.primaryColor),
                                          ),
                                          SizeConfig.sH1,
                                          data['Image'] == ""
                                              ? Center(
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset(
                                                          "assets/lotties/warning.json",
                                                          height: 10.w),
                                                      Text(
                                                        " No Image",
                                                        style: FontTextStyle
                                                                .Proxima16Medium
                                                            .copyWith(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Center(
                                                  child: SizedBox(
                                                    height: 12.h,
                                                    width: 30.w,
                                                    child: Image.network(
                                                      data['Image'],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                          SizeConfig.sH1,
                                        ],
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
                                                        left: 3.w, right: 3.w),
                                                    child: const Divider(
                                                      color: ColorUtils.greyCE,
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w,
                                                        right: 3.w,
                                                        top: 1.h),
                                                    child: Text(
                                                      "Assign Date : ${data['AssignDate']}",
                                                      style: TextStyle(
                                                          fontSize: 10.sp),
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
                })),
      ),
    );
  }
}
