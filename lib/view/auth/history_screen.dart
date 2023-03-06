import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          centerTitle: true,
          backgroundColor: ColorUtils.primaryColor,
          iconTheme: const IconThemeData(color: ColorUtils.white),
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child:
                      Lottie.asset("assets/icons/history.json", height: 50.w),
                ),
                ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 5.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 3.h,
                                  width: 6.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(
                                          color: ColorUtils.primaryColor)),
                                  child: Center(
                                    child: Text(
                                      "${1}",
                                      style: FontTextStyle.Proxima14Regular
                                          .copyWith(
                                              fontWeight:
                                                  FontWeightClass.extraB,
                                              color: ColorUtils.primaryColor),
                                    ),
                                  ),
                                ),
                                SizeConfig.sW3,
                                Center(
                                  child: Text(
                                    "Project Name",
                                    style:
                                        FontTextStyle.Proxima16Medium.copyWith(
                                            fontWeight: FontWeightClass.extraB,
                                            fontSize: 13.sp,
                                            color: ColorUtils.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: ColorUtils.greyCE,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
