import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/color_utils.dart';
import '../../utils/size_config_utils.dart';

class CheckingScreen extends StatefulWidget {
  String id;
  CheckingScreen({required this.id});

  @override
  State<CheckingScreen> createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
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
    setState(() {});
  }

  final _auth = FirebaseAuth.instance;
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
        body: SingleChildScrollView(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(id)
                    .doc(id)
                    .collection('user')
                    .doc(_auth.currentUser!.uid)
                    .collection('Current Project')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 2.h),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, i) {
                        var data = snapshot.data!.docs[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.8.h, horizontal: 5.w),
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ShowTaskChecking(
                                        id: id, Project: data['Project Name']));
                                  },
                                  child: Container(
                                    height: 18.w,
                                    margin: EdgeInsets.only(left: 3.sp),
                                    decoration: BoxDecoration(
                                      color: themeNotifier.isDark
                                          ? ColorUtils.blueF0
                                          : ColorUtils.purple.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Show \nTask",
                                        style: FontTextStyle.Proxima16Medium
                                            .copyWith(
                                                color: themeNotifier.isDark
                                                    ? ColorUtils.black
                                                    : ColorUtils.white,
                                                fontWeight:
                                                    FontWeightClass.semiB),
                                      ),
                                    ),
                                  )),
                              extentRatio: .3,
                              dragDismissible: false,
                              children: const [],
                            ),
                            child: Container(
                              height: 18.w,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: ColorUtils.purple),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 3.w),
                                child: Text(
                                  data['Project Name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: FontTextStyle.Proxima16Medium.copyWith(
                                      color: ColorUtils.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: ColorUtils.primaryColor,
                      strokeWidth: 1.1,
                    );
                  }
                }),
          ),
        ),
      );
    });
  }
}

class ShowTaskChecking extends StatefulWidget {
  String id;
  String Project;
  ShowTaskChecking({required this.id, required this.Project});

  @override
  State<ShowTaskChecking> createState() => _ShowTaskCheckingState();
}

class _ShowTaskCheckingState extends State<ShowTaskChecking> {
  final _auth = FirebaseAuth.instance;
  var selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    String Project = widget.Project;
    late String Name;
    late String Email;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Show Task"),
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
                    .collection('Current Project')
                    .doc(Project)
                    .collection('InChecking')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, i) {
                        var data = snapshot.data!.docs[i];
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 7.w),
                            child: Container(
                              height: 36.h,
                              decoration: BoxDecoration(
                                  color: ColorUtils.purple,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorUtils.black.withOpacity(0.2),
                                      blurRadius: 5.0,
                                      spreadRadius: 0.9,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(
                                      data['Task'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ),
                                  SizeConfig.sH3,
                                  data['Image'] == ""
                                      ? Center(
                                          child: Text(
                                            " No Image",
                                            style: FontTextStyle.Proxima16Medium
                                                .copyWith(
                                                    color: ColorUtils.white),
                                          ),
                                        )
                                      : Image.network(
                                          data['Image'],
                                          height: 10.h,
                                          width: 20.w,
                                          fit: BoxFit.cover,
                                        ),
                                  SizeConfig.sH1,
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(
                                      "Task Assign Date : ${data['AssignDate']} ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(
                                      "Due Date : ${data['LastDate']} ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(
                                      "Task Starting Date : ${data['StartingDate']} ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Text(
                                      "Checking Request Date : ${data['CheckRequestDate']} ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              decoration:
                                                  TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: ColorUtils.primaryColor,
                      strokeWidth: 1.1,
                    );
                  }
                }),
          ),
        ),
      );
    });
  }
}
