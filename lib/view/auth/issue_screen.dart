import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projecture/Download.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class issue extends StatefulWidget {
  String id;

  issue({required this.id});

  @override
  State<issue> createState() => _issueState();
}

class _issueState extends State<issue> {
  final TextEditingController NameController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var selectIndex = 0;
  File? imageFile;
  String imageUrl = '';
  final formkey = GlobalKey<FormState>();
  late String Name;
  late String Email;
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

  void pdfStatus() async {
    // if(featuresList[index]['name']==AppString.stepCounter){
    PermissionStatus pdf = await Permission.storage.request();
    if (pdfStatus == PermissionStatus.granted) {
      return;
    }
    if (pdfStatus == PermissionStatus.denied) {
      print("Permission Denied");
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Project List"),
            centerTitle: true,
            backgroundColor: ColorUtils.primaryColor,
            iconTheme: const IconThemeData(color: ColorUtils.white),
            bottom: const TabBar(
              indicatorColor: ColorUtils.primaryColor,
              tabs: [
                Tab(text: "Solve Issue"),
                Tab(text: "Upload Issue"),
              ],
            ),
          ),
          body: Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: TabBarView(
                children: [
                  ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(id)
                              .doc(id)
                              .collection('Issue')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, i) {
                                  var data = snapshot.data!.docs[i];
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.w, horizontal: 7.w),
                                      child: Container(
                                        height: 32.h,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2.h, left: 4.w),
                                              child: Text(
                                                "Uploader Name : " +
                                                    data['Name'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                    .Proxima16Medium.copyWith(
                                                  color: ColorUtils.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.h, left: 4.w),
                                              child: Text(
                                                "Email : " + data['Email'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                    .Proxima16Medium.copyWith(
                                                  color: ColorUtils.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.h, left: 4.w),
                                              child: Text(
                                                "Issue Name : " +
                                                    data['Issue Name'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                    .Proxima16Medium.copyWith(
                                                  color: ColorUtils.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.h, left: 4.w),
                                              child: Text(
                                                "Description : " +
                                                    data['Description'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: FontTextStyle
                                                    .Proxima16Medium.copyWith(
                                                  color: ColorUtils.white,
                                                ),
                                              ),
                                            ),
                                            SizeConfig.sH1,
                                            if (data['Image'] == "")
                                              Center(
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
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              GestureDetector(
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
                                                              'Are You Want To Download Image ?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FontTextStyle
                                                                      .Proxima16Medium
                                                                  .copyWith(
                                                                      color: ColorUtils
                                                                          .primaryColor)),
                                                          actions: [
                                                            InkWell(
                                                              onTap: () async {
                                                                print('click');
                                                                try {
                                                                  PermissionStatus
                                                                      pdf =
                                                                      await Permission
                                                                          .storage
                                                                          .request();
                                                                  if (pdf ==
                                                                      PermissionStatus
                                                                          .granted) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return DownloadFile(
                                                                        fileNm:
                                                                            data['Name'],
                                                                        fileLink:
                                                                            data['Image'],
                                                                      );
                                                                    }));
                                                                  }
                                                                  if (pdf ==
                                                                      PermissionStatus
                                                                          .denied) {
                                                                    // Get.back();
                                                                  }
                                                                  if (pdf ==
                                                                      PermissionStatus
                                                                          .permanentlyDenied) {
                                                                    openAppSettings();
                                                                  }

//
                                                                } catch (error) {
                                                                  print(error);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 10.w,
                                                                width: 25.w,
                                                                decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            8.0)),
                                                                    color: ColorUtils
                                                                        .primaryColor),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    "Yes",
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
                                                                        BorderRadius.all(Radius.circular(
                                                                            8.0)),
                                                                    color: ColorUtils
                                                                        .primaryColor),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    "Cancel",
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
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 12.h,
                                                    width: 30.w,
                                                    child: Image.network(
                                                      data['Image'],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.1,
                              ));
                            }
                          }),
                    ),
                  ),
                  ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.w),
                            child: TextFormField(
                              controller: NameController,
                              cursorColor: ColorUtils.primaryColor,
                              textInputAction: TextInputAction.next,
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
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
                                          child: Lottie.asset(
                                              "assets/lotties/chooseImage.json",
                                              height: 20.w),
                                          height: 30.w,
                                          width: 30.w,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
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
                                    .putFile(File(file!.path).absolute);
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
                                  color: Colors.yellow,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Center(
                                child: Text("Select Image"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.w),
                            child: TextFormField(
                              cursorColor: ColorUtils.primaryColor,
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor),
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
                              textStyle:
                                  FontTextStyle.Proxima14Regular.copyWith(
                                      fontSize: 12.sp, color: ColorUtils.white),
                              borderRadius: 10.0,
                              backgroundColor: ColorUtils.primaryColor,
                              selectedBackgroundColor: ColorUtils.purple,
                              transitionType: TransitionType.CENTER_ROUNDER,
                              selectedTextColor: ColorUtils.white,
                              isReverse: true,
                              onPress: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                                                final QuerySnapshot result =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(id)
                                                        .doc(id)
                                                        .collection('user')
                                                        .get();
                                                final List<DocumentSnapshot>
                                                    document1 = result.docs;
                                                for (var abc in document1) {
                                                  if (_auth.currentUser!.uid ==
                                                      abc.id) {
                                                    Name = abc.get('Name');
                                                    Email = abc.get('Email');
                                                  }
                                                }
                                                FirebaseFirestore.instance
                                                    .collection(id)
                                                    .doc(id)
                                                    .collection('Issue')
                                                    .doc()
                                                    .set({
                                                  'Issue Name':
                                                      NameController.text,
                                                  'Image': imageUrl,
                                                  'Description':
                                                      DescriptionController
                                                          .text,
                                                  'Name': Name,
                                                  'Email': Email,
                                                });

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(imageFile);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future chooseImageBottomSheet() {
    return Get.bottomSheet(
        //isScrollControlled: true,
        //isDismissible: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20))), StatefulBuilder(
      builder: ((context, setState) {
        return SizedBox(
          height: 34.w,
          child: Padding(
            padding: EdgeInsets.only(top: 1.h, right: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: ColorUtils.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              _getFromGallery();
                            },
                            child: CircleAvatar(
                              backgroundColor: ColorUtils.primaryColor,
                              radius: 25.0,
                              child: Icon(
                                Icons.add_photo_alternate_rounded,
                                color: ColorUtils.white,
                                size: 9.w,
                              ),
                            )),
                        SizeConfig.sH1,
                        Text(
                          "Gallery",
                          style: FontTextStyle.Proxima16Medium.copyWith(
                              color: ColorUtils.primaryColor),
                        )
                      ],
                    ),
                    SizeConfig.sW4,
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              _getFromCamera();
                            },
                            child: CircleAvatar(
                              backgroundColor: ColorUtils.primaryColor,
                              radius: 25.0,
                              child: Icon(
                                Icons.camera,
                                color: ColorUtils.white,
                                size: 10.w,
                              ),
                            )),
                        SizeConfig.sH1,
                        Text(
                          "Camera",
                          style: FontTextStyle.Proxima16Medium.copyWith(
                              color: ColorUtils.primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ));
  }
}
