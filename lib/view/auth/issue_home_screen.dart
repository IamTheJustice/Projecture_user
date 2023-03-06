import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:sizer/sizer.dart';

class IssueHomeScreen extends StatefulWidget {
  const IssueHomeScreen({Key? key}) : super(key: key);

  @override
  State<IssueHomeScreen> createState() => _IssueHomeScreenState();
}

class _IssueHomeScreenState extends State<IssueHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue"),
        centerTitle: true,
        backgroundColor: ColorUtils.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        child: Container(
          height: 40.w,
          width: Get.width,
          decoration: BoxDecoration(
              border: Border.all(color: ColorUtils.primaryColor),
              color: ColorUtils.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.w, right: 10.w, left: 3.w),
                child: Text(
                  "Firebase Authentication in flutter",
                  style: FontTextStyle.Proxima16Medium.copyWith(
                      fontSize: 14.sp, color: ColorUtils.primaryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.w, top: 5.w),
                child: Row(
                  children: [
                    Text(
                      "Published  by :",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                          color: ColorUtils.primaryColor),
                    ),
                    const Text("  Anurag Jagani")
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.w, top: 2.w, right: 4.w),
                child: Row(
                  children: [
                    Text(
                      "Posted on :",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                          color: ColorUtils.primaryColor),
                    ),
                    const Text("  20/12/2022"),
                    const Spacer(),
                    SvgPicture.asset("assets/icons/testing.svg")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
