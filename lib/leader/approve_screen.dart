import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:sizer/sizer.dart';

class ApproveShow extends StatefulWidget {
  const ApproveShow({Key? key}) : super(key: key);

  @override
  State<ApproveShow> createState() => _ApproveShowState();
}

class _ApproveShowState extends State<ApproveShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.only(top: 1.h),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 3.w),
              child: Container(
                  height: 9.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorUtils.greyBB.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: ColorUtils.primaryColor),
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Project 1",
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.white)),
                        Text("abc",
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.white)),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
