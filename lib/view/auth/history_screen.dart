import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? id;
  String? uid;
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

  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("History"),
            centerTitle: true,
            backgroundColor: themeNotifier.isDark
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            iconTheme: const IconThemeData(color: ColorUtils.white),
          ),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child:
                        Lottie.asset("assets/icons/history.json", height: 50.w),
                  ),
                  ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data = snapshot.data!.docs[index];

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1.w, horizontal: 5.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizeConfig.sW3,
                                              Center(
                                                child: Text(
                                                  data['Project Name'],
                                                  style: FontTextStyle
                                                          .Proxima16Medium
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeightClass
                                                                  .extraB,
                                                          fontSize: 13.sp,
                                                          color: themeNotifier
                                                                  .isDark
                                                              ? ColorUtils.white
                                                              : ColorUtils
                                                                  .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            color: ColorUtils.greyCE,
                                          )
                                        ],
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
                            })
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
