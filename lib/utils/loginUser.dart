import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool> loginUserState(context, user) async {
  var db = DatabaseService();
  DocumentSnapshot userDoc = await db.userCollection.doc(user.uid).get();
  MyUser usr = MyUser.fromJson(userDoc.data());
  usr = await db.getCurrentUserProfile(usr.uid,
      seeker: usr.seeker, loggedin: true);
  bool userBool = await BlocProvider.of<UserCubit>(context).loginUser(usr);
  return userBool;
}
