import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class CustomDownloadTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showDivider, showDelete;
  final String url;
  final String fileName;
  const CustomDownloadTile(
      {super.key,
      required this.title,
      required this.url,
      required this.fileName,
      this.subtitle,
      this.showDivider = false,
      this.showDelete = false});

  @override
  State<CustomDownloadTile> createState() => _CustomDownloadTileState();
}

class _CustomDownloadTileState extends State<CustomDownloadTile> {
  double progress = 0.0;
  String downloadStatus = "DEFAULT";
  bool showProgress = false;
  bool doesFileExist = false;
  ReceivePort _port = ReceivePort();

  void downloadFile(String url, String fileName) async {
    // Wait for user to  give the premissions for storage read/write and external storage manage
    if (await Permission.storage.request().isDenied ||
        await Permission.manageExternalStorage.request().isDenied) {
      print("Storage access Permission denied");
    }
    // Check if the file already exists. If so, then print that the file already exists.
    if (await checkIfFileExistBool(fileName)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("File already exists! Click again to open"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ));
      return;
    }
    String path = await getDownloadFolderPath();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "1 file will be downloaded. Please check notification for progress."),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ));
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        saveInPublicStorage: true,
        savedDir: path,
        fileName: fileName.split('.')[0],
        allowCellular: true,
        openFileFromNotification: true,
        showNotification: true,
      );
      // .then((_) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text("File downloaded")));
      // });
      final tasks = FlutterDownloader.loadTasks();
      print("ijflsdjfosdoifjwoiejfoiwejfoiweuroiuweoiruwoieuroiweur");
      // print(tasks.toString());
    } catch (e) {
      print("download error");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Download Unsuccessful.\n$e"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }

    // setState(() {
    //   showProgress = false;
    // });
  }
  // Dio:
  // void downloadFile(String url, String fileName) async {
  //   if (await Permission.storage.request().isDenied ||
  //       await Permission.manageExternalStorage.request().isDenied) {
  //     print("Storage access Permission denied");
  //   }
  //   setState(() {
  //     showProgress = true;
  //   });
  //   String path = await getDownloadPath(fileName);
  //   try {
  //     await dio.download(
  //       url,
  //       path,
  //       deleteOnError: true,
  //       onReceiveProgress: (receivedBytes, totalBytes) {
  //         print("$fileName:->Progress=$progress");
  //         setState(() {
  //           progress = receivedBytes / totalBytes;
  //         });
  //       },
  //     ).then((value) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Download successfully completed.")));
  //       setState(() {
  //         doesFileExist = true;
  //         showProgress = false;
  //       });
  //     });
  //   } catch (e) {
  //     print("download error");
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Download Unsuccessful.\n$e"),
  //       backgroundColor: Theme.of(context).errorColor,
  //     ));
  //     setState(() {
  //       showProgress = false;
  //     });
  //   }
  // }

  Future<String> getDownloadPath(String fileName) async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return "${directory?.path}/$fileName";
  }

  Future<String> getDownloadFolderPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return "${directory?.path}";
  }

  void launchFile(String fileName) async {
    String path = await getDownloadPath(fileName);
    try {
      OpenFile.open(path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error opening file."),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    }
  }

  void checkIfFileExist(String fileName) async {
    String path = await getDownloadPath(fileName);
    await File(path).exists().then((doesExist) {
      setState(() {
        doesFileExist = doesExist;
      });
    });
  }

  Future<bool> checkIfFileExistBool(String fileName) async {
    bool result = false;
    String path = await getDownloadPath(fileName);
    result = await File(path).exists().then((doesExist) {
      setState(() {
        doesFileExist = doesExist;
      });
      return doesExist;
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'download_send_port');
    _port.listen(
      (dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int prog = data[2];
        setState(() {
          progress = prog / 100.0;
        });
      },
    );
    FlutterDownloader.registerCallback(downloadCallback);
    checkIfFileExist(widget.fileName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    IsolateNameServer.removePortNameMapping('download_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int prog) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('download_send_port')!;
    send.send([id, status, prog]);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showProgress = false;
        checkIfFileExist(widget.fileName);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //icon
                Container(
                  child: FileIcon(widget.fileName, size: 30),
                  // padding: EdgeInsets.all(0),
                ),
                SizedBox(
                  width: 15,
                ),
                //title + subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (widget.subtitle != null)
                          // ? Text(widget.fileName,
                          ? Text(widget.fileName,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ))
                          : SizedBox(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
                (widget.showDelete)
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete_forever_outlined,
                            color: Theme.of(context).errorColor),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                (doesFileExist)
                    ? IconButton(
                        //file exists
                        icon: Icon(Icons.open_in_new_outlined,
                            color: Theme.of(context).primaryColor),
                        onPressed: () => launchFile(widget.fileName),
                      )
                    : IconButton(
                        //file does not exist
                        onPressed: () =>
                            downloadFile(widget.url, widget.fileName),
                        icon: Icon(Icons.download_outlined,
                            color: Theme.of(context).focusColor),
                      ),

                //optional delete button
                //downloadbutton
              ],
            ),
          ),
          (widget.showDivider)
              ? Divider(
                  height: 2,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }
}
