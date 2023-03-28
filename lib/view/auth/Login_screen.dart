import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/leader/leader_drawerBottomNavbar_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/forgot_password_screen.dart';
import 'package:projecture/view/auth/Drawer_BottomNavbar_screen.dart';

import 'package:projecture/view/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  String id;

  LoginScreen({super.key, required this.id});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isCheckPassword = true;

  final formkey = GlobalKey<FormState>();
  final firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late String abcd = "aa";
    late String leader = "aa";
    String id = widget.id;
    print('=============================>>>>>$id');
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorUtils.white,
        body: Form(
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
                            "Welcome",
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                fontSize: 18.sp,
                                color: ColorUtils.primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          SizeConfig.sH05,
                          Text(
                            "Login to your existent account",
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
                padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 11.w),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme:
                        Theme.of(context).inputDecorationTheme.copyWith(
                      iconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return ColorUtils.primaryColor;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Colors.red;
                        }
                        return Colors.grey;
                      }),
                    ),
                  ),
                  child: TextFormField(
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: ColorUtils.primaryColor),
                    cursorColor: ColorUtils.primaryColor,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please Email required";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(v)) {
                        return "Please enter valid email ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(4.w),
                        filled: true,
                        fillColor: ColorUtils.greyE7.withOpacity(0.5),
                        hintText: "Email/Username",
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          size: 5.w,
                        ),
                        hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                            color: ColorUtils.primaryColor),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 4.w),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme:
                        Theme.of(context).inputDecorationTheme.copyWith(
                      iconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return ColorUtils.primaryColor;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Colors.red;
                        }
                        return Colors.grey;
                      }),
                    ),
                  ),
                  child: TextFormField(
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: ColorUtils.primaryColor),
                    cursorColor: ColorUtils.primaryColor,
                    controller: passwordController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    obscureText: isCheckPassword,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(4.w),
                        filled: true,
                        fillColor: ColorUtils.greyE7.withOpacity(0.5),
                        hintText: "Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            isCheckPassword = !isCheckPassword;
                            setState(() {});
                          },
                          child: Icon(isCheckPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintStyle: FontTextStyle.Proxima14Regular.copyWith(
                            color: ColorUtils.primaryColor),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 6.w, top: 2.h),
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "Forgot Password?",
                        style: FontTextStyle.Proxima10Regular.copyWith(
                            color: ColorUtils.grey79,
                            fontWeight: FontWeightClass.semiB),
                      ),
                    )),
              ),
              SizeConfig.sH3,
              GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formkey.currentState!.validate()) {
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);

                      if (newUser != null) {
                        final QuerySnapshot result = await FirebaseFirestore
                            .instance
                            .collection(id)
                            .doc(id)
                            .collection('user')
                            .get();
                        final List<DocumentSnapshot> documents = result.docs;

                        for (var doc in documents) {
                          print("id is  ${doc.id}");
                          if (_auth.currentUser!.uid == doc.id) {
                            abcd = doc.id;
                            break;
                          }
                        }

                        if (_auth.currentUser!.uid == abcd) {
                          final QuerySnapshot result = await FirebaseFirestore
                              .instance
                              .collection(id)
                              .doc(id)
                              .collection('Leader')
                              .get();
                          final List<DocumentSnapshot> document1 = result.docs;
                          for (var abc in document1) {
                            print(abc.id);
                            if (_auth.currentUser!.uid == abc.id) {
                              leader = abc.id;
                              break;
                            }
                          }
                          final pref = await SharedPreferences.getInstance();
                          pref.setString("userId", _auth.currentUser!.uid);
                          pref.setString("companyId", id);
                          pref.setString("leaderId", leader);

                          if (_auth.currentUser!.uid == leader) {
                            print("Leader are $leader");
                            Get.to(() => const LeaderDrawerBottomNavbar());
                          } else {
                            Get.showSnackbar(
                              GetSnackBar(
                                message: "Login Successfully",
                                borderRadius: 10.0,
                                margin: EdgeInsets.only(
                                    left: 4.w, right: 4.w, bottom: 4.w),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: ColorUtils.primaryColor,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              Get.to(() => const DrawerBottomNavbar());
                            });
                          }
                        } else {
                          Get.showSnackbar(
                            GetSnackBar(
                              message: "select your company",
                              borderRadius: 10.0,
                              margin: EdgeInsets.only(
                                  left: 4.w, right: 4.w, bottom: 4.w),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: ColorUtils.primaryColor,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } else {}
                    } catch (e) {
                      final snackBar = SnackBar(content: Text(e.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print(e);
                    }
                    print(_auth.currentUser!.uid);
                  }
                },
                child: Container(
                  height: 6.5.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        ColorUtils.primaryColor,
                        ColorUtils.primaryColor.withOpacity(0.5),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                    "Sign In",
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: ColorUtils.white),
                  )),
                ),
              ),
              SizeConfig.sH2,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account ?",
                    style: FontTextStyle.Proxima10Regular.copyWith(
                        color: ColorUtils.primaryColor,
                        fontWeight: FontWeightClass.semiB),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => RegisterScreen(id: id));
                      },
                      child: Text(
                        "Sign Up",
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
    );
  }
}
