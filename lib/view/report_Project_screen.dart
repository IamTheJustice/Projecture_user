import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/shimmer_effect.dart';
import 'package:projecture/view/auth/Report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ReportProject extends StatefulWidget {
  const ReportProject({Key? key}) : super(key: key);

  @override
  State<ReportProject> createState() => _ReportProjectState();
}

class _ReportProjectState extends State<ReportProject> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    setData();
    super.initState();
  }

  String? id;

  setData() async {
    final pref = await SharedPreferences.getInstance();
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);
    id = pref.getString("companyId");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: id != null
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(id!)
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, i) {
                        var data = snapshot.data!.docs[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 5.w),
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => ShowTaskProcess(
                                    //             id: id,
                                    //             Project: data['Project Name'])));
                                    Get.to(() =>
                                        Report(Project: data['Project Name']));
                                  },
                                  child: Container(
                                    height: 18.w,
                                    margin: EdgeInsets.only(left: 3.sp),
                                    decoration: BoxDecoration(
                                      color:
                                          ColorUtils.green2A.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Show \nTask",
                                        style: FontTextStyle.Proxima16Medium
                                            .copyWith(
                                                color: ColorUtils.white,
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
                                      fontSize: 13.sp,
                                      fontWeight: FontWeightClass.extraB),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
            : SizedBox(),
      ),
    );
  }
}
