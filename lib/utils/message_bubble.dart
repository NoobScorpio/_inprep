import 'dart:io' as Io;
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:InPrep/utils/loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender,
      this.text,
      this.isMe,
      this.time,
      this.dark,
      this.type,
      this.url});

  final String sender;
  final String text;
  final bool isMe;
  final int type;
  final String url;
  final time;
  final dark;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
            elevation: 5.0,
            color: isMe ? Theme.of(context).accentColor : Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          if (type == 3)
            InkWell(
              onTap: () async {
                try {
                  final status = await Permission.storage.request();
                  if (status.isGranted) {
                    showLoader(context);

                    // FlutterDownloader.registerCallback(callback);
                    final dir = await getExternalStorageDirectory();
                    //
                    // var testDir = Platform.isIOS
                    //     ? await getExternalStorageDirectory()
                    //     : await getExternalStorageDirectory();
                    // : await Io.Directory('/storage/emulated/0/inPrep')
                    //     .create(recursive: true);
                    // final Reference ref = FirebaseStorage.instance
                    //     .ref()
                    //     .child('files')
                    //     .child(widget.text);
                    // String name = "${testDir.path}/inPrep_${text}";

                    final taskId = await FlutterDownloader.enqueue(
                      url: url,
                      fileName: "inPrep_${text}",
                      savedDir: Platform.isIOS
                          ? dir.path
                          : "/storage/emulated/0/Download/",
                      showNotification:
                          true, // show download progress in status bar (for Android)
                      openFileFromNotification:
                          true, // click on notification to open downloaded file (for Android)
                    );

                    // final file = Io.File(name);
                    //
                    // await ref.writeToFile(file);
                    // showToast(context, "Downloaded inPrep-${testDir.path}");
                    // showToast(context, "Downloaded");
                    if (Platform.isIOS)
                      showToast(
                          context, "Downloading at ${dir.path}/inPrep_$text");
                    else
                      showToast(context,
                          "Downloading at /storage/emulated/0/Download/inPrep_$text");
                    // print("Downloading at ${testDir.path}");
                    Navigator.pop(context);
                  } else {}
                } catch (e) {
                  showToast(context, "Could not download file");
                  Navigator.pop(context);
                  print(e);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                child: Text(
                  "Tap to download",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            child: Text(
              time.toString(),
              style: TextStyle(
                color: dark ? Colors.white : Colors.black54,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
