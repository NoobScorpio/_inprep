import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

String url = '';

class ImageCapture extends StatefulWidget {
  final uid;
  ImageCapture({this.uid});
  @override
  _ImageCaptureState createState() => _ImageCaptureState(uid: uid);
}

class _ImageCaptureState extends State<ImageCapture> {
  final uid;
  _ImageCaptureState({this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                  height: 400,
                  width: double.maxFinite,
                  child: Image.file(_imageFile)),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FlatButton(
                child: Icon(Icons.refresh),
                onPressed: _clear,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Uploader(file: _imageFile, uid: uid),
            )
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(),
        child: Icon(Icons.photo_library),
      ),
    );
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  File _imageFile;
  Future<bool> _pickImage() async {
    try {
      List<Media> media = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect, // currently for android
        ),
      );
      File selected = File(media[0].path);
      // _storage.bucket = 'gs://inprep-c8711.appspot.com';
      FirebaseStorage _storage;

      UploadTask _uploadTask;
      _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        _uploadTask =
            _storage.ref().child('images').child(fileName).putFile(selected);
      });

      _uploadTask.then((TaskSnapshot taskSnapshot) {
        taskSnapshot.ref.getDownloadURL().then((value) {
          url = value;
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final uid;
  Uploader({this.uid, this.file});
  @override
  _UploaderState createState() => _UploaderState(uid: uid);
}

class _UploaderState extends State<Uploader> {
  _UploaderState({this.uid});
  final uid;
  FirebaseStorage _storage;

  UploadTask _uploadTask;
  _startUpload() async {
    // _storage.bucket = 'gs://inprep-c8711.appspot.com';
    String filePath = 'images/${widget.file.path}';
    _storage =
        FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _uploadTask =
          _storage.ref().child('images').child(fileName).putFile(widget.file);
    });
    TaskSnapshot ts = _uploadTask.snapshot;
    // url = await ts.ref.getDownloadURL();
    // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // final Reference storageReference =
    //     FirebaseStorage.instance.ref().child('images/').child(fileName);
    // _uploadTask = storageReference.putFile(widget.file);
    _uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((value) {
        url = value;
      });
    });
    Navigator.pop(context, url ?? '');
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: _uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot?.data;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalBytes : 0;

          return Column(
            children: <Widget>[
              if (_uploadTask.snapshot.state.index == 2) Text('Completed'),
              LinearProgressIndicator(
                value: progressPercent,
              ),
            ],
          );
        },
      );
    } else {
      return GestureDetector(
        onTap: () {
          _startUpload();
        },
        child: Icon(
          Icons.send,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
