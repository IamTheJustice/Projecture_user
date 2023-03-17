import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../utils/font_style_utils.dart';

class TaskData extends StatefulWidget {
  String id;
  String Name;
  String Project;
  String Email;
  String Uid;
  TaskData(
      {required this.id,
      required this.Name,
      required this.Project,
      required this.Email,
      required this.Uid});

  @override
  State<TaskData> createState() => _TaskDataState();
}

class _TaskDataState extends State<TaskData> {
  final TextEditingController TaskNameController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController pointController = TextEditingController();
  final TextEditingController addPointController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  DateTime date = DateTime.now();
  late var formattedDate = "Date of Last";
  File? imageFile;
  String imageUrl = '';
  final formkey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    String Project = widget.Project;
    String Name = widget.Name;
    String id = widget.id;
    String Email = widget.Email;
    String uid = widget.Uid;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: themeNotifier.isDark
                  ? ColorUtils.black
                  : ColorUtils.primaryColor,
              title: Text('TASK MANAGE'),
              centerTitle: true,
              bottom: TabBar(
                  indicatorColor: themeNotifier.isDark
                      ? ColorUtils.white
                      : ColorUtils.primaryColor,
                  tabs: [
                    Tab(
                      text: 'Give Task',
                    ),
                    Tab(
                      text: 'Approve Task',
                    ),
                  ]),
            ),
            body: Form(
              key: formkey,
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: [
                      Column(
                        children: [
                          SizeConfig.sH4,
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.w),
                            child: TextFormField(
                              controller: TaskNameController,
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
                              cursorColor: ColorUtils.primaryColor,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please name required";
                                } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                                    .hasMatch(v)) {
                                  return "please valid name ";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(4.w),
                                  filled: true,
                                  fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                  hintText: "Name",
                                  hintStyle:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: themeNotifier.isDark
                                              ? Colors.white60
                                              : ColorUtils.primaryColor),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            child: DottedBorder(
                              dashPattern: const [6, 3, 2, 3],
                              color: ColorUtils.greyBB,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.square,
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              child: Center(
                                child: Container(
                                  child: imageFile != null
                                      ? Container(
                                          width: 30.w,
                                          height: 30.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.white,
                                              image: DecorationImage(
                                                image: FileImage(
                                                    imageFile!.absolute),
                                                fit: BoxFit.cover,
                                              )),
                                        )
                                      : Container(
                                          height: 30.w,
                                          width: 30.w,
                                          child: Lottie.asset(
                                              "assets/lotties/chooseImage.json",
                                              height: 20.w),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              print('${file?.path}');
                              setState(() {
                                imageFile = File(file!.path);
                              });

                              if (file == null) return;
                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('images');

                              //Create a reference for the image to be stored
                              Reference referenceImageToUpload =
                                  referenceDirImages.child(file.name);

                              //Handle errors/success
                              try {
                                //Store the file
                                await referenceImageToUpload
                                    .putFile(File(file.path).absolute);
                                //Success: get the download URL
                                imageUrl = await referenceImageToUpload
                                    .getDownloadURL();
                              } catch (error) {
                                //Some error occurred
                              }
                            },
                            child: Container(
                              height: 5.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                  color: themeNotifier.isDark
                                      ? ColorUtils.black
                                      : ColorUtils.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Center(
                                child: Text(
                                  "Select Image",
                                  style: FontTextStyle.Proxima16Medium.copyWith(
                                      color: ColorUtils.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.w),
                            child: TextFormField(
                              controller: DescriptionController,
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
                              cursorColor: ColorUtils.primaryColor,
                              textInputAction: TextInputAction.next,
                              maxLines: 3,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please description required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(4.w),
                                  filled: true,
                                  fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                  hintText: "Description",
                                  hintStyle:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: themeNotifier.isDark
                                              ? Colors.white60
                                              : ColorUtils.primaryColor),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 6.w, right: 6.w, top: 2.w),
                            child: TextFormField(
                              controller: dateController,
                              cursorColor: ColorUtils.primaryColor,
                              readOnly: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "please required date";
                                }
                                return null;
                              },
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(4.w),
                                  filled: true,
                                  fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                  hintText: "${formattedDate}",
                                  hintStyle:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: themeNotifier.isDark
                                              ? Colors.white60
                                              : ColorUtils.primaryColor),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)))),
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                                primary:
                                                    ColorUtils.primaryColor,
                                                onPrimary: ColorUtils.white,
                                                onSurface:
                                                    ColorUtils.primaryColor)),
                                        child: child!);
                                  },
                                  initialDate: date,
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2030),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    formattedDate = DateFormat('dd-MMM-yy')
                                        .format(selectedDate);
                                    setState(() {
                                      dateController.text = formattedDate;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 2.w, left: 5.w, right: 5.w),
                            child: TextFormField(
                              controller: addPointController,
                              cursorColor: ColorUtils.primaryColor,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "please task point required";
                                } else if (!RegExp(r'(^(?:[+0]9)?[0-9]$)')
                                    .hasMatch(v)) {
                                  return "please enter digits ";
                                }
                                return null;
                              },
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(4.w),
                                  filled: true,
                                  fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                  hintText: "Task point",
                                  hintStyle:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: themeNotifier.isDark
                                              ? Colors.white60
                                              : ColorUtils.primaryColor),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)))),
                            ),
                          ),
                          SizeConfig.sH4,
                          AnimatedButton(
                              height: 12.w,
                              width: 60.w,
                              text: "UPLOAD",
                              textStyle:
                                  FontTextStyle.Proxima14Regular.copyWith(
                                      fontSize: 12.sp, color: ColorUtils.white),
                              borderRadius: 10.0,
                              backgroundColor: themeNotifier.isDark
                                  ? ColorUtils.black
                                  : ColorUtils.primaryColor,
                              selectedBackgroundColor: ColorUtils.purple,
                              transitionType: TransitionType.CENTER_ROUNDER,
                              selectedTextColor: ColorUtils.white,
                              isReverse: true,
                              onPress: () {
                                FocusScope.of(context).requestFocus();

                                if (formkey.currentState!.validate()) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Text(
                                                'Upload',
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
                                              Lottie.asset(
                                                  "assets/lotties/upload.json",
                                                  height: 25.w)
                                            ],
                                          ),
                                          content: Text(
                                              'are you sure want to Upload?',
                                              style:
                                                  FontTextStyle.Proxima16Medium
                                                      .copyWith(
                                                          color: ColorUtils
                                                              .primaryColor)),
                                          actions: [
                                            InkWell(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                FirebaseFirestore.instance
                                                    .collection(id)
                                                    .doc(id)
                                                    .collection(Project)
                                                    .doc(Project)
                                                    .collection('task')
                                                    .doc()
                                                    .set({
                                                  'task':
                                                      TaskNameController.text,
                                                  'Image': imageUrl,
                                                  'Name': Name,
                                                  'Email': Email,
                                                  'LastDate':
                                                      dateController.text,
                                                  'AssignDate': DateFormat(
                                                          'dd-MMM-yy')
                                                      .format(DateTime.now()),
                                                  'Point':
                                                      addPointController.text,
                                                });
                                                FirebaseFirestore.instance
                                                    .collection(id)
                                                    .doc(id)
                                                    .collection('user')
                                                    .doc(uid)
                                                    .collection(
                                                        'Current Project')
                                                    .doc(Project)
                                                    .collection('Task')
                                                    .doc()
                                                    .set({
                                                  'Task':
                                                      TaskNameController.text,
                                                  'Image': imageUrl,
                                                  'LastDate':
                                                      dateController.text,
                                                  'AssignDate': DateFormat(
                                                          'dd-MMM-yy')
                                                      .format(DateTime.now()),
                                                  'Point':
                                                      addPointController.text,
                                                });
                                                Get.back();

                                                Get.showSnackbar(
                                                  GetSnackBar(
                                                    message:
                                                        "Upload Data Succesfully",
                                                    borderRadius: 10.0,
                                                    margin: EdgeInsets.only(
                                                        left: 4.w,
                                                        right: 4.w,
                                                        bottom: 4.w),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: ColorUtils
                                                        .primaryColor
                                                        .withOpacity(0.9),
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 10.w,
                                                width: 25.w,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    color: ColorUtils
                                                        .primaryColor),
                                                child: const Center(
                                                  child: Text(
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
                                              child: Container(
                                                height: 10.w,
                                                width: 25.w,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    color: ColorUtils
                                                        .primaryColor),
                                                child: const Center(
                                                  child: Text(
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
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                  ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(id)
                              .doc(id)
                              .collection('user')
                              .doc(uid)
                              .collection('Current Project')
                              .doc(Project)
                              .collection('InChecking')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int i) {
                                  var data = snapshot.data!.docs[i];
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.w, horizontal: 7.w),
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                            color: ColorUtils.purple,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorUtils.black
                                                    .withOpacity(0.2),
                                                blurRadius: 5.0,
                                                spreadRadius: 0.9,
                                              )
                                            ]),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                data['Task'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
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
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Image.network(
                                                    data['Image'],
                                                    height: 15.h,
                                                    width: 25.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                "Task Assign Date " +
                                                    data['AssignDate'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                "Due Date " + data['LastDate'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                "Task Starting Date " +
                                                    data['StartingDate'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                "Checking Request Date " +
                                                    data['CheckRequestDate'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                            SizeConfig.sH1,
                                            Spacer(),
                                            Row(
                                              // mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertBox(
                                                              id: id,
                                                              Uid: uid,
                                                              Name: Name,
                                                              Project: Project,
                                                              Email: Email,
                                                              task:
                                                                  data['Task'],
                                                              Assigndate: data[
                                                                  'AssignDate'],
                                                              Lastdate: data[
                                                                  'LastDate'],
                                                              Image:
                                                                  data['Image'],
                                                              Checkrequestdate:
                                                                  data[
                                                                      'CheckRequestDate'],
                                                              Startingdate: data[
                                                                  'StartingDate']);
                                                        });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 2.w,
                                                        bottom: 1.h),
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 29.w,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              ColorUtils.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                      child: Center(
                                                        child: Text(
                                                          "Approved",
                                                          style: FontTextStyle
                                                                  .Proxima16Medium
                                                              .copyWith(
                                                                  color:
                                                                      ColorUtils
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
                                            SizeConfig.sH1,
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.1,
                                color: ColorUtils.primaryColor,
                              ));
                            }
                          }),
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

class AlertBox extends StatefulWidget {
  String id;
  String Name;
  String Project;
  String Email;
  String Uid;
  String task;
  String Startingdate;
  String Checkrequestdate;
  String Image;
  String Lastdate;
  String Assigndate;

  AlertBox(
      {required this.id,
      required this.Name,
      required this.Project,
      required this.Uid,
      required this.Email,
      required this.task,
      required this.Startingdate,
      required this.Image,
      required this.Assigndate,
      required this.Checkrequestdate,
      required this.Lastdate});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  final _auth = FirebaseAuth.instance;

  final formkey = GlobalKey<FormState>();
  final TextEditingController pointController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String Project = widget.Project;
    String Name = widget.Name;
    String id = widget.id;
    String Email = widget.Email;
    String uid = widget.Uid;
    String image = widget.Image;
    String Startingdate = widget.Startingdate;
    String Checkrequestdate = widget.Checkrequestdate;
    String Lastdate = widget.Lastdate;
    String Assigndate = widget.Assigndate;
    String task = widget.task;

    return AlertDialog(
      actions: [
        Form(
          key: formkey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/sessionEnd.gif",
                scale: 1.w,
              ),
              SizeConfig.sH2,
              Text(
                'Start Task',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor,
                    fontWeight: FontWeightClass.extraB,
                    fontSize: 13.sp),
              ),
              SizeConfig.sH1,
              Text('are you sure want to start Task?',
                  textAlign: TextAlign.center,
                  style: FontTextStyle.Proxima16Medium.copyWith(
                      color: ColorUtils.primaryColor)),
              SizeConfig.sH2,
              Padding(
                padding: EdgeInsets.only(top: 2.w),
                child: TextFormField(
                  controller: pointController,
                  cursorColor: ColorUtils.primaryColor,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    // add your custom validation here.
                    if (v!.isEmpty) {
                      return "please task point required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4.w),
                      filled: true,
                      fillColor: ColorUtils.greyE7.withOpacity(0.5),
                      hintText: "Task point",
                      hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                          color: ColorUtils.grey),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              SizeConfig.sH3,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus();
                      if (formkey.currentState!.validate()) {
                        final QuerySnapshot result = await FirebaseFirestore
                            .instance
                            .collection(id)
                            .doc(id)
                            .collection('user')
                            .get();
                        final List<DocumentSnapshot> document1 = result.docs;
                        for (var abc in document1) {
                          if (_auth.currentUser!.uid == abc.get('Uid')) {
                            Name = abc.get('Name');
                            Email = abc.get('Email');
                          }
                        }
                        FirebaseFirestore.instance
                            .collection(id)
                            .doc(id)
                            .collection(Project)
                            .doc(Project)
                            .collection('Done')
                            .doc()
                            .set({
                          'task': task,
                          'Image': image,
                          'Name': Name,
                          'Email': Email,
                          'AssignDate': Assigndate,
                          'LastDate': Lastdate,
                          'CheckRequestDate': Checkrequestdate,
                          'StartingDate': Startingdate,
                          'ApprovedDate':
                              DateFormat('dd-MMM-yy').format(DateTime.now()),
                        }).whenComplete(() => FirebaseFirestore.instance
                                .collection(id)
                                .doc(id)
                                .collection(Project)
                                .doc(Project)
                                .collection('Task')
                                .where(
                                  'Task',
                                  isEqualTo: task,
                                ));
                        try {
                          // Get a reference to the 'task' subcollection
                          CollectionReference taskCollection = FirebaseFirestore
                              .instance
                              .collection(id)
                              .doc(id)
                              .collection(Project)
                              .doc(Project)
                              .collection('InChecking');

                          // Query for the document with field name 'task' and value 'mk'
                          QuerySnapshot querySnapshot = await taskCollection
                              .where('task', isEqualTo: task)
                              .get();

                          // Delete the document(s) found by the query
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.delete();
                          });
                        } catch (e) {
                          print('Error deleting document: $e');
                        }
                        FirebaseFirestore.instance
                            .collection(id)
                            .doc(id)
                            .collection('user')
                            .doc(uid)
                            .collection('Current Project')
                            .doc(Project)
                            .collection('Done')
                            .doc()
                            .set({
                          'Task': task,
                          'Image': image,
                          'AssignDate': Assigndate,
                          'LastDate': Lastdate,
                          'CheckRequestDate': Checkrequestdate,
                          'StartingDate': Startingdate,
                          'ApprovedDate':
                              DateFormat('dd-MMM-yy').format(DateTime.now()),
                        });
                        try {
                          // Get a reference to the 'task' subcollection
                          CollectionReference taskCollectio = FirebaseFirestore
                              .instance
                              .collection(id)
                              .doc(id)
                              .collection('user')
                              .doc(uid)
                              .collection('Current Project')
                              .doc(Project)
                              .collection('InChecking');

                          // Query for the document with field name 'task' and value 'mk'
                          QuerySnapshot querySnapshot = await taskCollectio
                              .where('Task', isEqualTo: task)
                              .get();

                          // Delete the document(s) found by the query
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.delete();
                          });
                        } catch (e) {
                          print('Error deleting document: $e');
                          // snapshot.data!.docs[i].reference.delete()
                        }
                        Get.back();
                        Get.showSnackbar(
                          GetSnackBar(
                            message: "Start Task Successfully",
                            borderRadius: 10.0,
                            margin: EdgeInsets.only(
                                left: 4.w, right: 4.w, bottom: 4.w),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                ColorUtils.primaryColor.withOpacity(0.9),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 10.w,
                      width: 25.w,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: ColorUtils.primaryColor),
                      child: const Center(
                        child: Text(
                          "Done",
                          style: TextStyle(color: ColorUtils.white),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: ColorUtils.primaryColor),
                      child: const Center(
                        child: Text(
                          "Cancle",
                          style: TextStyle(color: ColorUtils.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
