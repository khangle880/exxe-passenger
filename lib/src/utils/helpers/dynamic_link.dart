import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../../config/routes.dart';

class DynamicLink {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  static final DynamicLink _singleton = DynamicLink._internal();

  static DynamicLink get instance => _singleton;

  DynamicLink._internal();

  void initDynamicLinks(BuildContext context) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri deeplink = dynamicLinkData.link;
      Navigator.pushNamed(context, Routes.login);
      handleMyLink(deeplink);
    }).onError((error) {
      log('onLink error');
      log(error.message);
    });
  }

  void handleMyLink(Uri uri) async {
    List<String> separatedLink = [];

    /// exxe.page.link/Hello --> exxe.page.link and Hello
    separatedLink.addAll(uri.path.split('/'));

    log("Got uri: $uri");
    log("DocId: ${separatedLink[1]}");
  }

  Future<String> createDynamicLink(String prefixUrl, String subLink,
      {bool? short}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: prefixUrl,
      link: Uri.parse('$prefixUrl/$subLink'),
      androidParameters: const AndroidParameters(
        packageName: "com.exxe.passenger",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
    );
    Uri uri;
    if (short ?? true) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      uri = shortLink.shortUrl;
    } else {
      uri = await dynamicLinks.buildLink(parameters);
    }
    return uri.toString();
  }

  Future<String> createVnpayDynamicLink(String subLink, {bool? short}) {
    String prefixUrl = "https://exxepassengervnpay.page.link";
    return createDynamicLink(prefixUrl, subLink, short: short);
  }
}
