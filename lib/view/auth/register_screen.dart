import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/Login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  String id;
  RegisterScreen({super.key, required this.id});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  final firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime date = DateTime.now();
  late var formattedDate = "Date of Birth";
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: ColorUtils.white,
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset("assets/images/background.png"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/logo.png',
                              color: ColorUtils.white,
                              height: 9.w,
                              width: 12.w,
                            ),
                            Text(
                              "Projecture",
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeightClass.extraB),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 45.w),
                        child: Container(
                          height: 20.w,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              color: ColorUtils.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(90.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign Up",
                                style: FontTextStyle.Proxima16Medium.copyWith(
                                    fontSize: 18.sp,
                                    color: ColorUtils.primaryColor,
                                    fontWeight: FontWeightClass.semiB),
                              ),
                              Text(
                                "create your account",
                                style: FontTextStyle.Proxima14Regular.copyWith(
                                    color: ColorUtils.primaryColor,
                                    fontWeight: FontWeightClass.semiB),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
                      controller: fullnameController,
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
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: "Full Name",
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
                      controller: cityController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "please city required";
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                          return "please valid city name ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4.w),
                          filled: true,
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: "City",
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      controller: dateController,
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
                          hintText: formattedDate,
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
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
                          initialDate: date,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            formattedDate =
                                DateFormat('d-MMM-yy').format(selectedDate);
                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
                      controller: emailController,
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
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: PhoneController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "please mobile number required";
                        } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                            .hasMatch(v)) {
                          return "please enter 10 digits ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4.w),
                          filled: true,
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: "Phone Number",
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      textInputAction: TextInputAction.next,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
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
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.w),
                    child: TextFormField(
                      cursorColor: ColorUtils.primaryColor,
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.primaryColor),
                      controller: confirmPasswordController,
                      validator: (v) {
                        if (v!.isEmpty) return 'Empty';
                        if (v != passwordController.text) return 'Not Match';
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(4.w),
                          filled: true,
                          fillColor: ColorUtils.greyE7.withOpacity(0.5),
                          hintText: "Confirm Password",
                          hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  SizeConfig.sH3,
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (formkey.currentState!.validate()) {
                        final newuser = await _auth
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection(id)
                              .doc(id)
                              .collection('user')
                              .doc(_auth.currentUser!.uid)
                              .set({
                            'Name': fullnameController.text,
                            'City': cityController.text,
                            'DOB': dateController.text,
                            'Email': emailController.text,
                            'Phone': PhoneController.text,
                            'Password': passwordController.text,
                            'Uid': _auth.currentUser!.uid,
                            'ProfileImage': "",
                          });
                        });

                        Get.showSnackbar(
                          GetSnackBar(
                            message: "Register Succesfully",
                            borderRadius: 10.0,
                            margin: EdgeInsets.only(
                                left: 4.w, right: 4.w, bottom: 4.w),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: ColorUtils.primaryColor,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            Get.to(() => LoginScreen(id: id));
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 6.5.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                ColorUtils.primaryColor,
                                ColorUtils.primaryColor.withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(
                                  5,
                                  5,
                                ),
                                blurRadius: 10)
                          ]),
                      child: Center(
                          child: Text(
                        "Sign Up",
                        style: FontTextStyle.Proxima16Medium.copyWith(
                            color: ColorUtils.white),
                      )),
                    ),
                  ),
                  SizeConfig.sH1,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you have an account ?",
                        style: FontTextStyle.Proxima10Regular.copyWith(
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeightClass.semiB),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => LoginScreen(id: id));
                          },
                          child: Text(
                            "Log In",
                            style: FontTextStyle.Proxima14Regular.copyWith(
                                color: ColorUtils.primaryColor,
                                fontWeight: FontWeightClass.semiB),
                          )),
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
}
