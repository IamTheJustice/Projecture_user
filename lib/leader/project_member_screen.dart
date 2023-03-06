import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecture/leader/approve_screen.dart';
import 'package:projecture/leader/give_task_data_screen.dart';
import 'package:projecture/utils/font_style_utils.dart';
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
  Widget build(BuildContext context) {
    String id = widget.id;
    String imageUrl = '';
    String Project = widget.Project;
    print(Project);
    final task = TextEditingController();
    final fromKey = GlobalKey<FormState>();
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryColor,
          title: Text('PROJECT MEMBER'),
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
                          child: ListTile(
                            leading: CircleAvatar(),
                            title: Text(data['Name']),
                            subtitle: Text(data['Email']),
                            trailing: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {},
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
