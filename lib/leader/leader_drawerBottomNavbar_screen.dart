import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/leader/give_task_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/Login_screen.dart';
import 'package:projecture/view/auth/done_screen.dart';
import 'package:projecture/view/auth/events_screen.dart';
import 'package:projecture/view/auth/history_screen.dart';
import 'package:projecture/view/auth/invite_screen.dart';
import 'package:projecture/view/auth/issue_screen.dart';
import 'package:projecture/view/auth/inprocess_screen.dart';
import 'package:projecture/view/auth/notice_list_screen.dart';
import 'package:projecture/view/auth/todo_screen.dart';
import 'package:projecture/view/auth/home_screen.dart';
import 'package:projecture/view/auth/profile_screen.dart';
import 'package:projecture/view/auth/chat_screen.dart';
import 'package:projecture/view/auth/checking_screen.dart';
import 'package:projecture/view/auth/wallet_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:octo_image/octo_image.dart';

class LeaderDrawerBottomNavbar extends StatefulWidget {
  String id;
  LeaderDrawerBottomNavbar({required this.id});

  @override
  State<LeaderDrawerBottomNavbar> createState() =>
      _LeaderDrawerBottomNavbarState();
}

class _LeaderDrawerBottomNavbarState extends State<LeaderDrawerBottomNavbar> {
  @override
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
  var pageAll = [
    // const HomeScreen(),
    const ChatScreen(),
    const MyProfile(),
  ];

