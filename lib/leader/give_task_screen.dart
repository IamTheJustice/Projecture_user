import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projecture/leader/project_member_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:sizer/sizer.dart';

class LeaderGiveTaskScreen extends StatefulWidget {
  String id;
  LeaderGiveTaskScreen({required this.id});

  @override
  State<LeaderGiveTaskScreen> createState() => _LeaderGiveTaskScreenState();
}

class _LeaderGiveTaskScreenState extends State<LeaderGiveTaskScreen> {
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
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, i) {
                  var data = snapshot.data!.docs[i];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.w, horizontal: 5.w),
                    child: Container(
                      height: 24.w,
                      width: Get.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                  decoration: TextDecoration.underline),
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
                                  child: Text(
                                    "Give Task",
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeightClass.semiB),
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
            } else
              return CircularProgressIndicator();
          }),
    );
  }
}
