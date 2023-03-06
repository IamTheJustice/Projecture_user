import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/events/makarSankrantiEvent_screen.dart';
import 'package:projecture/view/auth/events_screen.dart';
import 'package:projecture/view/auth/history_screen.dart';
import 'package:projecture/view/auth/issue_screen.dart';
import 'package:projecture/view/auth/notice_list_screen.dart';
import 'package:projecture/view/auth/todo_screen.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int select = 0;

  List<Map<String, dynamic>> templist = <Map<String, dynamic>>[
    {
      "imagepath": "assets/images/HomeProject.png",
      "title": 'Project',
      "textt": '10'
    },
    {"imagepath": "assets/images/notice.png", "title": 'Notice', "textt": '10'},
    {
      "imagepath": "assets/images/homeEvents.png",
      "title": 'Events',
      "textt": '10'
    },
    {
      "imagepath": "assets/images/HomeIsuue.png",
      "title": 'Issue',
      "textt": '10'
    },
    {
      "imagepath": "assets/images/history.png",
      "title": 'History',
      "textt": '10'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.w),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //childAspectRatio: 0.8,
              mainAxisSpacing: 12.0,
              //crossAxisSpacing:0.0
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     templist[index]['title'] == "Issue"
                      //         ? Get.to(() => const issue())
                      //         : const SizedBox();
                      //     templist[index]['title'] == "Project"
                      //         ? Get.to(() =>  ToDo(id:id))
                      //         : const SizedBox();
                      //     templist[index]['title'] == "Notice"
                      //         ? Get.to(() => const NoticeListScreen())
                      //         : const SizedBox();
                      //     templist[index]['title'] == "Events"
                      //         ? Get.to(() => const EventScreen())
                      //         : const SizedBox();
                      //     templist[index]['title'] == "History"
                      //         ? Get.to(() => const HistoryScreen())
                      //         : const SizedBox();
                      //   },
                      //   child: Container(
                      //     height: 33.w,
                      //     width: 35.w,
                      //     decoration: BoxDecoration(
                      //         gradient: const LinearGradient(
                      //             colors: [
                      //               ColorUtils.purple,
                      //               ColorUtils.purpleColor,
                      //               ColorUtils.primaryColor
                      //             ],
                      //             begin: FractionalOffset(0.5, 0.0),
                      //             end: FractionalOffset(0.0, 0.5),
                      //             tileMode: TileMode.clamp),
                      //         boxShadow: [
                      //           BoxShadow(
                      //               blurRadius: 9.0,
                      //               color: ColorUtils.black.withOpacity(0.2),
                      //               spreadRadius: 0.5),
                      //         ],
                      //         borderRadius: BorderRadius.circular(3.w),
                      //         color: ColorUtils.white),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         SizeConfig.sH2,
                      //         Image.asset(templist[index]['imagepath'],
                      //             scale: 0.8.w),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h, left: 2.w, right: 2.w),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 9.0,
                                color: ColorUtils.black.withOpacity(0.2),
                                spreadRadius: 0.5),
                          ],
                          color: ColorUtils.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      height: 10.h,
                      width: 30.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            templist[index]['title'],
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                fontSize: 14.sp,
                                color: ColorUtils.primaryColor),
                          ),
                          SizeConfig.sH05,
                          Text(
                            templist[index]['textt'],
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.greyB6),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
