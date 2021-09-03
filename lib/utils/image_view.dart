import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final url;
  ImageView({this.url});
  @override
  _ImageViewState createState() => _ImageViewState(url:url);
}

class _ImageViewState extends State<ImageView> {
  final url;
  _ImageViewState({this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
                            fit: BoxFit.fill,
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
                  ),
    );
  }
}