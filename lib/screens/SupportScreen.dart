import 'dart:io';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController email, text;
  String username = 'inprepinfo@gmail.com';
  String password = '1n5tallm3';
  var smtpServer;
  final GlobalKey<ScaffoldState> globKeySupport =
      new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    globKeySupport.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    text = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globKeySupport,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Support',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    MyTextFormField(
                      controller: email,
                      labelText: 'Email',
                      hint: "Enter your email.",
                      onChanged: (text) {},
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextFormField(
                      maxline: 6,
                      controller: text,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Description',
                      hint: "Enter what do you want help in ?",
                      onChanged: (text) {},
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        height: 40,
                        width: 120,
                        child: RaisedButton(
                          onPressed: () async {
                            showSnack("Sending Email");
                            final google = GoogleSignIn(
                                scopes: ['https://mail.google.com/']);
                            // if (await google.isSignedIn()) {
                            //   print("IS SIGNED IN");
                            //   final user = google.currentUser;
                            //   if (user == null) {
                            //     print("IS SIGNED IN NULL");
                            //     showSnack("Could not send email");
                            //   } else {
                            //     final auth = await user.authentication;
                            //     smtpServer = gmailSaslXoauth2(
                            //         user.email, auth.accessToken);
                            //   }
                            // } else {
                            //   print("IS NOT SIGNED IN");
                            //
                            // }
                            final user = await google.signIn();
                            if (user == null) {
                              print("IS NOT SIGNED IN NULL");
                              showSnack("Could not send email");
                            } else {
                              final auth = await user.authentication;
                              smtpServer = gmailSaslXoauth2(
                                  user.email, auth.accessToken);
                            }
                            final message = Message()
                              ..from = Address(username, 'InPrep')
                              ..recipients.add('inprepinfo@gmail.com')
                              ..subject = 'InPrep Support'
                              ..text = '${text.text}'
                              ..html =
                                  "<h1>Support</h1>\n<p>Hey! ${email.text} need support </p>\n"
                                      "${text.text}";
                            print("AFTER MSG");
                            try {
                              final sendReport =
                                  await send(message, smtpServer);
                              print("AFTER sent");
                              //print('Message sent: ' + sendReport.toString());
                              showSnack("Email Sent!");
                            } catch (e) {
                              print('Message not sent.$e');
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: Center(
                              child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