  var myIndex = 0;
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Projecture",
          style: FontTextStyle.Proxima16Medium.copyWith(
              fontSize: 17.sp, color: ColorUtils.primaryColor),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorUtils.primaryColor),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    child: ClipOval(
                      child: OctoImage(
                        image: const NetworkImage(
                            // "${PreferenceUtils.getProfileImage()}",
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Macaca_nigra_self-portrait_large.jpg/1024px-Macaca_nigra_self-portrait_large.jpg"),
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        ),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizeConfig.sH2,
                  Text(
                    "Anurag Jagani",
                    // '${PreferenceUtils.getisuser()}',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: ColorUtils.primaryColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeightClass.semiB),
                  ),
                  Text(
                    "anuragjagani34@gmail.com",
                    // '${PreferenceUtils.getEmail()}',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                      color: ColorUtils.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizeConfig.sH1,
            const Divider(
              thickness: 1,
              color: ColorUtils.greyB6,
            ),
            ListTile(
              onTap: () {
                // Get.to(() => InviteScreen());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InviteScreen(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: Icon(
                Icons.insert_invitation,
                color: ColorUtils.black.withOpacity(0.6),
              ),
              title: Text(
                'Invite',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                // Get.to(() => const ToDo());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ToDo(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: SvgPicture.asset('assets/icons/board.svg', height: 5.w),
              title: Text(
                'To Do',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor, fontSize: 11.sp),
              ),
            ),
            ListTile(
              onTap: () {
                // Get.to(() => Process());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Process(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: Icon(
                Icons.drive_folder_upload,
                color: ColorUtils.black.withOpacity(0.6),
              ),
              title: Text(
                'In Process',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                //Get.to(() => issue());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => issue(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: SvgPicture.asset('assets/icons/issues.svg', height: 5.w),
              title: Text(
                'Issue',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderGiveTaskScreen(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: SvgPicture.asset('assets/icons/wallet.svg', height: 5.w),
              title: Text(
                'Give task',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                //Get.to(() => WalletScreen());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: SvgPicture.asset('assets/icons/wallet.svg', height: 5.w),
              title: Text(
                'Wallet',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                //Get.to(() => const CheckingScreen());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckingScreen(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: SvgPicture.asset('assets/icons/wallet.svg', height: 5.w),
              title: Text(
                'Checking',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                //Get.to(() => DoneScreen());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoneScreen(id: id)),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading:
                  SvgPicture.asset('assets/icons/premium.svg', height: 5.w),
              title: Text(
                'Done',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.primaryColor),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Text(
                              'Log out',
                              style: FontTextStyle.Proxima16Medium.copyWith(
                                  color: ColorUtils.primaryColor,
                                  fontWeight: FontWeightClass.extraB,
                                  fontSize: 13.sp),
                            ),
                            SizeConfig.sH1,
                            Lottie.asset("assets/images/logout.json",
                                height: 25.w),
                          ],
                        ),
                        content: Text('are you sure you want to log out?',
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.primaryColor)),
                        actions: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(id: id)),
                              );
                            },
                            child: Container(
                              height: 10.w,
                              width: 25.w,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: ColorUtils.primaryColor),
                              child: const Center(
                                child: Text(
                                  "Done",
                                  style: TextStyle(color: ColorUtils.white),
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
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: ColorUtils.primaryColor),
                              child: const Center(
                                child: Text(
                                  "Cancle",
                                  style: TextStyle(color: ColorUtils.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: const Icon(
                Icons.exit_to_app,
                color: ColorUtils.redColor,
              ),
              title: Text(
                'Log out',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.redColor),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Text('Delete',
                                style: FontTextStyle.Proxima16Medium.copyWith(
                                    color: ColorUtils.primaryColor,
                                    fontWeight: FontWeightClass.extraB,
                                    fontSize: 13.sp)),
                            SizeConfig.sH1,
                            Lottie.asset("assets/images/delete.json",
                                height: 25.w)
                          ],
                        ),
                        content: Text('are you sure you want to delete?',
                            style: FontTextStyle.Proxima16Medium.copyWith(
                                color: ColorUtils.primaryColor)),
                        actions: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 10.w,
                              width: 25.w,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: ColorUtils.primaryColor),
                              child: const Center(
                                child: Text(
                                  "Done",
                                  style: TextStyle(color: ColorUtils.white),
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
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: ColorUtils.primaryColor),
                              child: const Center(
                                child: Text(
                                  "Cancle",
                                  style: TextStyle(color: ColorUtils.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
              leading: const Icon(
                Icons.exit_to_app,
                color: ColorUtils.redColor,
              ),
              title: Text(
                'Delete',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    color: ColorUtils.redColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Finding this app usefull?",
                    style: FontTextStyle.Proxima12Regular.copyWith(
                        color: ColorUtils.greyBB),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/drawerImage.svg'),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/sucessfully.svg'),
                  SizeConfig.sW2,
                  SvgPicture.asset('assets/icons/unsucessfully.svg'),
                  SizeConfig.sW2,
                ],
              ),
            ),
          ],
        ),
      ),
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
                      GestureDetector(
                        onTap: () {
                          templist[index]['title'] == "Issue"
                              ? Get.to(() => issue(id: id))
                              : const SizedBox();
                          templist[index]['title'] == "Project"
                              ? Get.to(() => ToDo(id: id))
                              : const SizedBox();
                          templist[index]['title'] == "Notice"
                              ? Get.to(() => NoticeListScreen())
                              : const SizedBox();
                          templist[index]['title'] == "Events"
                              ? Get.to(() => const EventScreen())
                              : const SizedBox();
                          templist[index]['title'] == "History"
                              ? Get.to(() => const HistoryScreen())
                              : const SizedBox();
                        },
                        child: Container(
                          height: 33.w,
                          width: 35.w,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    ColorUtils.purple,
                                    ColorUtils.purpleColor,
                                    ColorUtils.primaryColor
                                  ],
                                  begin: FractionalOffset(0.5, 0.0),
                                  end: FractionalOffset(0.0, 0.5),
                                  tileMode: TileMode.clamp),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 9.0,
                                    color: ColorUtils.black.withOpacity(0.2),
                                    spreadRadius: 0.5),
                              ],
                              borderRadius: BorderRadius.circular(3.w),
                              color: ColorUtils.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizeConfig.sH2,
                              Image.asset(templist[index]['imagepath'],
                                  scale: 0.8.w),
                            ],
                          ),
                        ),
                      ),
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
      bottomNavigationBar: Container(
        height: 7.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                spreadRadius: 0.9,
                color: ColorUtils.black.withOpacity(0.2),
                blurRadius: 5.0)
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  myIndex = 0;
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 0.5.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color:
                            myIndex == 0 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.home,
                      color:
                          myIndex == 0 ? Colors.red : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Home",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color:
                            myIndex == 0 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  myIndex = 1;
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 0.5.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color:
                            myIndex == 1 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.chat,
                      color:
                          myIndex == 1 ? Colors.red : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Chat",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color:
                            myIndex == 1 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  myIndex = 2;
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 0.5.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color:
                            myIndex == 2 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.account_circle,
                      color:
                          myIndex == 2 ? Colors.red : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Profile",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color:
                            myIndex == 2 ? Colors.red : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
