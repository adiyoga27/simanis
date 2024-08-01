import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';

class DashboardController extends GetxController {
  RxDouble headerHeight = 370.0.obs;
  RxDouble appbarOpacity = 1.0.obs;
  double height = 370;
  RxBool isLoading = true.obs;
  
  void onScroll(Scroller scroll) async {
    double pixels = scroll.pixels;

    if (pixels >= 0) {
      headerHeight.value = (height - pixels.abs()).clamp(10, height + 50);
    } else {
      headerHeight.value = height + pixels.abs();
    }

    if (pixels < 0) {
      appbarOpacity.value = scroll.opacity(30, ScrollOpacity.bottom10);
    } else {
      appbarOpacity.value = scroll.opacity(50, ScrollOpacity.top10);
    }
  }

  Future onAppInit() async {
    isLoading.value = true;
    // Toasts.show('Loading data...');
      Timer(2.s, () {
        Toasts.dismiss();
      });
    // if selected client is empty, show dialog
   
    isLoading.value = false;
  }

@override
  void onInit() {
    super.onInit();
    onAppInit();
    // isLoading.value = false;

  }


}


/// Utility class for handling scrolling operations with a [ScrollController].
class Scroller {
  /// The scroll controller for the list.
  final ScrollController controller;

  /// The scroll direction.
  final ScrollDirection direction;

  /// Creates a [Scroller] instance with the provided [controller] and [direction].
  Scroller({required this.controller, required this.direction});

  /// Checks if the list is scrolled to the bottom.
  ///
  /// Returns true if the current scroll position plus [offset] is greater than or equal to
  /// the maximum scroll extent of the list.
  bool atBottom([double offset = 0]) {
    return controller.position.pixels + offset >=
        controller.position.maxScrollExtent;
  }

  /// Calculates the opacity value based on the current scroll position.
  ///
  /// The [factor] parameter adjusts the speed of opacity changes. Lower values make opacity change faster.
  ///
  /// Setting [invertOpacity] to true will invert the opacity value.
  /// - When true, the opacity decreases as the scroll position increases.
  /// - When false, the opacity increases as the scroll position increases.
  double getOpacity([double factor = 100, bool invertOpacity = true]) {
    double value = (controller.position.pixels / (factor < 1 ? 1 : factor));
    return (invertOpacity ? (1 - value) : value).clamp(0, 1);
  }

  /// Retrieves the current scroll position in pixels.
  double get pixels => controller.position.pixels;

  /// Retrieves the max scroll position.
  double get max => controller.position.maxScrollExtent;

  /// Calculates the opacity value based on the current scroll position.
  ///
  /// The [factor] parameter adjusts the speed of opacity changes. Lower values make opacity change faster.
  ///
  /// The [type] parameter determines the type of opacity calculation:
  /// - [ScrollOpacity.top01]: Opacity increases from 0 to 1 as you scroll from top to bottom.
  /// - [ScrollOpacity.top10]: Opacity decreases from 1 to 0 as you scroll from top to bottom.
  /// - [ScrollOpacity.bottom01]: Opacity increases from 0 to 1 as you scroll from bottom to top.
  /// - [ScrollOpacity.bottom10]: Opacity decreases from 1 to 0 as you scroll from bottom to top.
  ///
  /// Returns a double value representing the opacity, clamped between 0 and 1.
  ///
  /// Example usage:
  /// ```dart
  /// double opacityValue = scroller.opacity(factor: 50, type: ScrollOpacity.top01);
  /// ```
  ///
  /// [factor] defaults to 100 if not provided.
  /// [type] defaults to [ScrollOpacity.top01] if not provided.
  double opacity(
      [double factor = 100, ScrollOpacity type = ScrollOpacity.top01]) {
    double pixels = controller.position.pixels;
    double value = (pixels / (factor < 1 ? 1 : factor));

    // scroll to top start from 0 - 1
    double scrollTop01 = value.clamp(0, 1);

    // scroll to top start from 1 - 0
    double scrollTop10 = 1 - value.clamp(0, 1);

    // scroll to bottom start from 0 - 1
    double scrollBottom01 = value > 0 ? 0 : value.abs().clamp(0, 1);

    // scroll to bottom start from 1 - 0
    double scrollBottom10 = value > 0 ? 1 : 1 - value.abs().clamp(0, 1);

    final results = {
      ScrollOpacity.top01: scrollTop01,
      ScrollOpacity.top10: scrollTop10,
      ScrollOpacity.bottom01: scrollBottom01,
      ScrollOpacity.bottom10: scrollBottom10,
    };

    return results[type] ?? scrollTop01;
  }
}

enum ScrollOpacity {
  /// Opacity increases from 0 to 1 as you scroll from top to bottom.
  top01,

  /// Opacity decreases from 1 to 0 as you scroll from top to bottom.
  top10,

  /// Opacity increases from 0 to 1 as you scroll from bottom to top.
  bottom01,

  /// Opacity decreases from 1 to 0 as you scroll from bottom to top.
  bottom10
}