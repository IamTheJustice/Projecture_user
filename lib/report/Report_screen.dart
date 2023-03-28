import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
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

class Report extends StatefulWidget {
  String Project;
  Report({super.key, required this.Project});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
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

  String? ArchivePoint;
  late String task = "";
  String? Startingdate;
  String? Checkrequestdate;

  String? Lastdate;
  String? Assigndate;
  String? Point;
  String? ApprovedDate;

  final formkey = GlobalKey<FormState>();
  late var formattedDateStart = "Date of Start";
  DateTime dateStart = DateTime.now();
  late var formattedDateLast = "Date of Last";
  DateTime dateLast = DateTime.now();
  final TextEditingController lastDateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  bool data1 = false;

  @override
  Widget build(BuildContext context) {
    String Project = widget.Project;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('REPORT'),
          centerTitle: true,
          backgroundColor:
              themeNotifier.isDark ? ColorUtils.black : ColorUtils.primaryColor,
          iconTheme: const IconThemeData(color: ColorUtils.white),
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 4.h),
                    child: TextFormField(
                      controller: startDateController,
                      cursorColor: ColorUtils.primaryColor,
                      readOnly: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please required StartDate";
                        }
                        return null;
                      },
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: themeNotifier.isDark
                              ? ColorUtils.white
                              : ColorUtils.primaryColor),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4.w),
                          filled: true,
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: formattedDateStart,
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? Colors.white60
                                  : ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        primary: ColorUtils.primaryColor,
                                        onPrimary: ColorUtils.white,
                                        onSurface: ColorUtils.primaryColor)),
                                child: child!);
                          },
                          initialDate: dateStart,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            formattedDateStart =
                                DateFormat('dd-MMM-yy').format(selectedDate);
                            setState(() {
                              startDateController.text = formattedDateStart;
                              log("formattedDateStart==================>${formattedDateStart}");
                            });
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h),
                    child: TextFormField(
                      controller: lastDateController,
                      cursorColor: ColorUtils.primaryColor,
                      readOnly: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Please required LastDate";
                        }
                        return null;
                      },
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: themeNotifier.isDark
                              ? ColorUtils.white
                              : ColorUtils.primaryColor),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4.w),
                          filled: true,
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: formattedDateLast,
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? Colors.white60
                                  : ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        primary: ColorUtils.primaryColor,
                                        onPrimary: ColorUtils.white,
                                        onSurface: ColorUtils.primaryColor)),
                                child: child!);
                          },
                          initialDate: dateLast,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            formattedDateLast =
                                DateFormat('dd-MMM-yy').format(selectedDate);
                            setState(() {
                              lastDateController.text = formattedDateLast;
                              log("formattedDateLast==================>${formattedDateLast}");
                            });
                          }
                        });
                      },
                    ),
                  ),
                  SizeConfig.sH2,
                  AnimatedButton(
                      height: 12.w,
                      width: 60.w,
                      text: "Submit",
                      textStyle: FontTextStyle.Proxima14Regular.copyWith(
                          fontSize: 12.sp, color: ColorUtils.white),
                      borderRadius: 10.0,
                      backgroundColor: themeNotifier.isDark
                          ? ColorUtils.black
                          : ColorUtils.primaryColor,
                      selectedBackgroundColor: ColorUtils.purple,
                      transitionType: TransitionType.CENTER_ROUNDER,
                      selectedTextColor: ColorUtils.white,
                      isReverse: true,
                      onPress: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (formkey.currentState!.validate()) {}
                        data1 = true;
                        setState(() {});
                      }),
                  data1 == true
                      ? id != null
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(id!)
                                  .doc(id)
                                  .collection('user')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Current Project')
                                  .doc(Project)
                                  .collection('Done')
                                  .where('ApprovedDate',
                                      isGreaterThanOrEqualTo:
                                          formattedDateStart)
                                  .where('ApprovedDate',
                                      isLessThanOrEqualTo: formattedDateLast)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ColorUtils.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 0.5,
                                                    blurRadius: 9.0,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ]),
                                            child: Theme(
                                              data: ThemeData(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: ExpansionTile(
                                                iconColor: ColorUtils.white,
                                                collapsedIconColor:
                                                    Colors.white,
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizeConfig.sH1,
                                                    Text(
                                                      "Task Name : ${data['Task']}",
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color:
                                                              ColorUtils.white),
                                                    ),
                                                    SizeConfig.sH1,
                                                    data['Image'] == ""
                                                        ? Center(
                                                            child: Column(
                                                              children: [
                                                                Lottie.asset(
                                                                    "assets/lotties/warning.json",
                                                                    height:
                                                                        10.w),
                                                                Text(
                                                                  " No Image",
                                                                  style: FontTextStyle
                                                                          .Proxima16Medium
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.red),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Center(
                                                            child: SizedBox(
                                                              height: 14.h,
                                                              width: 35.w,
                                                              child:
                                                                  Image.network(
                                                                data['Image'],
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                    SizeConfig.sH1,
                                                  ],
                                                ),
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 290.0,
                                                    width: Get.width,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 3.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 3.w,
                                                                      right:
                                                                          3.w),
                                                              child:
                                                                  const Divider(
                                                                color:
                                                                    ColorUtils
                                                                        .greyCE,
                                                                thickness: 1,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                'Description : ${data['Description']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Assign Date : ${data['AssignDate']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Due Data : ${data['LastDate']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Starting Data : ${data['StartingDate']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Approval Request Date: ${data['CheckRequestDate']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "ApprovalDate: ${data['ApprovedDate']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Task Point : ${data['Point']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 1.h,
                                                                      left:
                                                                          5.w),
                                                              child: Text(
                                                                "Archives Point : ${data['Archives Point']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: FontTextStyle
                                                                        .Proxima16Medium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorUtils
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
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
                              })
                          : const SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Center(
                            child: Lottie.asset("assets/lotties/noData.json",
                                height: 50.w),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
