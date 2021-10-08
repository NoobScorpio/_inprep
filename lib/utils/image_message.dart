import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' show get;
import 'package:InPrep/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageMessage extends StatelessWidget {
  ImageMessage({this.sender, this.isMe, this.time, this.url, this.dark});
  final String sender;
  final String url;
  final bool isMe;
  final String time;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    // print("URL IN MESSAGE $url");
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
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          imageBuilder: (context, imageProvider) =>
                              BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                height: 500,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    image:
                                        DecorationImage(image: imageProvider)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.cancel_outlined)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          )),
                          errorWidget: (context, url, error) => Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          )),
                        ),
                      ));
            },
            child: Container(
              height: 200,
              child: Card(
                  elevation: 6,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () async {
                              try {
                                final status =
                                    await Permission.storage.request();
                                if (status.isGranted) {
                                  // showLoader(context);
                                  showToast(context, "Downloading Image");
                                  String name = "inPrep_" +
                                      "$sender" +
                                      "_${time.split(" ")[0]}.jpg";
                                  var imageId =
                                      await ImageDownloader.downloadImage(
                                    url,
                                  );
                                  showToast(context, "Image downloaded");
                                  // Navigator.pop(context);
                                  // var dir;
                                  // if (Platform.isIOS)
                                  //   dir =
                                  //       await getApplicationDocumentsDirectory();
                                  //
                                  // String name = "inPrep_" +
                                  //     "$sender" +
                                  //     "_${time.split(" ")[0]}.jpg";
                                  // var response =
                                  //     await get(Uri.parse(url)); // <--2
                                  //
                                  // var firstPath =
                                  //     "/storage/emulated/0/Download/InPrep";
                                  // var filePathAndName = firstPath + '/$name';
                                  // await Directory(
                                  //         Platform.isIOS ? dir.path : firstPath)
                                  //     .create(recursive: true); // <-- 1
                                  // File file2 = new File(Platform.isIOS
                                  //     ? "${dir.path}/$name"
                                  //     : filePathAndName); // <-- 2
                                  // file2.writeAsBytesSync(response.bodyBytes);
                                  //
                                  // if (Platform.isIOS) {
                                  //   showToast(context,
                                  //       "Downloading at ${dir.path}/$name");
                                  //   print("Downloading at ${dir.path}/$name");
                                  // } else
                                  //   showToast(context,
                                  //       "Downloading at /storage/emulated/0/Download/$name");
                                  // // print("Downloading at ${testDir.path}");

                                } else {
                                  showToast(
                                      context, "Storage permission denied");
                                }
                              } catch (e) {
                                showToast(context, "Could not download file");
                                Navigator.pop(context);
                                print("DOWNLOAD ERROR $e");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          height: 200,
                          width: 200,
                          child: Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.white30,
                          ))),
                      errorWidget: (context, url, error) => Container(
                          height: 200,
                          width: 200,
                          child: Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.white30,
                          ))),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            child: Text(
              time,
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
