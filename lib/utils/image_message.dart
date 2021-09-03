import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMessage extends StatelessWidget {
  ImageMessage({this.sender, this.isMe, this.time, this.url, this.dark});
  final String sender;
  final String url;
  final bool isMe;
  final String time;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    // print(url);
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
