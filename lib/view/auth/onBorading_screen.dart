import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/company_list_screen.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int pageChange = 0;
  int selectedindex = 0;
  PageController pageController = PageController(initialPage: 0);

  List<String> content = [
    "Organized in one place ",
    "Stay connected ",
    "Keep project on track ",
  ];
  List<String> content1 = [
    "Work from home never gets easier,\n everything is organized in one place ",
    "Stay connected with your team\n members while working from home",
    "Get your things done with ease,work\n  better together with your teams ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                /// PAGE VIEW
                SizedBox(
                  width: Get.width,
                  height: 130.w,
                  child: Stack(
                    children: [
                      PageView(
                        physics: const BouncingScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (value) {
                          setState(() {
                            pageChange = value;
                          });
                        },
                        children: [
                          Container(
                            child: SvgPicture.asset("assets/images/test1.svg"),
                          ),
                          Container(
                              child: Image.asset("assets/images/test.png")),
                          Container(
                            child: SvgPicture.asset("assets/images/test2.svg"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        pageChange == 0
                            ? Text("", style: TextStyle(fontSize: 25.sp))
                            : const SizedBox(),
                        pageChange < 2
                            ? InkWell(
                                onTap: () {
                                  Get.off((const CompanyListScreen()));
                                },
                                child: Text("Skip",
                                    style: TextStyle(fontSize: 13.sp)),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            contentTextWidget(),
            SizeConfig.sH1,
            Text(
              content1[pageChange],
              style: FontTextStyle.Proxima14Regular.copyWith(
                  color: ColorUtils.greyB6),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: index == 1 ? 4 : 0),
                    decoration: BoxDecoration(
                        color: pageChange == index
                            ? ColorUtils.primaryColor
                            : ColorUtils.greyCE,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    height: 4,
                    width: 17,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.w),
              child: InkWell(
                onTap: () {
                  pageChange < 2
                      ? pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut)
                      : Get.off((const CompanyListScreen()));
                },
                child: Container(
                  height: 13.w,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text('Next',
                      style: TextStyle(fontSize: 15.sp, color: Colors.white)),
                ),
              ),
            ),
            SizeConfig.sH2,
          ],
        ),
      ),
    );
  }

  Widget contentTextWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(content[pageChange],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.sp, color: ColorUtils.primaryColor)),
      ),
    );
  }
}
