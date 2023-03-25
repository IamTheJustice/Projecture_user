import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({Key? key}) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: projectList(),
    );
  }
}

Widget noticeShimmer() {
  return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
    return Shimmer.fromColors(
      baseColor: themeNotifier.isDark ? Colors.grey : ColorUtils.primaryColor,
      highlightColor: ColorUtils.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: Colors.black,
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  height: 50.w,
                  width: Get.width / 2,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 0),
              height: 7.h,
              width: 350,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Widget projectList() {
  return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
    return Shimmer.fromColors(
      baseColor: themeNotifier.isDark ? Colors.grey : ColorUtils.purple,
      highlightColor: ColorUtils.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 18.w,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Widget companyChooseList() {
  return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
    return Shimmer.fromColors(
      baseColor: themeNotifier.isDark ? Colors.grey : ColorUtils.primaryColor,
      highlightColor: ColorUtils.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              child: Container(
                height: 4.5.h,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorUtils.purple),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
