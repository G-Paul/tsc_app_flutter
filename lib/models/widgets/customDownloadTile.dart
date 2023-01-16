import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_file_plus/open_file_plus.dart';

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
  Dio dio = Dio();
  double progress = 0.0;
  bool showProgress = false;
  bool doesFileExist = false;

  void downloadFile(String url, String fileName) async {
    if (await Permission.storage.request().isDenied ||
        await Permission.manageExternalStorage.request().isDenied) {
      print("Storage access Permission denied");
    }
    setState(() {
      showProgress = true;
    });
    String path = await getDownloadPath(fileName);
    try {
      await dio.download(
        url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print("$fileName:->Progress=$progress");
          setState(() {
            progress = receivedBytes / totalBytes;
          });
        },
      ).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Download successfully completed.")));
        setState(() {
          doesFileExist = true;
          showProgress = false;
        });
      });
    } catch (e) {
      print("download error");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Download Unsuccessful.\n$e"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        showProgress = false;
      });
    }
  }

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

  void launchFile(String fileName) async {
    String path = await getDownloadPath(fileName);
    try {
      OpenFile.open(path);
    } catch (e) {
      print("File opening error");
      print(e);
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

  @override
  void initState() {
    super.initState();
    checkIfFileExist(widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border(
                  // top: BorderSide(
                  //     color: Theme.of(context).primaryColor.withOpacity(0.5),
                  //     width: 1),
                  // bottom: BorderSide(
                  //     color: Theme.of(context).primaryColor.withOpacity(0.5),
                  //     width: 1),
                  ),
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
                (showProgress)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            value: progress,
                          ),
                        ),
                      )
                    : (doesFileExist)
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
