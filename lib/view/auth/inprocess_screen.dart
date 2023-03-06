import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

class Process extends StatefulWidget {
  String id;
  Process({required this.id});

  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowTaskProcess(
                                            id: id,
                                            Project: data['Project Name'])));
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
              } else
                return CircularProgressIndicator();
            }),
      ),
    );
  }
}

class ShowTaskProcess extends StatefulWidget {
  String id;
  String Project;
  ShowTaskProcess({required this.id, required this.Project});

  @override
  State<ShowTaskProcess> createState() => _ShowTaskProcessState();
}

class _ShowTaskProcessState extends State<ShowTaskProcess> {
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
                  .collection('Process')
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
                              vertical: 2.w, horizontal: 7.w),
                          child: Container(
                            height: 20.h,
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
                                        width: 10.w,
                                        fit: BoxFit.cover,
                                      ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Column(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/sessionEnd.gif",
                                                      scale: 1.w,
                                                    ),
                                                    Text(
                                                      'Start Task',
                                                      style: FontTextStyle
                                                              .Proxima16Medium
                                                          .copyWith(
                                                              color: ColorUtils
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeightClass
                                                                      .extraB,
                                                              fontSize: 13.sp),
                                                    ),
                                                  ],
                                                ),
                                                content: Text(
                                                    'are you sure want to start Task?',
                                                    textAlign: TextAlign.center,
                                                    style: FontTextStyle
                                                            .Proxima16Medium
                                                        .copyWith(
                                                            color: ColorUtils
                                                                .primaryColor)),
                                                actions: [
                                                  InkWell(
                                                    onTap: () async {
                                                      final QuerySnapshot
                                                          result =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(id)
                                                              .doc(id)
                                                              .collection(
                                                                  'user')
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          document1 =
                                                          result.docs;
                                                      for (var abc
                                                          in document1) {
                                                        Name = abc.get('Name');
                                                        Email =
                                                            abc.get('Email');
                                                      }
                                                      FirebaseFirestore.instance
                                                          .collection(id)
                                                          .doc(id)
                                                          .collection(Project)
                                                          .doc(Project)
                                                          .collection(
                                                              'InChecking')
                                                          .doc()
                                                          .set({
                                                        'task': data['Task'],
                                                        'Image': data["Image"],
                                                        'Name': Name,
                                                        'Email': Email,
                                                      }).whenComplete(() =>
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      id)
                                                                  .doc(id)
                                                                  .collection(
                                                                      Project)
                                                                  .doc(Project)
                                                                  .collection(
                                                                      'Task')
                                                                  .where(
                                                                    'Task',
                                                                    isEqualTo: data[
                                                                        'Task'],
                                                                  ));
                                                      FirebaseFirestore.instance
                                                          .collection(id)
                                                          .doc(id)
                                                          .collection('user')
                                                          .doc(_auth
                                                              .currentUser!.uid)
                                                          .collection(
                                                              'Current Project')
                                                          .doc(Project)
                                                          .collection(
                                                              'InChecking')
                                                          .doc()
                                                          .set({
                                                        'Task': data['Task'],
                                                        'Image': data['Image'],
                                                      }).whenComplete(() => {
                                                                snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .reference
                                                                    .delete()
                                                              });
                                                      Get.back();
                                                      Get.showSnackbar(
                                                        GetSnackBar(
                                                          message:
                                                              "Start Task Succesfully",
                                                          borderRadius: 10.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 4.w,
                                                                  right: 4.w,
                                                                  bottom: 4.w),
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          backgroundColor:
                                                              ColorUtils
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.9),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 10.w,
                                                      width: 25.w,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0)),
                                                          color: ColorUtils
                                                              .primaryColor),
                                                      child: const Center(
                                                        child: Text(
                                                          "Done",
                                                          style: TextStyle(
                                                              color: ColorUtils
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      height: 10.w,
                                                      width: 25.w,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0)),
                                                          color: ColorUtils
                                                              .primaryColor),
                                                      child: const Center(
                                                        child: Text(
                                                          "Cancle",
                                                          style: TextStyle(
                                                              color: ColorUtils
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 2.w),
                                        child: Text(
                                          "Start",
                                          style: FontTextStyle.Proxima16Medium
                                              .copyWith(
                                                  color: ColorUtils.white,
                                                  fontSize: 13.sp,
                                                  fontWeight:
                                                      FontWeightClass.semiB),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizeConfig.sH1,
                              ],
                            ),
                          ));
                    },
                  );
                } else
                  return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
