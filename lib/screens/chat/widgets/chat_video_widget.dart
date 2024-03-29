import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecture/screens/video_player/video_player.dart';
import 'package:projecture/screens/widgets/cache_network_image_widget.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/const/function.dart';
import '../../../model/chatting_info_model.dart';

class ChatVideoWidget extends StatefulWidget {
  ChatVideoWidget({super.key, required this.videoUrl, required this.imageUrl, required this.receiverId, required this.isRead, required this.messageText, required this.sender, required this.name, required this.time, required this.index, required this.listOfChat});
  String sender;
  String messageText;
  int time;
  bool isRead;
  int index;
  String receiverId;
  List<ChattingInfo> listOfChat;
  String name;
  String imageUrl;
  String videoUrl;
  @override
  State<ChatVideoWidget> createState() => _ChatVideoWidgetState();
}

class _ChatVideoWidgetState extends State<ChatVideoWidget> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isLongpress = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (currentUser!.uid == widget.sender) {
          isLongpress = true;
          setState(() {});
          showDialog(
              context: context,
              builder: (ct) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(10),
                  content: Container(
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(child: Text('Delete message from ${widget.name}')),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(ct);
                            },
                            child: Text('Cancel')),
                        MaterialButton(
                            onPressed: () async {
                              // print(widget.index);
                              Navigator.pop(ct);
                              final d1 = await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").get();
                              if (d1.exists) {
                                await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").collection('conversation').doc(widget.listOfChat[widget.index].id).delete();
                              } else {
                                await FirebaseFirestore.instance.collection('conversation').doc("${widget.receiverId}_${currentUser!.uid}").collection('conversation').doc(widget.listOfChat[widget.index].id).delete();
                              }
                              isLongpress = false;
                              setState(() {});
                              // log(message)
                            },
                            child: Text('delete for everyone')),
                        MaterialButton(
                            onPressed: () async {
                              // print(widget.index);
                              Navigator.pop(ct);
                              final d1 = await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").get();
                              if (d1.exists) {
                                await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").collection('conversation').doc(widget.listOfChat[widget.index].id).update({
                                  'deleteVisivility': [
                                    widget.receiverId
                                  ]
                                });
                              } else {
                                await FirebaseFirestore.instance.collection('conversation').doc("${widget.receiverId}_${currentUser!.uid}").collection('conversation').doc(widget.listOfChat[widget.index].id).update({
                                  'deleteVisivility': [
                                    widget.receiverId
                                  ]
                                });
                              }
                              // isLongpress = false;
                              // setState(() {});
                              // // log(message)
                            },
                            child: Text('delete for me'))
                      ],
                    ),
                  ),
                );
              });
        } else {
          isLongpress = true;
          setState(() {});
          showDialog(
              context: context,
              builder: (ct) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(10),
                  content: Container(
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(child: Text('Delete message from ${widget.name}')),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(ct);
                            },
                            child: Text('Cancel')),
                        MaterialButton(
                            onPressed: () async {
                              // print(widget.index);
                              Navigator.pop(ct);
                              final d1 = await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").get();
                              if (d1.exists) {
                                await FirebaseFirestore.instance.collection('conversation').doc("${currentUser!.uid}_${widget.receiverId}").collection('conversation').doc(widget.listOfChat[widget.index].id).update({
                                  'deleteVisivility': [
                                    widget.receiverId
                                  ]
                                });
                              } else {
                                await FirebaseFirestore.instance.collection('conversation').doc("${widget.receiverId}_${currentUser!.uid}").collection('conversation').doc(widget.listOfChat[widget.index].id).update({
                                  'deleteVisivility': [
                                    widget.receiverId
                                  ]
                                });
                              }
                              // isLongpress = false;
                              // setState(() {});
                              // // log(message)
                            },
                            child: Text('delete for me'))
                      ],
                    ),
                  ),
                );
              });
        }
        // indexList.add(widget.index);
        // print(widget.index);

        // log('on long pressed');
      },
      onTap: () {
        if (currentUser!.uid == widget.sender) {
          isLongpress = false;
          // indexList.remove(widget.index);
          setState(() {});
        } else {
          isLongpress = false;
          // indexList.remove(widget.index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
        color: isLongpress ? Colors.blue.withOpacity(0.5) : null,
        child: Align(
          alignment: currentUser!.uid == widget.sender ? Alignment.topRight : Alignment.topLeft,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => KVideoPlayer(videoPath: widget.videoUrl)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorUtils.primaryColor.withOpacity(0.9),
              ),
              padding: const EdgeInsets.all(0),
              child: Stack(children: [
                Container(
                  // color: Colors.black.withOpacity(0.5),
                  height: 150,
                  width: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CacheNetworkImageWidget(
                      imageUrl: widget.imageUrl,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Icon(
                    Icons.play_circle,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatDate(widget.time),
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      widget.sender == currentUser!.uid
                          ? widget.isRead
                              ? const Icon(
                                  Icons.done_all,
                                  color: Colors.blue,
                                  size: 14,
                                )
                              : const Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color: Colors.white,
                                )
                          : Container()
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
