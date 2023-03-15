import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ToDo extends StatefulWidget {
  String id;

  ToDo({required this.id});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyBottomNavigation1 = GlobalKey();

  @override
  void initState() {
    createTutorial();
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: ColorUtils.primaryColor.withOpacity(0.1),
      textSkip: "SKIP",
      textStyleSkip: const TextStyle(color: ColorUtils.white),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
    Future.delayed(Duration(milliseconds: 500), showTutorial);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("swipe the right side box",
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.white,
                          fontWeight: FontWeightClass.extraB)),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
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
        body: StreamBuilder<QuerySnapshot>(
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
                  physics: const NeverScrollableScrollPhysics(),
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
                                        builder: (context) => ShowTaskToDo(
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
                        child: GestureDetector(
                          onTap: () {
                            showTutorial();
                          },
                          child: Container(
                            key: i == 0 ? keyBottomNavigation1 : null,
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
                      ),
                    );
                  },
                );
              } else
                return CircularProgressIndicator();
            }));
  }
}

class ShowTaskToDo extends StatefulWidget {
  String id;
  String Project;

  ShowTaskToDo({required this.id, required this.Project});

  @override
  State<ShowTaskToDo> createState() => _ShowTaskToDoState();
}

class _ShowTaskToDoState extends State<ShowTaskToDo> {
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
                  .collection('Task')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = snapshot.data!.docs[i];
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 7.w),
                          child: Container(
                            height: 30.h,
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
                                    : GestureDetector(
                                        onTap: () async {
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
                                                        'Download',
                                                        style: FontTextStyle
                                                                .Proxima16Medium
                                                            .copyWith(
                                                                color: ColorUtils
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeightClass
                                                                        .extraB,
                                                                fontSize:
                                                                    13.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                      'Are You Want To Download Image ?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FontTextStyle
                                                              .Proxima16Medium
                                                          .copyWith(
                                                              color: ColorUtils
                                                                  .primaryColor)),
                                                  actions: [
                                                    InkWell(
                                                      onTap: () async {
                                                        try {
                                                          var imageId =
                                                              await ImageDownloader
                                                                  .downloadImage(
                                                            data['Image']
                                                                .toString(),
                                                          );
                                                        } catch (error) {
                                                          print(error);
                                                        }
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        height: 10.w,
                                                        width: 25.w,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                            color: ColorUtils
                                                                .primaryColor),
                                                        child: const Center(
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorUtils
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
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                            color: ColorUtils
                                                                .primaryColor),
                                                        child: const Center(
                                                          child: Text(
                                                            "Cancle",
                                                            style: TextStyle(
                                                                color:
                                                                    ColorUtils
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Image.network(
                                          data['Image'],
                                          height: 10.h,
                                          width: 20.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    'Due Date ' + data['LastDate'],
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
                                    'Assign Date ' +
                                        data['AssignDate'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            color: ColorUtils.white,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                                const Spacer(),
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
                                                        if (_auth.currentUser!
                                                                .uid ==
                                                            abc.get('Uid')) {
                                                          Name =
                                                              abc.get('Name');
                                                          Email =
                                                              abc.get('Email');
                                                        }
                                                      }

                                                      FirebaseFirestore.instance
                                                          .collection(id)
                                                          .doc(id)
                                                          .collection(Project)
                                                          .doc(Project)
                                                          .collection('Process')
                                                          .doc()
                                                          .set({
                                                        'AssignDate':
                                                            data['AssignDate'],
                                                        'LastData':
                                                            data['LastDate'],
                                                        'StartingDate':
                                                            DateFormat(
                                                                    'dd-MMM-yy')
                                                                .format(DateTime
                                                                    .now()),
                                                        'task': data['Task'],
                                                        'Image': data["Image"],
                                                        'Name': Name,
                                                        'Email': Email,
                                                      });
                                                      try {
                                                        // Get a reference to the 'task' subcollection
                                                        CollectionReference
                                                            taskCollection =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(id)
                                                                .doc(id)
                                                                .collection(
                                                                    Project)
                                                                .doc(Project)
                                                                .collection(
                                                                    'task');

                                                        // Query for the document with field name 'task' and value 'mk'
                                                        QuerySnapshot
                                                            querySnapshot =
                                                            await taskCollection
                                                                .where('task',
                                                                    isEqualTo: data[
                                                                        'Task'])
                                                                .get();

                                                        // Delete the document(s) found by the query
                                                        querySnapshot.docs
                                                            .forEach((doc) {
                                                          doc.reference
                                                              .delete();
                                                        });
                                                      } catch (e) {
                                                        print(
                                                            'Error deleting document: $e');
                                                      }

                                                      FirebaseFirestore.instance
                                                          .collection(id)
                                                          .doc(id)
                                                          .collection('user')
                                                          .doc(_auth
                                                              .currentUser!.uid)
                                                          .collection(
                                                              'Current Project')
                                                          .doc(Project)
                                                          .collection('Process')
                                                          .doc()
                                                          .set({
                                                        'AssignDate':
                                                            data['AssignDate'],
                                                        'LastDate':
                                                            data['LastDate'],
                                                        'StartingDate':
                                                            DateFormat(
                                                                    'dd-MMM-yy')
                                                                .format(DateTime
                                                                    .now()),
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
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorUtils.primaryColor,
                      strokeWidth: 1.1,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
