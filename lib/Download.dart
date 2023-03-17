import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/font_style_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class DownloadFile extends StatefulWidget {
  var fileLink;
  var fileNm;

  DownloadFile({
    required this.fileNm,
    required this.fileLink,
  });

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  bool downloading = false;
  String progressString = '';
  String downloadedPath = '';
  // Dio dio = Dio();
  double progress = 0.0;

  final progressNotifier = ValueNotifier<double?>(0);

  void startDownloading() async {
    progressNotifier.value = null;

    const url = 'https://www.ssa.gov/oact/babynames/names.zip';
    final request = http.Request('GET', Uri.parse(url));
    final http.StreamedResponse response = await http.Client().send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    progressNotifier.value = 0;

    List<int> bytes = [];

    final file = await _getFile('names.zip');
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        progressNotifier.value = downloadedLength / contentLength!;
      },
      onDone: () async {
        progressNotifier.value = 0;
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        debugPrint(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(dir.path);
  }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  // void showDownloadNotification(String fileName, String downloadedPath) async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       'channel id', 'channel NAME',
  //       priority: Priority.high, importance: Importance.max);
  //   var iOSDetails = new IOSNotificationDetails();
  //   var platformDetails =
  //       new NotificationDetails(android: androidDetails, iOS: iOSDetails);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'Download Complete', '$fileName downloaded ', platformDetails);
  // }

  void displayFile(String downloadDirectory) {
    downloading = false;
    progressString = "COMPLETED";
    downloadedPath = downloadDirectory;
  }

  Future<bool> getStoragePermission() async {
    return await Permission.storage.request().isGranted;
  }

  Future<String> getDownloadFolderPath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }

  Future downloadFile(String downloadDirectory) async {
    // Dio dio = Dio();
    // String folderName = 'pp';
    // String fileName = widget.fileNm;
    String url = widget.fileLink;
    // final downloadedPath =
    //     '$downloadDirectory/${DateTime.now().toString()}.jpg';
    //final file = File(downloadedPath);

    // if (file.existsSync()) {
    //   print('File is already Exists we replace it ');
    //   file.deleteSync();
    // }
    // await dio.download(
    //   url,
    //   downloadedPath,
    //   onReceiveProgress: (recivedBytes, totalBytes) {
    //     downloading = true;
    //     setState(() {
    //       progress = recivedBytes / totalBytes;
    //     });
    //     print(progress);
    //     progressString = 'COMPLETED';
    //   },

    // options: Options(
    //   responseType: ResponseType.bytes,
    //   followRedirects: false,
    //   validateStatus: (status) {
    //     return status! < 500;
    //   },
    // ),
    // );

    // var uri = Uri.parse(url);
    // var response = await http.get(uri);
    // if (response.statusCode == 200) {
    //   var dir = await DownloadsPathProvider.downloadsDirectory;
    //
    //   log('download URL -====== === $dir$url');
    //
    //   String savePath = "${dir!.path}/${DateTime.now().microsecond}";
    //   // log("path $savePath");
    //
    //   var file = File("$savePath.png");
    //   await file.writeAsBytes(response.bodyBytes);
    //   log("=======download path========>$savePath");
    //
    //   // showDownloadNotification(fileName, downloadedPath);
    //   await Future.delayed(const Duration(seconds: 2));
    //   return savePath;
    // }
  }

  Future<void> doDownloadFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadFile(downloadDirectory).then((filePath) {
        displayFile(filePath);
      });
    }
  }

  bool download = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doDownloadFile();
    debugPrint('-====-=-progress is -=-===--==$progressNotifier');
  }

  @override
  Widget build(BuildContext context) {
    final download = startDownloading();
    String downloadingProcess = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: ColorUtils.white,
      actions: [
        Column(
          children: [
            ValueListenableBuilder<double?>(
              valueListenable: progressNotifier,
              builder: (context, percent, child) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: ColorUtils.primaryColor,
                    value: percent,
                  ),
                );
              },
            ),
            SizeConfig.sH2,
            InkWell(
              onTap: () {
                Get.back();
                Get.back();
              },
              child: Container(
                height: 4.h,
                width: 30.w,
                decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Center(
                    child: Text(
                  "OK",
                  style: FontTextStyle.Proxima16Medium.copyWith(
                      color: ColorUtils.white),
                )),
              ),
            )
          ],
        )
      ],
      // content: downloadingProcess != '100'
      //     ? Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const CircularProgressIndicator(),
      //           const SizedBox(
      //             height: 20,
      //           ),
      //           Text(
      //             "Downloading : $downloadingProcess%",
      //             style: const TextStyle(
      //                 color: ColorUtils.primaryColor, fontSize: 17),
      //           ),
      //         ],
      //       )
      //     : Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Text(
      //             "Downloading Sucessfully",
      //             style: TextStyle(
      //               color: ColorUtils.primaryColor,
      //               fontSize: 17,
      //             ),
      //           ),
      //           Image.asset(
      //             "assets/images/sessionEnd.gif",
      //             scale: 1.w,
      //           ),
      //           SizeConfig.sH2,
      //           GestureDetector(
      //             onTap: () {
      //               Get.back();
      //               Get.back();
      //             },
      //             child: Container(
      //               height: 5.h,
      //               width: 25.w,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8),
      //                   color: ColorUtils.primaryColor),
      //               child: const Center(
      //                 child: Text(
      //                   'Done',
      //                   style: TextStyle(
      //                     color: ColorUtils.white,
      //                     fontSize: 17,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }
}
