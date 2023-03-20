import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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

  File? imageFile;
  final formkey = GlobalKey<FormState>();
  bool isCheckPassword = true;
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: themeNotifier.isDark
              ? Colors.black.withOpacity(0.8)
              : Colors.white,
          body: Form(
            key: formkey,
            child: ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.w, horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            child: imageFile != null
                                ? Container(
                                    width: 31.w,
                                    height: 31.w,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color(0xFFFF7171),
                                              Color(0xFFA156A0),
                                              Color(0xFF7564A0),
                                            ])),
                                    child: Container(
                                      width: 29.w,
                                      height: 29.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: FileImage(imageFile!),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorUtils.blueF0,
                                      border: Border.all(
                                          color: ColorUtils.purple,
                                          width: 4.1,
                                          style: BorderStyle.solid),
                                    ),
                                    height: 30.w,
                                    width: 30.w,
                                    child: Center(
                                      child: Lottie.asset(
                                        "assets/lotties/profile.json",
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizeConfig.sH1,
                        Center(
                            child: InkWell(
                          onTap: () {
                            chooseImageBottomSheet();
                          },
                          child: Text(
                            "Upload picture",
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                decoration: TextDecoration.underline,
                                color: themeNotifier.isDark
                                    ? ColorUtils.white
                                    : ColorUtils.primaryColor),
                          ),
                        )),
                        SizeConfig.sH2,
                        Text(
                          "Full Name",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextFormField(
                            cursorColor: ColorUtils.primaryColor,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "please name required";
                              } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                                return "please valid name ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4.w),
                                filled: true,
                                hintText: "Full Name",
                                hintStyle:
                                    FontTextStyle.Proxima14Regular.copyWith(
                                        color: themeNotifier.isDark
                                            ? Colors.white60
                                            : ColorUtils.grey),
                                fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH1,
                        Text(
                          "Email",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextFormField(
                            cursorColor: ColorUtils.primaryColor,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "please email required";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(v)) {
                                return "please enter valid email ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4.w),
                                filled: true,
                                fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                hintText: "Email/Username",
                                hintStyle:
                                    FontTextStyle.Proxima14Regular.copyWith(
                                        color: themeNotifier.isDark
                                            ? Colors.white60
                                            : ColorUtils.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH1,
                        Text(
                          "City Name",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextFormField(
                            cursorColor: ColorUtils.primaryColor,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "please city required";
                              } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                                return "please valid cityname ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4.w),
                                filled: true,
                                fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                hintText: "City",
                                hintStyle:
                                    FontTextStyle.Proxima14Regular.copyWith(
                                        color: themeNotifier.isDark
                                            ? Colors.white60
                                            : ColorUtils.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH1,
                        Text(
                          "Company Name",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextFormField(
                            cursorColor: ColorUtils.primaryColor,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "please city required";
                              } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                                return "please valid companyname ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(4.w),
                                filled: true,
                                fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                hintText: "Company Name",
                                hintStyle:
                                    FontTextStyle.Proxima14Regular.copyWith(
                                        color: themeNotifier.isDark
                                            ? Colors.white60
                                            : ColorUtils.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH1,
                        Text(
                          "Mobile Number",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextFormField(
                            cursorColor: ColorUtils.primaryColor,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              // add your custom validation here.
                              if (v!.isEmpty) {
                                return "please mobile number required";
                              } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                  .hasMatch(v)) {
                                return "please enter 10 digits ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                counterStyle: TextStyle(
                                    color: themeNotifier.isDark
                                        ? Colors.white60
                                        : ColorUtils.grey),
                                contentPadding: EdgeInsets.all(4.w),
                                filled: true,
                                fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                hintText: "Mobile number",
                                hintStyle:
                                    FontTextStyle.Proxima14Regular.copyWith(
                                        color: themeNotifier.isDark
                                            ? Colors.white60
                                            : ColorUtils.grey),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ),
                        SizeConfig.sH1,
                        Text(
                          "Password",
                          style: FontTextStyle.Proxima14Regular.copyWith(
                              color: themeNotifier.isDark
                                  ? ColorUtils.white
                                  : ColorUtils.primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: Theme.of(context)
                                  .inputDecorationTheme
                                  .copyWith(
                                iconColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return themeNotifier.isDark
                                        ? ColorUtils.white
                                        : ColorUtils.primaryColor;
                                  }
                                  if (states.contains(MaterialState.error)) {
                                    return Colors.red;
                                  }
                                  return themeNotifier.isDark
                                      ? Colors.white60
                                      : Colors.grey;
                                }),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: ColorUtils.primaryColor,
                              obscureText: isCheckPassword,
                              controller: passwordController,
                              validator: (v) {
                                // add your custom validation here.
                                if (v!.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (v.length <= 8) {
                                  return 'Password must be atleast 8 characters long';
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(4.w),
                                  filled: true,
                                  fillColor: ColorUtils.greyE7.withOpacity(0.5),
                                  hintText: "Password",
                                  hintStyle:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: themeNotifier.isDark
                                              ? Colors.white60
                                              : ColorUtils.grey),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      isCheckPassword = !isCheckPassword;
                                      setState(() {});
                                    },
                                    child: Icon(isCheckPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)))),
                            ),
                          ),
                        ),
                        SizeConfig.sH3,
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus();
                            if (formkey.currentState!.validate()) {
                              Get.showSnackbar(
                                GetSnackBar(
                                  message: "Profile Updated Succesfully",
                                  borderRadius: 10.0,
                                  margin: EdgeInsets.only(
                                      left: 4.w, right: 4.w, bottom: 4.w),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: ColorUtils.primaryColor,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              height: 12.w,
                              width: 60.w,
                              decoration: BoxDecoration(
                                  color: themeNotifier.isDark
                                      ? Colors.black
                                      : ColorUtils.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Center(
                                child: Text(
                                  "DONE",
                                  style: FontTextStyle.Proxima16Medium.copyWith(
                                      color: themeNotifier.isDark
                                          ? ColorUtils.white
                                          : ColorUtils.white,
                                      fontWeight: FontWeightClass.semiB),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizeConfig.sH2,
                      ],
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

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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
