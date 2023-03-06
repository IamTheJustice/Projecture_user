import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:sizer/sizer.dart';

class ChristmasScreen extends StatefulWidget {
  const ChristmasScreen({Key? key}) : super(key: key);

  @override
  State<ChristmasScreen> createState() => _ChristmasScreenState();
}

class _ChristmasScreenState extends State<ChristmasScreen> {
  List<Map<String, dynamic>> detailList = <Map<String, dynamic>>[
    {"imagepath": 'assets/images/c.jpeg'},
    {"imagepath": 'assets/images/c7.jpeg'},
    {"imagepath": 'assets/images/c6.jpeg'},
    {"imagepath": 'assets/images/c5.jpeg'},
    {"imagepath": 'assets/images/c4.jpeg'},
    {"imagepath": 'assets/images/c3.jpeg'},
    {"imagepath": 'assets/images/c2.jpeg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: Get.height / 2,
                width: Get.width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 9.0,
                      color: ColorUtils.black.withOpacity(0.2),
                      spreadRadius: 0.5),
                ]),
                child: Image.asset("assets/images/c1.jpeg", fit: BoxFit.fill),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const CircleAvatar(
                                radius: 18.0,
                                backgroundColor: ColorUtils.white,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: ColorUtils.primaryColor,
                                ),
                              ),
                            ),
                            CircleAvatar(
                                radius: 25.0,
                                backgroundColor: ColorUtils.white,
                                child: Center(
                                    child: Text(
                                  "25 \nDec",
                                  style:
                                      FontTextStyle.Proxima14Regular.copyWith(
                                          color: ColorUtils.primaryColor),
                                ))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Center(
                        child: Container(
                          height: 29.h,
                          width: 55.w,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 9.0,
                                color: ColorUtils.black.withOpacity(0.2),
                                spreadRadius: 0.5),
                          ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset("assets/images/c1.jpeg",
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 3.w, top: 2.h),
            child: Text(
              "Christmas Festival",
              style: FontTextStyle.Proxima16Medium.copyWith(
                  color: ColorUtils.primaryColor,
                  fontWeight: FontWeightClass.extraB,
                  fontSize: 16.sp),
            ),
          ),
          const Divider(
            color: ColorUtils.greyB6,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.w, top: 2.h, right: 4.w),
            child: Row(
              children: const [
                Icon(
                  Icons.location_pin,
                  color: ColorUtils.primaryColor,
                ),
                Text("North Center"),
                Spacer(),
                Text("7AM - 2PM"),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 2.h, left: 4.w),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: detailList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.w, horizontal: 1.w),
                    child: Container(
                      height: 8.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.greyBB.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        child: Image.asset(
                          detailList[index]['imagepath'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w),
            child: const Text(
              "Christmas is celebrated on 25 December. It is a holiday to celebrate the birth of Jesus Christ, who, according to the Christian religion, is the son of God. The name is a joining of “Christ” and “mass” which means the holy mass (supper, celebration or festival) of Christ.",
              overflow: TextOverflow.visible,
            ),
          )
        ],
      ),
    );
  }
}
