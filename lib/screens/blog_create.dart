import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/user_bloc/userState.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlog extends StatefulWidget {
  final bool edit;
  final Blog blog;
  const CreateBlog({Key key, this.edit, this.blog}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  TextEditingController descController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descController = TextEditingController();
    if (widget.edit != null) {
      descController.text = widget.blog.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('Write a blog'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.09,
            child: Image.asset(
              "assets/images/bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              MyTextFormField(
                prefixIcon: Icon(
                  Icons.description_outlined,
                ),
                labelText: 'Write an attractive description',
                controller: descController,
                maxline: 10,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton:
          BlocBuilder<UserCubit, UserState>(builder: (_, state) {
        if (state is UserLoadedState) {
          return FloatingActionButton(
            onPressed: () async {
              if (descController.text != '') {
                showLoader(context);
                if (widget.edit == null) {
                  Blog blog = Blog(
                      uid: state.user.uid,
                      name: state.user.displayName,
                      desc: descController.text,
                      designation: state.user.design,
                      date: DateTime.now().toString().split(" ")[0],
                      time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                      timestamp: Timestamp.now(),
                      views: 0,
                      likes: [],
                      image: state.user.photoUrl,
                      comments: 0);
                  bool created = await DatabaseService().createBlog(blog: blog);
                  if (created) {
                    print("CREATED");
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  //EDIT
                  Blog blog = widget.blog;
                  blog.image = state.user.photoUrl;
                  blog.desc = descController.text;

                  try {
                    await DatabaseService.blogCollection
                        .doc(widget.blog.bid)
                        .update(blog.toJson());
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (e) {
                    Navigator.pop(context);
                  }
                }
              } else {
                showToast(context, "Write Something");
              }
            },
            child: Icon(Icons.done),
          );
        } else {
          return FloatingActionButton(
            onPressed: () async {},
            child: Icon(widget.edit == null ? Icons.edit : Icons.done),
          );
        }
      }),
    );
  }
}
