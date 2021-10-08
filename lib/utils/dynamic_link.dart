import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkClass {
  static void initDynamicLinks(context, loggedIn) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      final Uri deepLink = data.link;
      handleDynamicLink(deepLink, context, loggedIn);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;
      if (deepLink != null) {
        handleDynamicLink(deepLink, context, loggedIn);
      }
    }, onError: (OnLinkErrorException e) async {
      print("DYNAMIC LINK ERROR ${e.message}");
    });
  }

  static void handleDynamicLink(Uri url, context, loggedIn) async {
    List<String> separated = [];
    separated.addAll(url.path.split("/"));

    if (url.path.contains("profile")) {
      print("DYNAMIC LINK ${separated.last}");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileView(
                  uid: separated.last, loggedIn: loggedIn, link: true)));
    }
  }
}
