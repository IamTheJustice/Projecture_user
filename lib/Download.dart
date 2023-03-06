import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projecture/utils/color_utils.dart';
import 'package:projecture/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';

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
  Dio dio = Dio();
  double progress = 0.0;

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
    Dio dio = Dio();
    String fileName = widget.fileNm;
    String url = widget.fileLink;
    var downloadedPath = '$downloadDirectory/$fileName.jpg';
    await dio.download(
      url,
      downloadedPath,
      onReceiveProgress: (recivedBytes, totalBytes) {
        downloading = true;
        setState(() {
          progress = recivedBytes / totalBytes;
        });
        print(progress);
        progressString = 'COMPLETED';
      },
    );
    await Future.delayed(const Duration(seconds: 2));
    return downloadedPath;
  }

  Future<void> doDownloadFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadFile(downloadDirectory).then((filePath) {
        displayFile(filePath);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doDownloadFile();
    debugPrint('-====-=-progress is -=-===--==$progress');
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProcess = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: ColorUtils.white,
      content: downloadingProcess != '100'
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Downloading : $downloadingProcess%",
                  style: const TextStyle(
                      color: ColorUtils.primaryColor, fontSize: 17),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Downloading Sucessfull",
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontSize: 17,
                  ),
                ),
                Image.asset(
                  "assets/images/sessionEnd.gif",
                  scale: 1.w,
                ),
                SizeConfig.sH2,
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 5.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorUtils.primaryColor),
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: ColorUtils.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
