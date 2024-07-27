import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lazyui/lazyui.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simanis/app/core/utils/toast.dart';

class Helpers {
  /// ```dart
  /// Helpers.copy('your content', message: 'Content has been copied!')
  /// ```
  static copy(String text, {String message = ''}) {
    Clipboard.setData(ClipboardData(text: text));
    if (message.trim().isNotEmpty) Toasts.show(message);
  }

  static isValidImageUrl(String url) {
    // https://domain.com/filename.jpg = true
    // https://domain.com/storage/filename.jpg = true
    // https://domain.com/storage/ = false

    // valid image is: jpg, jpeg, png, gif, svg, webp
    RegExp regExp = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/([\w-]+)\.(jpg|jpeg|png|gif|svg|webp)$');
    return regExp.hasMatch(url);
  }

  /// ```dart
  /// Helpers.bottomSheet(Container());
  /// ```
  static bottomSheet(Widget child, {Function()? onInit, Function(dynamic)? onClose, bool dragable = false}) {
    Utils.timer(() => Utils.setSystemUI(navBarColor: Colors.white), 50.ms);

    onInit?.call();
    Get.bottomSheet(child, isScrollControlled: true, enableDrag: dragable, ignoreSafeArea: false).then((value) {
      onClose?.call(value);
      Utils.timer(() => Utils.setSystemUI(navBarColor: Colors.white), 200.ms);
    });
  }

  /// ``` dart
  /// Helpers.goto('tel: 0810...')
  /// Helpers.goto('mailto: lipsum@gmail.com')
  /// Helpers.goto('https://google.com')
  /// ```
  static goto(String url) async => await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  /// ``` dart
  /// Helpers.openMap(-8.667138922071201, 115.21679636919626); // Denpasar City
  /// ```
  static openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await goto(googleUrl);
  }

  /// ``` dart
  /// Map res = await Helpers.downloadImageFromBytes(bytes, fileName: 'FileName');
  /// ```
  static Future<Map> downloadImageFromBytes(Uint8List imageBytes, {String? fileName}) async {
    Map map = {'ok': false, 'path': ''};

    try {
      //request storage permissions
      // Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();

      //  

      final result = await ImageGallerySaver.saveImage(imageBytes, quality: 90, name: fileName ?? '${DateTime.now().microsecondsSinceEpoch}');
        String path = result['filePath'];
        bool isOk = result['isSuccess'];

        map = {'ok': isOk, 'path': path};
    } catch (e, s) {
      Errors.check(e, s);
    }

    return map;
  }
}

class Utils2 {
  /// ``` dart
  /// List<String> list = ['a', 'b', 'c'];
  /// Utils2.indexOf(list, ['a', 'c']) // [0, 2]
  /// ```
  static indexOf(List a, List b) {
    List<int> index = [];
    for (int i = 0; i < a.length; i++) {
      if (b.contains(a[i])) {
        index.add(i);
      }
    }
    return index;
  }

  // Utils2.dataType(mitra['min_poin'], double);
  static dataType(dynamic value, Type type) {
    try {
      if (type == int) {
        return value is int ? value : int.parse(value.toString());
      } else if (type == double) {
        return value is double ? value : double.parse(value.toString());
      } else if (type == String) {
        return value.toString();
      } else if (type == bool) {
        return value is bool ? value : value == 1;
      } else {
        return value;
      }
    } catch (e) {
      return value;
    }
  }

  static Color luminanceTextColor(Color backgroundColor) {
    return LzColors.isDark(backgroundColor) ? Colors.white : Colors.black87;
  }

  // this function is to sort string to alphabet
  // ex: '490xaUi' => '049aiux'
  static String azSort(String text) {
    String result = '';

    try {
      List a = text.replaceAll(RegExp(r'\s+'), '').split('').map((e) => e.toLowerCase()).toList();
      a.sort((a, b) => a.compareTo(b));

      result = a.join();
    } catch (e, s) {
      Errors.check(e, s);
    }

    return result;
  }

  static void scrollToWidget(GlobalKey key, ScrollController controller, double screenWidth) {
    if (key.currentContext != null) {
      RenderBox box = key.currentContext?.findRenderObject() as RenderBox;

      // get width of widget
      double w = box.size.width;

      // get horizontal position of widget
      double dx = box.localToGlobal(Offset.zero).dx;

      // get max scroll of List
      double ms = controller.position.maxScrollExtent;

      // get pixel of scroll position
      double pixel = controller.position.pixels;

      // result, the center position of widget
      double pos = (pixel + dx) - (screenWidth / 2) + (w / 2);

      // scroll to position
      controller.animateTo(
          pos < 0
              ? 0
              : pos > ms
                  ? ms
                  : pos,
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease);
    }
  }
}
