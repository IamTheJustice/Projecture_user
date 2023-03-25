import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/leader/project_member_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LeaderGiveTaskScreen extends StatefulWidget {
  String id;
  LeaderGiveTaskScreen({super.key, required this.id});

  @override
  State<LeaderGiveTaskScreen> createState() => _LeaderGiveTaskScreenState();
}

class _LeaderGiveTaskScreenState extends State<LeaderGiveTaskScreen> {
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
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(id)
                .doc(id)
                .collection('Leader')
                .doc(_auth.currentUser!.uid)
                .collection("LEADING PROJECTS")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: 2.h),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, i) {
                    var data = snapshot.data!.docs[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.8.h, horizontal: 5.w),
                      child: Container(
                        height: 24.w,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: ColorUtils.purple),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['Project name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeightClass.extraB,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ProjectMemberScreen(
                                            id: id,
                                            Project: data['Project name']);
                                      }));
                                    },
                                    child: Container(
                                      height: 4.5.h,
                                      width: 29.w,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: Center(
                                        child: Text(
                                          "Give Task",
                                          style: FontTextStyle.Proxima16Medium
                                              .copyWith(
                                                  color: ColorUtils.purple,
                                                  fontSize: 13.sp,
                                                  fontWeight:
                                                      FontWeightClass.semiB),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                ));
              }
            }),
      );
    });
  }
}
