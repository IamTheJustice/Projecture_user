import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorUtils.white,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset("assets/images/background.png"),
              Padding(
                padding: EdgeInsets.only(top: 45.w),
                child: Container(
                  height: 20.w,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(90.0))),
                  child: Center(
                    child: Text(
                      "Forgot Password",
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          fontSize: 18.sp,
                          color: ColorUtils.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 11.w),
            child: TextFormField(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, top: 2.w),
            child: Text(
              "we will send reset password link to entered email address.",
              style: FontTextStyle.Proxima10Regular.copyWith(
                  color: ColorUtils.grey79, fontWeight: FontWeightClass.semiB),
            ),
          ),
          SizeConfig.sH3,
          Container(
            height: 12.w,
            width: 60.w,
            decoration: const BoxDecoration(
                color: ColorUtils.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Center(
              child: Text(
                "Send Email",
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.white, fontWeight: FontWeightClass.semiB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
