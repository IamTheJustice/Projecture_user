import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    setState(() {});
  }

  int totalPoints = 0;

  bool wallet = false;
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
                TextButton(
                    onPressed: () async {
                      int totalPoint = 0;
                      final querySnapshot = await FirebaseFirestore.instance
                          .collection(cid!)
                          .doc(cid)
                          .collection('user')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Wallet')
                          .get();
                      final documents = querySnapshot.docs;
                      for (final document in documents) {
                        final data = document.data();
                        if (data.containsKey('Archives Point')) {
                          final point = data['Archives Point'] as int;
                          totalPoint += point;

                          log('==============${totalPoints}');
                        }
                      }

                      setState(() {
                        wallet = true;
                        totalPoints = totalPoint;
                      });
                    },
                    child: Text("Show Point")),
                wallet != false
                    ? Center(
                        child: Text(
                          '$totalPoints',
                          style: FontTextStyle.Proxima16Medium.copyWith(
                              fontSize: 17.sp,
                              color: ColorUtils.greyCE,
                              fontWeight: FontWeightClass.extraB),
                        ),
                      )
                    : SizedBox(),
                cid != null
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(cid!)
                            .doc(cid)
                            .collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('Wallet')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data!.docs[index];
                                  return Column(
                                    children: [
                                      SizeConfig.sH2,
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: Container(
                                          height: 10.h,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 9.0,
                                                    spreadRadius: 0.5,
                                                    color: ColorUtils.black
                                                        .withOpacity(0.2))
                                              ],
                                              color: ColorUtils.purple,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['Task'],
                                                      style: FontTextStyle
                                                              .Proxima14Regular
                                                          .copyWith(
                                                              color: ColorUtils
                                                                  .white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                data['Archives Point']
                                                    .toString(),
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color:
                                                            ColorUtils.green40,
                                                        fontSize: 13.sp),
                                              ),
                                              SizeConfig.sW3,
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorUtils.primaryColor,
                                strokeWidth: 1.1,
                              ),
                            );
                          }
                        })
                    : SizedBox(),
              ],
            ),
          ),
        ));
  }
}
