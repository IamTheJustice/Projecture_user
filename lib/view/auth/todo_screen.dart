import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../utils/shimmer_effect.dart';

class ToDo extends StatefulWidget {
  String id;

  ToDo({super.key, required this.id});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  late TutorialCoachMark tutorialCoachMark;
  bool isShimmer = true;
  Future durationShimmer() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isShimmer = false;
    setState(() {});
  }

  GlobalKey keyBottomNavigation1 = GlobalKey();

  @override
  void initState() {
    durationShimmer();
    createTutorial();
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: ColorUtils.primaryColor.withOpacity(0.0),
      textSkip: "SKIP",
      textStyleSkip: TextStyle(color: ColorUtils.white, fontSize: 15.sp),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget======================>>>>>>>>>>>: $target');
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
    Future.delayed(const Duration(milliseconds: 600), showTutorial);
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
                          fontSize: 14.sp,
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
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Project List"),
            centerTitle: true,
            backgroundColor: themeNotifier.isDark
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            iconTheme: const IconThemeData(color: ColorUtils.white),
          ),
          body: isShimmer == true
              ? projectList()
              : StreamBuilder<QuerySnapshot>(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowTaskToDo(
                                                      id: id,
                                                      Project: data[
                                                          'PROJECT NAME'])));
                                    },
                                    child: Container(
                                      height: 18.w,
                                      margin: EdgeInsets.only(left: 3.sp),
                                      decoration: BoxDecoration(
                                        color: themeNotifier.isDark
                                            ? ColorUtils.blueF0
                                            : ColorUtils.purple
                                                .withOpacity(0.7),
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
                              child: GestureDetector(
                                onTap: () {
                                  showTutorial();
                                },
                                child: Container(
                                  key: i == 0 ? keyBottomNavigation1 : null,
                                  height: 18.w,
                                  width: Get.width,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: ColorUtils.purple),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 3.w),
                                    child: Text(
                                      data['PROJECT NAME'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: FontTextStyle.Proxima16Medium
                                          .copyWith(
                                              color: ColorUtils.white,
                                              fontSize: 13.sp,
                                              fontWeight:
                                                  FontWeightClass.extraB),
                                    ),
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
                        color: ColorUtils.primaryColor,
                        strokeWidth: 1.1,
                      ));
                    }
                  }));
    });
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
                        DateTime LastDate = DateTime.parse(data['LastDate']);
                        // int year = int.parse(
                        //     data['LastDate'].toString().split("-").first);
                        // int month = int.parse(
                        //     data['LastDate'].toString().split("-")[1]);
                        // int day = int.parse(
                        //     data['LastDate'].toString().split("-").);
                        // print("$year $month $day");
                        // final Lastdate = data['LastDate'];
                        final Today = DateTime.now();
                        int difference = Today.difference(LastDate).inDays;
                        print(difference);

                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.w, horizontal: 7.w),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: difference <= 0
                                      ? ColorUtils.purple
                                      : Colors.red,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorUtils.black.withOpacity(0.1),
                                      spreadRadius: 0.5,
                                      blurRadius: 9.0,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Theme(
                                data:
                                    ThemeData(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  iconColor: ColorUtils.white,
                                  collapsedIconColor: Colors.white,
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizeConfig.sH1,
                                      Text(
                                        "Task Name : ${data['Task']}",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: ColorUtils.white),
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
                                                            color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child: FullScreenWidget(
                                                disposeLevel:
                                                    DisposeLevel.Medium,
                                                backgroundIsTransparent: true,
                                                child: Container(
                                                  height: 14.h,
                                                  width: 35.w,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              ColorUtils.white,
                                                          width: 2)),
                                                  child: Image.network(
                                                    data['Image'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizeConfig.sH1,
                                    ],
                                  ),
                                  children: <Widget>[
                                    SizedBox(
                                      height: 250.0,
                                      width: Get.width,
                                      child: Padding(
                                          padding: EdgeInsets.only(bottom: 3.h),
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
                                                    top: 1.h, left: 5.w),
                                                child: Text(
                                                  'Description : ${data['Description']} ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: FontTextStyle
                                                      .Proxima16Medium.copyWith(
                                                    color: ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 1.h, left: 5.w),
                                                child: Text(
                                                  "Assign Date : ${data['AssignDate']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: FontTextStyle
                                                      .Proxima16Medium.copyWith(
                                                    color: ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 1.h, left: 5.w),
                                                child: Text(
                                                  "Due Date : ${LastDate.year}-${LastDate.month}-${LastDate.day}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: FontTextStyle
                                                      .Proxima16Medium.copyWith(
                                                    color: ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 1.h, left: 5.w),
                                                child: Text(
                                                  "Task Point : ${data['Point']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: FontTextStyle
                                                      .Proxima16Medium.copyWith(
                                                    color: ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  ColorUtils
                                                                      .white,
                                                              title: Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/sessionEnd.gif",
                                                                    scale: 1.w,
                                                                  ),
                                                                  Text(
                                                                    'Complete !',
                                                                    style: FontTextStyle.Proxima16Medium.copyWith(
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
                                                                  'are you sure you had done this task ?',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FontTextStyle
                                                                          .Proxima16Medium
                                                                      .copyWith(
                                                                          color:
                                                                              ColorUtils.primaryColor)),
                                                              actions: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    final QuerySnapshot result = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            id)
                                                                        .doc(id)
                                                                        .collection(
                                                                            'user')
                                                                        .get();
                                                                    final List<
                                                                            DocumentSnapshot>
                                                                        document1 =
                                                                        result
                                                                            .docs;
                                                                    for (var abc
                                                                        in document1) {
                                                                      if (_auth
                                                                              .currentUser!
                                                                              .uid ==
                                                                          abc.get(
                                                                              'Uid')) {
                                                                        Name = abc
                                                                            .get('Name');
                                                                        Email =
                                                                            abc.get('Email');
                                                                      }
                                                                    }
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            id)
                                                                        .doc(id)
                                                                        .collection(
                                                                            Project)
                                                                        .doc(
                                                                            Project)
                                                                        .collection(
                                                                            'Process')
                                                                        .doc()
                                                                        .set({
                                                                      'Point': data[
                                                                          'Point'],
                                                                      'AssignDate':
                                                                          data[
                                                                              'AssignDate'],
                                                                      'task': data[
                                                                          'Task'],
                                                                      'Image': data[
                                                                          "Image"],
                                                                      'Name':
                                                                          Name,
                                                                      'Email':
                                                                          Email,
                                                                      'LastDate':
                                                                          data[
                                                                              'LastDate'],
                                                                      'StartingDate': DateFormat(
                                                                              'dd-MMM-yy')
                                                                          .format(
                                                                              DateTime.now()),
                                                                      'Description':
                                                                          data[
                                                                              'Description'],
                                                                    }).whenComplete(() => FirebaseFirestore
                                                                            .instance
                                                                            .collection(id)
                                                                            .doc(id)
                                                                            .collection(Project)
                                                                            .doc(Project)
                                                                            .collection('Task')
                                                                            .where(
                                                                              'Task',
                                                                              isEqualTo: data['Task'],
                                                                            ));
                                                                    try {
                                                                      // Get a reference to the 'task' subcollection
                                                                      CollectionReference taskCollection = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              id)
                                                                          .doc(
                                                                              id)
                                                                          .collection(
                                                                              Project)
                                                                          .doc(
                                                                              Project)
                                                                          .collection(
                                                                              'task');

                                                                      // Query for the document with field name 'task' and value 'mk'
                                                                      QuerySnapshot
                                                                          querySnapshot =
                                                                          await taskCollection
                                                                              .where('task', isEqualTo: data['Task'])
                                                                              .get();

                                                                      // Delete the document(s) found by the query
                                                                      querySnapshot
                                                                          .docs
                                                                          .forEach(
                                                                              (doc) {
                                                                        doc.reference
                                                                            .delete();
                                                                      });
                                                                    } catch (e) {
                                                                      print(
                                                                          'Error deleting document: $e');
                                                                    }
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            id)
                                                                        .doc(id)
                                                                        .collection(
                                                                            'user')
                                                                        .doc(_auth
                                                                            .currentUser!
                                                                            .uid)
                                                                        .collection(
                                                                            'Current Project')
                                                                        .doc(
                                                                            Project)
                                                                        .collection(
                                                                            'Process')
                                                                        .doc()
                                                                        .set({
                                                                      'Point': data[
                                                                          'Point'],
                                                                      'Description':
                                                                          data[
                                                                              'Description'],
                                                                      'Task': data[
                                                                          'Task'],
                                                                      'Image': data[
                                                                          'Image'],
                                                                      'AssignDate':
                                                                          data[
                                                                              'AssignDate'],
                                                                      'LastDate':
                                                                          data[
                                                                              'LastDate'],
                                                                      'StartingDate': DateFormat(
                                                                              'dd-MMM-yy')
                                                                          .format(
                                                                              DateTime.now()),
                                                                    }).whenComplete(() =>
                                                                            {
                                                                              snapshot.data!.docs[i].reference.delete()
                                                                            });
                                                                    Get.back();
                                                                    Get.showSnackbar(
                                                                      GetSnackBar(
                                                                        message:
                                                                            "Start Task Succesfully",
                                                                        borderRadius:
                                                                            10.0,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                4.w,
                                                                            right: 4.w,
                                                                            bottom: 4.w),
                                                                        snackPosition:
                                                                            SnackPosition.BOTTOM,
                                                                        backgroundColor: themeNotifier.isDark
                                                                            ? ColorUtils.black
                                                                            : ColorUtils.primaryColor.withOpacity(0.9),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        10.w,
                                                                    width: 25.w,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                8.0)),
                                                                        color: ColorUtils
                                                                            .primaryColor),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        "Done",
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorUtils.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        10.w,
                                                                    width: 25.w,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                8.0)),
                                                                        color: ColorUtils
                                                                            .primaryColor),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorUtils.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 4.w,
                                                      ),
                                                      child: Container(
                                                        height: 4.h,
                                                        width: 20.w,
                                                        decoration: const BoxDecoration(
                                                            color: ColorUtils
                                                                .white,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        12.0))),
                                                        child: Center(
                                                          child: Text(
                                                            "Start",
                                                            style: FontTextStyle
                                                                    .Proxima16Medium
                                                                .copyWith(
                                                                    color: ColorUtils
                                                                        .purple,
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontWeight:
                                                                        FontWeightClass
                                                                            .semiB),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
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
    });
  }
}
