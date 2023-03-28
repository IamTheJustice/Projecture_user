import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projecture/screens/chat/widgets/user_contact_widget.dart';
import 'package:projecture/screens/widgets/cache_network_image_widget.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:sizer/sizer.dart';

class UserContactScreen extends StatefulWidget {
  const UserContactScreen({
    super.key,
    required this.companyId,
  });
  final String companyId;

  @override
  State<UserContactScreen> createState() => _UserContactScreenState();
}

class _UserContactScreenState extends State<UserContactScreen> {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserContact() async {
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection(widget.companyId)
        .doc(widget.companyId)
        .collection('user')
        .get();
    // Provider.of<UserContactProvider>(context,listen: false).setUserContactData(res.docs);
    return res;
  }
  // List<Contact>? contacts;
  // List<String> cont = [];
  // List<AllDetail> main = [];
  // List<AllDetail> phoneNum = [];
  // List data = [];
  // List<Map<String, dynamic>>? check;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          "All Users",
          style: FontTextStyle.Proxima16Medium.copyWith(
              fontSize: 17.sp, color: ColorUtils.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorUtils.white),
      ),
      // appBar: AppBar(
      //     leading: InkWell(
      //         onTap: () {
      //           // Navigator.pushAndRemoveUntil(
      //           //     context,
      //           //     MaterialPageRoute(
      //           //         builder: (context) => HomeScreen(
      //           //               initialIndx: 1,
      //           //             )),
      //           //     (route) => false);
      //           // final state = BlocProvider.of<ContactBloc>(context).state;

      //           // if (state is ContactLoaded && state.props.length > 0) {
      //           //   print('contact');
      //           //   // print(
      //           //   //     "data:::: ${BlocProvider.of<GetDataBloc>(ctx).state.props.length}");
      //           //   List<ContactList> cont1 = state.contactList;
      //           //   BlocProvider.of<GetChatBloc>(context).add(GetChatData(cont1));
      //           // }
      //         },
      //         child: Icon(Icons.arrow_back)),
      //     title: Text('Contact')),
      body:
          // WillPopScope(
          //   onWillPop: () async {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => HomeScreen(
          //                   initialIndx: 1,
          //                 )),
          //         (route) => false);
          //     final state = BlocProvider.of<ContactBloc>(context).state;

          //     if (state is ContactLoaded && state.props.length > 0) {
          //       print('contact');
          //       List<ContactList> cont1 = state.contactList;
          //       BlocProvider.of<GetChatBloc>(context).add(GetChatData(cont1));
          //     }
          //     return false;
          //   },
          // child:
          RefreshIndicator(
        onRefresh: () async {
          // BlocProvider.of<GetDataBloc>(context).emit(GetDataInitial());
        },
        child: FutureBuilder<QuerySnapshot>(
            future: getUserContact(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.docs[i];
                      return InkWell(
                        onTap: () {
                          // print("code::::: ${data[index].fcmToken}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserContactWidget(
                                        receiverId: data['Uid'],
                                        phoneNumber: data['Phone'],
                                        name: data['Name'],
                                        imageUrl: data['ProfileImage'],
                                        fcmToken: '',
                                      )));
                        },
                        child: ListTile(
                          leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CacheNetworkImageWidget(
                                    imageUrl: data['ProfileImage'],
                                  ))),
                          subtitle: Text(data['Email']),
                          title: Text(data['Name']),
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
        // ListView.builder(
        //     itemCount: data.length,
        //     itemBuilder: (context, index) {
        //       return InkWell(
        //         onTap: () {
        //           print("code::::: ${data[index].fcmToken}");
        //           // Navigator.push(
        //           //     context,
        //           //     MaterialPageRoute(
        //           //         builder: (context) => ContactWidget(
        //           //               receiverId: data[index].id,
        //           //               phoneNumber: data[index].phoneNumber,
        //           //               name: data[index].name,
        //           //               imageUrl: data[index].imageUrl,
        //           //               fcmToken: data[index].fcmToken,
        //           //             )));
        //         },
        //         child: ListTile(
        //           leading: Container(
        //               height: 50,
        //               width: 50,
        //               decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(50),
        //                   color: Colors.grey),
        //               child: ClipRRect(
        //                   borderRadius: BorderRadius.circular(50),
        //                   child: CacheNetworkImageWidget(
        //                     imageUrl: data[index].imageUrl,
        //                   ))),
        //           subtitle: Text(data[index].phoneNumber),
        //           title: Text(data[index].name),
        //         ),
        //       );
        //     })
        // } else if (state is GetDataLoading) {
        //   return Center(child: CircularProgressIndicator());
        // } else if (state is GetDataInitial) {
        //   log('initial');
        //   BlocProvider.of<GetDataBloc>(context).add(GetData());
        //   return Center(
        //       child: CircularProgressIndicator(
        //     color: Colors.green,
        //   ));
        // } else {
        //   return Container();
        // }
        // }),
      ),
      // ),
    );
  }
}
