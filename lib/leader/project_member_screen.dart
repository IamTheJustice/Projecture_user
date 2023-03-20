import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projecture/app_mode/model_theme.dart';
import 'package:projecture/leader/give_task_data_screen.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../utils/color_utils.dart';

class ProjectMemberScreen extends StatefulWidget {
  late String id;
  late String Project;
  ProjectMemberScreen({required this.id, required this.Project});

  @override
  State<ProjectMemberScreen> createState() => _ProjectMemberScreenState();
}

class _ProjectMemberScreenState extends State<ProjectMemberScreen> {
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

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    String imageUrl = '';
    String Project = widget.Project;
    print(Project);
    final task = TextEditingController();
    final fromKey = GlobalKey<FormState>();
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeNotifier.isDark
                ? ColorUtils.black
                : ColorUtils.primaryColor,
            title: Text('PROJECT MEMBER',
                style: FontTextStyle.Proxima16Medium.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeightClass.medium,
                    color: Colors.white)),
            centerTitle: true,
          ),
          body: Form(
            key: fromKey,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(id)
                    .doc(id)
                    .collection(Project)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 2.h),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TaskData(
                                    id: id,
                                    Uid: data['Uid'],
                                    Name: data['Name'],
                                    Project: Project,
                                    Email: data['Email']);
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 3.w, right: 3.w, top: 1.h),
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                    title: Text(data['Name']),
                                    subtitle: Text(data['Email']),
                                    trailing: CircleAvatar(
                                      backgroundColor: ColorUtils.purple,
                                      child: Icon(
                                        size: 5.w,
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 1.1,
                    ));
                  }
                }),
          ),
        ),
      );
    });
  }
}
