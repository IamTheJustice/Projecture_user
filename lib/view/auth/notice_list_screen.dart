import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({Key? key}) : super(key: key);

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  List<Map<String, dynamic>> noticeList = <Map<String, dynamic>>[
    {"text": 'Stress level'},
    {"text": 'Anger/lrritability'},
    {"text": 'Repressed emotions'},
    {"text": 'Conflict'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          "Notice",
          style: FontTextStyle.Proxima16Medium.copyWith(
              fontSize: 17.sp, color: ColorUtils.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorUtils.white),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Lottie.asset("assets/icons/notice.json", height: 50.w),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(top: 2.h),
                  shrinkWrap: true,
                  itemCount: noticeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 4.w),
                          child: Container(
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
                                borderRadius: BorderRadius.circular(10),
                                color: ColorUtils.white),
                            child: Theme(
                              data: ThemeData(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                iconColor: ColorUtils.primaryColor,
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            ColorUtils.primaryColor,
                                        radius: 20.0,
                                        child: Image.asset(
                                          "assets/images/noticelist.png",
                                          color: ColorUtils.white,
                                          scale: 3.w,
                                        )),
                                    SizeConfig.sW2,
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          noticeList[index]['text'],
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: ColorUtils.primaryColor),
                                        ),
                                        Text(
                                          "21-04-2023",
                                          style: FontTextStyle.Proxima12Regular
                                              .copyWith(
                                                  color:
                                                      ColorUtils.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  SizedBox(
                                    width: Get.width,
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 3.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3.w, right: 3.w),
                                              child: const Divider(
                                                color: ColorUtils.greyCE,
                                                thickness: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.w,
                                                  right: 3.w,
                                                  top: 1.h),
                                              child: Text(
                                                "Amet minium mollit non deserunt uliamoc est sit aliqua dolor do amet sint.Amet minium mollit non deserunt uliamoc est sit aliqua dolor do amet sint.Amet minium mollit n sit aliqua dolor do amet.",
                                                style:
                                                    TextStyle(fontSize: 10.sp),
                                              ),
                                            ),
                                            SizeConfig.sH1,
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
