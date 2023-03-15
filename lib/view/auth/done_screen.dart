import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class DoneScreen extends StatefulWidget {
  String id;
  DoneScreen({required this.id});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
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
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, i) {
                    var data = snapshot.data!.docs[i];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.w, horizontal: 5.w),
                      child: Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ShowTaskDone(
                                //             id: id,
                                //             Project: data['Project Name'])));
                                Get.to(() => ShowTaskDone(
                                    id: id, Project: data['Project Name']));
                              },
                              child: Container(
                                height: 18.w,
                                margin: EdgeInsets.only(left: 3.sp),
                                decoration: BoxDecoration(
                                  color: ColorUtils.green2A.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Show \nTask",
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            fontWeight: FontWeightClass.semiB),
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
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.1,
                  color: ColorUtils.primaryColor,
                ));
              }
            }),
      ),
    );
  }
}

class ShowTaskDone extends StatefulWidget {
  String id;
  String Project;
  ShowTaskDone({required this.id, required this.Project});

  @override
  State<ShowTaskDone> createState() => _ShowTaskDoneState();
}

class _ShowTaskDoneState extends State<ShowTaskDone> {
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
        title: const Text("Show Task"),
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
                  .collection('Current Project')
                  .doc(Project)
                  .collection('Done')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = snapshot.data!.docs[i];
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 7.w),
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: ColorUtils.purple,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
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
                                                  .copyWith(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Image.network(
                                        data['Image'],
                                        height: 15.h,
                                        width: 25.w,
                                        fit: BoxFit.cover,
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Task Assign Date " + data['AssignDate'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Due Date " + data['LastDate'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Task Starting Date " +
                                        data['StartingDate'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Checking Request Date " +
                                        data['CheckRequestDate'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    "Task Approved Date " +
                                        data['ApprovedDate'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                SizeConfig.sH1,
                              ],
                            ),
                          ));
                    },
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1.1,
                    color: ColorUtils.primaryColor,
                  ));
                }
              }),
        ),
      ),
    );
  }
}
