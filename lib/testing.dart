import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyBottomNavigation1 = GlobalKey();
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project List"),
        centerTitle: true,
        backgroundColor: ColorUtils.primaryColor,
        iconTheme: const IconThemeData(color: ColorUtils.white),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
              child: Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowTaskToDo()));
                      },
                      child: Container(
                        height: 18.w,
                        margin: EdgeInsets.only(left: 3.sp),
                        decoration: BoxDecoration(
                          color: ColorUtils.green2A.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Show \nTask",
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.white,
                                fontWeight: FontWeightClass.semiB),
                          ),
                        ),
                      )),
                  extentRatio: .3,
                  dragDismissible: false,
                  children: const [],
                ),
                child: InkWell(
                  onTap: () {
                    showTutorial();
                  },
                  child: Container(
                    key: index == 0 ? keyBottomNavigation1 : null,
                    height: 18.w,
                    width: Get.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: ColorUtils.purple),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                      child: Text(
                        "Firebase project",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: FontTextStyle.Proxima16Medium.copyWith(
                            color: ColorUtils.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: ColorUtils.primaryColor.withOpacity(0.1),
      textSkip: "SKIP",
      textStyleSkip: const TextStyle(color: ColorUtils.white),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("swipe the right side box",
                      style: FontTextStyle.Proxima16Medium.copyWith(
                          color: ColorUtils.white,
                          fontWeight: FontWeightClass.extraB)),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}

class ShowTaskToDo extends StatefulWidget {
  const ShowTaskToDo({Key? key}) : super(key: key);

  @override
  State<ShowTaskToDo> createState() => _ShowTaskToDoState();
}

class _ShowTaskToDoState extends State<ShowTaskToDo> {
  var selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Task"),
        centerTitle: true,
        backgroundColor: ColorUtils.primaryColor,
        iconTheme: const IconThemeData(color: ColorUtils.white),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 7.w),
                  child: Container(
                    height: 20.h,
                    decoration: BoxDecoration(
                        color: ColorUtils.purple,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.black.withOpacity(0.2),
                            blurRadius: 5.0,
                            spreadRadius: 0.9,
                          )
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            "Task Name",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.white,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizeConfig.sH1,
                        Image.asset(
                          "assets/images/profile.png",
                          scale: 2.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/sessionEnd.gif",
                                              scale: 1.w,
                                            ),
                                            Text(
                                              'Start Task',
                                              style:
                                                  FontTextStyle.Proxima16Medium
                                                      .copyWith(
                                                          color: ColorUtils
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeightClass
                                                                  .extraB,
                                                          fontSize: 13.sp),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                            'are you sure want to start Task?',
                                            textAlign: TextAlign.center,
                                            style: FontTextStyle.Proxima16Medium
                                                .copyWith(
                                                    color: ColorUtils
                                                        .primaryColor)),
                                        actions: [
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                              Get.showSnackbar(
                                                GetSnackBar(
                                                  message:
                                                      "Start Task Succesfully",
                                                  borderRadius: 10.0,
                                                  margin: EdgeInsets.only(
                                                      left: 4.w,
                                                      right: 4.w,
                                                      bottom: 4.w),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: ColorUtils
                                                      .primaryColor
                                                      .withOpacity(0.9),
                                                  duration: const Duration(
                                                      seconds: 3),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 10.w,
                                              width: 25.w,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color:
                                                      ColorUtils.primaryColor),
                                              child: const Center(
                                                child: Text(
                                                  "Done",
                                                  style: TextStyle(
                                                      color: ColorUtils.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              height: 10.w,
                                              width: 25.w,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color:
                                                      ColorUtils.primaryColor),
                                              child: const Center(
                                                child: Text(
                                                  "Cancle",
                                                  style: TextStyle(
                                                      color: ColorUtils.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Text(
                                  "Start",
                                  style: FontTextStyle.Proxima16Medium.copyWith(
                                      color: ColorUtils.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeightClass.semiB),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
