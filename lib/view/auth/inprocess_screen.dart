import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Process extends StatefulWidget {
  String id;
  Process({required this.id});

  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
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
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
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
                                      Get.to(() => ShowTaskProcess(
                                          id: id,
                                          Project: data['Project Name']));
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
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
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
                        child: CircularProgressIndicator(
                          color: ColorUtils.primaryColor,
                          strokeWidth: 1.1,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      );
    });
  }
}

class ShowTaskProcess extends StatefulWidget {
  String id;
  String Project;
  ShowTaskProcess({super.key, required this.id, required this.Project});

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
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor:
              themeNotifier.isDark ? ColorUtils.black : ColorUtils.primaryColor,
          title: Text(
            "Notice",
            style: FontTextStyle.Proxima16Medium.copyWith(
                fontSize: 17.sp, color: ColorUtils.white),
          ),
          centerTitle: true,
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
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, i) {
                        var data = snapshot.data!.docs[i];
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.w, horizontal: 7.w),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorUtils.purple,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
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
                                              child: SizedBox(
                                                height: 14.h,
                                                width: 35.w,
                                                child: Image.network(
                                                  data['Image'],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                      SizeConfig.sH1,
                                    ],
                                  ),
                                  children: <Widget>[
                                    SizedBox(
                                      height: 230.0,
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
                                                  'Description : ${data['Description']}',
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
                                                  "Due Date : ${data['LastDate']}",
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
                                                  "Starting Date : ${data['StartingDate']}",
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
                                                                            'InChecking')
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
                                                                      'CheckRequestDate': DateFormat(
                                                                              'dd-MMM-yy')
                                                                          .format(
                                                                              DateTime.now()),
                                                                      'StartingDate':
                                                                          data[
                                                                              'StartingDate'],
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
                                                                              'Process');

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
                                                                            'InChecking')
                                                                        .doc()
                                                                        .set({
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
                                                                      'CheckRequestDate': DateFormat(
                                                                              'dd-MMM-yy')
                                                                          .format(
                                                                              DateTime.now()),
                                                                      'StartingDate':
                                                                          data[
                                                                              'StartingDate'],
                                                                      'Point': data[
                                                                          'Point'],
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
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
      );
    });
  }
}
