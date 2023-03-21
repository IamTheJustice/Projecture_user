import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/events/christmasEvent_screen.dart';
import 'package:projecture/events/deepavaliEvent_screen.dart';
import 'package:projecture/events/ganeshChaturthiEvent_screen.dart';
import 'package:projecture/events/holiEvents_screen.dart';
import 'package:projecture/events/independenceEvent_screen.dart';
import 'package:projecture/events/janmashtamiEvent_screen.dart';
import 'package:projecture/events/makarSankrantiEvent_screen.dart';
import 'package:projecture/events/navratriEvent_screen.dart';
import 'package:projecture/events/sportEvent_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  String? cid;
  String? uid;
  setData() async {
    final pref = await SharedPreferences.getInstance();
    cid = pref.getString("companyId");
    uid = pref.getString("userId");
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);
  }

  List<Map<String, dynamic>> eventList = <Map<String, dynamic>>[
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmNTentNeg8aBAegmUmv7TIiUC0tyOExBw2g&usqp=CAU",
      "title": 'NAVRATRI',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyxo9CSwRn6SDNMEq6EA8cfybrzz2cK6v1wg&usqp=CAU",
      "title": 'HOLI',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3UZPIJaf5xz3g7e0LQWByroMqnBF3nJ5Puw&usqp=CAU",
      "title": 'DEEPAVALI',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpyzKKIem2ZfrbH4RX1uWhLZ4JMAPfEDCmog&usqp=CAU",
      "title": 'INDEPENDENCE',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS79X7F95A9Xdp97KMb99Fc_DcJEyMRA8F0Dw&usqp=CAU",
      "title": 'CHRISTMAS',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbC6Cl_wnQn-JE9XjJwOe0yG2-Mf1kyZx9qA&usqp=CAU",
      "title": 'MAKAR SANKRANTI',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVnUPWcvmJqFjGRgC_i4nx2TsVCnpKjlhmMQ&usqp=CAU",
      "title": 'GANESH CHATURTHI',
    },
    {
      "imagepath":
          "https://naipunnya.ac.in/wp-content/uploads/2021/08/National-Sports-Day-celebration-1.webp",
      "title": 'SPORTS',
    },
    {
      "imagepath":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdcbA_kWgOMs8S3PztdYv23m9tTET_bo8FZQ&usqp=CAU",
      "title": 'JANMASHTAMI',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: ColorUtils.white),
          elevation: 0.0,
          backgroundColor:
              themeNotifier.isDark ? ColorUtils.black : ColorUtils.primaryColor,
          title: Text(
            "Events",
            style: FontTextStyle.Proxima16Medium.copyWith(
                fontSize: 17.sp, color: ColorUtils.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: eventList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 200,
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    eventList[index]['title'] == "NAVRATRI"
                        ? Get.to(() => const NavratriScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "HOLI"
                        ? Get.to(() => const HoliScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "DEEPAVALI"
                        ? Get.to(() => const DeepavaliScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "INDEPENDENCE"
                        ? Get.to(() => const IndependenceScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "CHRISTMAS"
                        ? Get.to(() => const ChristmasScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "MAKAR SANKRANTI"
                        ? Get.to(() => const MakarSnakrantiScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "GANESH CHATURTHI"
                        ? Get.to(() => const GaneshChturthiScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "SPORTS"
                        ? Get.to(() => const SportScreen())
                        : const SizedBox();
                    eventList[index]['title'] == "JANMASHTAMI"
                        ? Get.to(() => const JanmashtamiScreen())
                        : const SizedBox();
                  },
                  child: Container(
                    width: 40.w,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(eventList[index]['imagepath']),
                            fit: BoxFit.cover)),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.black12,
                                Colors.black45,
                                Colors.black87,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              eventList[index]['title'],
                              textAlign: TextAlign.center,
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.white,
                                  fontWeight: FontWeightClass.extraB),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    });
  }
}
