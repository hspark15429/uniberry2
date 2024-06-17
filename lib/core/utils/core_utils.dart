import 'package:flutter/material.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:url_launcher/url_launcher.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.pink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static Future<void> launchWebpage(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw ServerException(
            message: 'Could not launch $url', statusCode: 505);
      }
    } on ServerException catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
