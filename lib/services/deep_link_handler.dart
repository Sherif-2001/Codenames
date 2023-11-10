import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class DeepLinkHandler {
  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      print("The link sent to you is: $initialLink");
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
