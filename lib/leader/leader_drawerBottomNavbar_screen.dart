import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/leader/give_task_screen.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:projecture/view/auth/Login_screen.dart';
import 'package:projecture/view/auth/done_screen.dart';
import 'package:projecture/view/auth/events/card_details_screen.dart';
import 'package:projecture/view/auth/invite_screen.dart';
import 'package:projecture/view/auth/issue_screen.dart';
import 'package:projecture/view/auth/inprocess_screen.dart';
import 'package:projecture/view/auth/todo_screen.dart';
import 'package:projecture/view/auth/home_screen.dart';
import 'package:projecture/view/auth/profile_screen.dart';
import 'package:projecture/screens/chat/chat_screen.dart';
import 'package:projecture/view/auth/checking_screen.dart';
import 'package:projecture/view/auth/wallet_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LeaderDrawerBottomNavbar extends StatefulWidget {
  const LeaderDrawerBottomNavbar({super.key});

  @override
  State<LeaderDrawerBottomNavbar> createState() =>
      _LeaderDrawerBottomNavbarState();
}

class _LeaderDrawerBottomNavbarState extends State<LeaderDrawerBottomNavbar> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  String? id;
  String? uid;
  setData() async {
    final pref = await SharedPreferences.getInstance();
    id = pref.getString("companyId");
    uid = pref.getString("userId");
    log("""
    
   userid       ${pref.getString("userId")};
    company id -- ${pref.getString("companyId")};
    """);
    setState(() {});
  }

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
  final _auth = FirebaseAuth.instance;
  var pageAll = [
    const Homescreen(),
    const ChatScreen(),
    const CardDetailsScreen(),
  ];

  var myIndex = 0;
  String imageUrl = '';
  bool circular = false;
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black26,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor:
              themeNotifier.isDark ? ColorUtils.black : Colors.white,
          title: Text(
            "Projecture",
            style: FontTextStyle.Proxima16Medium.copyWith(
                fontSize: 17.sp,
                color: themeNotifier.isDark
                    ? ColorUtils.white
                    : ColorUtils.primaryColor),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
              color: themeNotifier.isDark
                  ? ColorUtils.white
                  : ColorUtils.primaryColor),
        ),
        drawer: Drawer(
          backgroundColor: themeNotifier.isDark ? Colors.black : Colors.white,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              children: [
                id != null
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(id!)
                            .doc(id)
                            .collection('user')
                            .where('Uid', isEqualTo: _auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 20.h,
                              child: ListView.builder(
                                  shrinkWrap: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    var data = snapshot.data!.docs[i];
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              data['ProfileImage'] == ""
                                                  ? CircleAvatar(
                                                      radius: 50.0,
                                                      backgroundColor:
                                                          ColorUtils
                                                              .primaryColor,
                                                      child: circular == true
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              onPressed:
                                                                  () async {
                                                                circular = true;
                                                                setState(() {});
                                                                ImagePicker
                                                                    imagePicker =
                                                                    ImagePicker();
                                                                XFile? file = await imagePicker
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                                print(
                                                                    '${file?.path}');

                                                                if (file ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                Reference
                                                                    referenceRoot =
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .ref();
                                                                Reference
                                                                    referenceDirImages =
                                                                    referenceRoot
                                                                        .child(
                                                                            'images');

                                                                Reference
                                                                    referenceImageToUpload =
                                                                    referenceDirImages
                                                                        .child(file
                                                                            .name);

                                                                try {
                                                                  await referenceImageToUpload
                                                                      .putFile(File(
                                                                              file!.path)
                                                                          .absolute);

                                                                  imageUrl =
                                                                      await referenceImageToUpload
                                                                          .getDownloadURL();
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          id!)
                                                                      .doc(id)
                                                                      .collection(
                                                                          'user')
                                                                      .doc(_auth
                                                                          .currentUser!
                                                                          .uid)
                                                                      .update({
                                                                    'ProfileImage':
                                                                        imageUrl
                                                                  });
                                                                  circular =
                                                                      false;
                                                                  setState(
                                                                      () {});
                                                                } catch (error) {
                                                                  //Some error occurred
                                                                }
                                                              },
                                                              icon: const Icon(Icons
                                                                  .camera_alt)),
                                                    )
                                                  : SizedBox(
                                                      height: 25.w,
                                                      width: 25.w,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(150),
                                                        child: Image.network(
                                                          data['ProfileImage'],
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                              IconButton(
                                                  onPressed: () {
                                                    themeNotifier.isDark =
                                                        !themeNotifier.isDark;
                                                  },
                                                  icon: themeNotifier.isDark
                                                      ? const Icon(
                                                          Icons.nights_stay,
                                                          color:
                                                              ColorUtils.white,
                                                          size: 30.0,
                                                        )
                                                      : const Icon(
                                                          Icons.wb_sunny,
                                                          color:
                                                              ColorUtils.black,
                                                          size: 30.0,
                                                        )),
                                            ],
                                          ),
                                          SizeConfig.sH2,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['Name'],
                                                style: FontTextStyle
                                                        .Proxima16Medium
                                                    .copyWith(
                                                        color: themeNotifier
                                                                .isDark
                                                            ? ColorUtils.white
                                                            : ColorUtils
                                                                .primaryColor,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeightClass
                                                                .semiB),
                                              ),
                                              Text(
                                                data['Email'],
                                                style: FontTextStyle
                                                    .Proxima16Medium.copyWith(
                                                  color: themeNotifier.isDark
                                                      ? ColorUtils.white
                                                      : ColorUtils.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorUtils.primaryColor,
                                strokeWidth: 1.1,
                              ),
                            );
                          }
                        })
                    : const SizedBox(),
                const Divider(
                  thickness: 1,
                  color: ColorUtils.greyB6,
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => InviteScreen(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: Icon(
                    Icons.insert_invitation,
                    color: themeNotifier.isDark
                        ? ColorUtils.white
                        : ColorUtils.black.withOpacity(0.6),
                  ),
                  title: Text(
                    'Invite',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => ToDo(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: SvgPicture.asset(
                    'assets/icons/board.svg',
                    height: 5.w,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'To Do',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor,
                        fontSize: 11.sp),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => Process(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: Icon(
                    Icons.drive_folder_upload,
                    color: themeNotifier.isDark
                        ? ColorUtils.white
                        : ColorUtils.black.withOpacity(0.6),
                  ),
                  title: Text(
                    'In Process',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => issue(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: SvgPicture.asset(
                    'assets/icons/issues.svg',
                    height: 5.w,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'Issue',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => LeaderGiveTaskScreen(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: SvgPicture.asset(
                    'assets/icons/wallet.svg',
                    height: 5.w,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'Give task',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => const WalletScreen());
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: SvgPicture.asset(
                    'assets/icons/wallet.svg',
                    height: 5.w,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'Wallet',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => CheckingScreen(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: Icon(
                    Icons.add_task,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'Checking',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => DoneScreen(id: id!));
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  leading: SvgPicture.asset(
                    'assets/icons/premium.svg',
                    height: 5.w,
                    color: themeNotifier.isDark ? ColorUtils.white : null,
                  ),
                  title: Text(
                    'Done',
                    style: FontTextStyle.Proxima16Medium.copyWith(
                        color: themeNotifier.isDark
                            ? ColorUtils.white
                            : ColorUtils.primaryColor),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: ColorUtils.white,
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
                                  Get.to(() => LoginScreen(id: id!));
                                },
                                child: Container(
                                  height: 10.w,
                                  width: 25.w,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      color: ColorUtils.primaryColor),
                                  child: const Center(
                                    child: Text(
                                      "Cancel",
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Finding this app usefull?",
                        style: FontTextStyle.Proxima12Regular.copyWith(
                            color: themeNotifier.isDark
                                ? ColorUtils.white
                                : ColorUtils.greyBB),
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
        ),
        body: pageAll[myIndex],
        bottomNavigationBar: Container(
          height: 7.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.9,
                  color: ColorUtils.black.withOpacity(0.2),
                  blurRadius: 5.0)
            ],
            color: themeNotifier.isDark ? ColorUtils.black : Colors.white,
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
                        color: themeNotifier.isDark
                            ? myIndex == 0
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 0
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.home,
                      color: themeNotifier.isDark
                          ? myIndex == 0
                              ? ColorUtils.purple
                              : ColorUtils.white
                          : myIndex == 0
                              ? ColorUtils.purpleColor
                              : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Home",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color: themeNotifier.isDark
                            ? myIndex == 0
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 0
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    myIndex = 1;
                  });
                },
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
                        color: themeNotifier.isDark
                            ? myIndex == 1
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 1
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.chat,
                      color: themeNotifier.isDark
                          ? myIndex == 1
                              ? ColorUtils.purple
                              : ColorUtils.white
                          : myIndex == 1
                              ? ColorUtils.purpleColor
                              : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Chat",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color: themeNotifier.isDark
                            ? myIndex == 1
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 1
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    myIndex = 2;
                  });
                },
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
                        color: themeNotifier.isDark
                            ? myIndex == 2
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 2
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    ),
                    SizeConfig.sH05,
                    Icon(
                      Icons.account_circle,
                      color: themeNotifier.isDark
                          ? myIndex == 2
                              ? ColorUtils.purple
                              : ColorUtils.white
                          : myIndex == 2
                              ? ColorUtils.purpleColor
                              : ColorUtils.primaryColor,
                    ),
                    Text(
                      "Profile",
                      style: FontTextStyle.Proxima14Regular.copyWith(
                        color: themeNotifier.isDark
                            ? myIndex == 2
                                ? ColorUtils.purple
                                : ColorUtils.white
                            : myIndex == 2
                                ? ColorUtils.purpleColor
                                : ColorUtils.primaryColor,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
