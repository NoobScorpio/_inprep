import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AppUtils {
  static Future<String> buildDynamicLink({uid, desc, image, name}) async {
    String url = "https://inprep.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse("$url/profile/$uid"),
      androidParameters: AndroidParameters(
        packageName: "com.inprep.inprep",
        minimumVersion: 21,
      ),
      iosParameters:
          IosParameters(bundleId: "com.iosinprep.inprep", minimumVersion: '0'),
      socialMetaTagParameters: SocialMetaTagParameters(
        description: desc,
        imageUrl: Uri.parse(image),
        title: name,
      ),
    );
    final dynamicLink = await parameters.buildUrl();
    return dynamicLink.toString();
  }
}
