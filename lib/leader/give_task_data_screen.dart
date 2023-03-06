import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecture/leader/approve_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
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
  final _auth = FirebaseAuth.instance;
  File? imageFile;
  String imageUrl = '';
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String Project = widget.Project;
    String Name = widget.Name;
    String id = widget.id;
    String Email = widget.Email;
    String uid = widget.Uid;
    final fromKey = GlobalKey<FormState>();
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorUtils.primaryColor,
            title: Text('TASK MANAGE'),
            centerTitle: true,
            bottom: TabBar(indicatorColor: ColorUtils.primaryColor, tabs: [
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
                        SizeConfig.sH6,
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w),
                          child: TextFormField(
                            controller: TaskNameController,
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
                                        color: ColorUtils.primaryColor),
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
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/profile.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: 30.w,
                                        width: 30.w,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              /*Step 1:Pick image*/
                              //Install image_picker
                              //Import the corresponding library

                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              print('${file?.path}');
                              setState(() {
                                imageFile = File(file!.path);
                              });

                              if (file == null) return;
                              //Import dart:core

                              /*Step 2: Upload to Firebase storage*/
                              //Install firebase_storage
                              //Import the library

                              //Get a reference to storage root
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
                            icon: Icon(Icons.camera_alt)),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, right: 5.w, top: 2.w),
                          child: TextFormField(
                            controller: DescriptionController,
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
                                        color: ColorUtils.primaryColor),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH2,
                        AnimatedButton(
                            height: 12.w,
                            width: 60.w,
                            text: "UPLOAD",
                            textStyle: FontTextStyle.Proxima14Regular.copyWith(
                                fontSize: 12.sp, color: ColorUtils.white),
                            borderRadius: 10.0,
                            backgroundColor: ColorUtils.primaryColor,
                            selectedBackgroundColor: ColorUtils.purple,
                            transitionType: TransitionType.CENTER_ROUNDER,
                            selectedTextColor: ColorUtils.white,
                            isReverse: true,
                            onPress: () {
                              FocusScope.of(context).requestFocus();

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Upload',
                                        style: FontTextStyle.Proxima16Medium
                                            .copyWith(
                                                color: ColorUtils.primaryColor,
                                                fontWeight:
                                                    FontWeightClass.extraB,
                                                fontSize: 13.sp),
                                      ),
                                      content: Text(
                                          'are you sure want to Upload?',
                                          style: FontTextStyle.Proxima16Medium
                                              .copyWith(
                                                  color:
                                                      ColorUtils.primaryColor)),
                                      actions: [
                                        IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: ColorUtils.primaryColor,
                                            )),
                                        IconButton(
                                            onPressed: () async {
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
                                                'task': TaskNameController.text,
                                                'Image': imageUrl,
                                                'Name': Name,
                                                'Email': Email
                                              });
                                              FirebaseFirestore.instance
                                                  .collection(id)
                                                  .doc(id)
                                                  .collection('user')
                                                  .doc(uid)
                                                  .collection('Current Project')
                                                  .doc(Project)
                                                  .collection('Task')
                                                  .doc()
                                                  .set({
                                                'Task': TaskNameController.text,
                                                'Image': imageUrl,
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
                                                      seconds: 3),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.check,
                                              color: ColorUtils.primaryColor,
                                            ))
                                      ],
                                    );
                                  });
                            }),
                      ],
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
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
                                  height: 23.h,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.purple,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              ColorUtils.black.withOpacity(0.2),
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
                                          style: FontTextStyle.Proxima16Medium
                                              .copyWith(
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
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color:
                                                            ColorUtils.white),
                                              ),
                                            )
                                          : Image.network(
                                              data['Image'],
                                              height: 15.h,
                                              width: 25.w,
                                              fit: BoxFit.cover,
                                            ),
                                      Spacer(),
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
                                                                    fontSize:
                                                                        13.sp),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'are you sure want to start Task?',
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
                                                            final QuerySnapshot
                                                                result =
                                                                await FirebaseFirestore
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
                                                                result.docs;
                                                            for (var abc
                                                                in document1) {
                                                              Name = abc
                                                                  .get('Name');
                                                              Email = abc
                                                                  .get('Email');
                                                            }
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(id)
                                                                .doc(id)
                                                                .collection(
                                                                    Project)
                                                                .doc(Project)
                                                                .collection(
                                                                    'Done')
                                                                .doc()
                                                                .set({
                                                              'task':
                                                                  data['Task'],
                                                              'Image':
                                                                  data["Image"],
                                                              'Name': Name,
                                                              'Email': Email,
                                                            }).whenComplete(() => FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        id)
                                                                    .doc(id)
                                                                    .collection(
                                                                        Project)
                                                                    .doc(
                                                                        Project)
                                                                    .collection(
                                                                        'Task')
                                                                    .where(
                                                                      'Task',
                                                                      isEqualTo:
                                                                          data[
                                                                              'Task'],
                                                                    ));
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(id)
                                                                .doc(id)
                                                                .collection(
                                                                    'user')
                                                                .doc(uid)
                                                                .collection(
                                                                    'Current Project')
                                                                .doc(Project)
                                                                .collection(
                                                                    'Done')
                                                                .doc()
                                                                .set({
                                                              'Task':
                                                                  data['Task'],
                                                              'Image':
                                                                  data['Image'],
                                                            }).whenComplete(
                                                                    () => {
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
                                                                borderRadius:
                                                                    10.0,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            4.w,
                                                                        right:
                                                                            4.w,
                                                                        bottom:
                                                                            4.w),
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
                                                                        seconds:
                                                                            3),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 10.w,
                                                            width: 25.w,
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
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
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
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
                                              padding:
                                                  EdgeInsets.only(right: 2.w),
                                              child: Text(
                                                "Approved",
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: ColorUtils.white,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeightClass
                                                                .semiB),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
