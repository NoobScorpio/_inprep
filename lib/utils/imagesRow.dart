import 'package:flutter/material.dart';

class ImagesRow extends StatelessWidget {
  final img1, img2, img3;

  ImagesRow({this.img1, this.img2, this.img3});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (img1 == null)
          Icon(
            Icons.photo_outlined,
            color: Colors.grey,
            size: 50,
          ),
        if (img1 != null && img1.runtimeType != String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.file(img1),
            ),
          ),
        if (img1 != null && img1.runtimeType == String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.network(img1),
            ),
          ),
        if (img2 == null)
          Icon(
            Icons.photo_outlined,
            color: Colors.grey,
            size: 50,
          ),
        if (img2 != null && img2.runtimeType != String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.file(img2),
            ),
          ),
        if (img2 != null && img2.runtimeType == String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.network(img2),
            ),
          ),
        if (img3 == null)
          Icon(
            Icons.photo_outlined,
            color: Colors.grey,
            size: 50,
          ),
        if (img3 != null && img3.runtimeType != String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.file(img3),
            ),
          ),
        if (img3 != null && img3.runtimeType == String)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5)),
              height: 50,
              width: 50,
              child: Image.network(img3),
            ),
          ),
      ],
    );
  }
}
