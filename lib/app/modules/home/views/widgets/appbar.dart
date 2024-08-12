import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/app/modules/login/controllers/login_controller.dart';
import 'package:simanis/app/routes/app_pages.dart';


class Appbar extends GetView<DashboardController> {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        top: 0,
        child: FutureBuilder(
          future: Auth.user(),
          builder: (_, snap) {
            String name = snap.data?.name ?? '';

            return Obx(() => Opacity(
                  opacity: controller.appbarOpacity.value,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: context.width,
                      padding: Ei.only(
                          h: 20, b: 10, t: context.viewPadding.top + 10),
                      child: Row(
                        mainAxisAlignment: Maa.spaceBetween,
                        crossAxisAlignment: Caa.center,
                        children: [
                          Row(
                            
                            children: [
                              InkWell(
                                onTap: ()=> Get.toNamed(Routes.ACCOUNT),
                                child:  LzImage('profile.png',
                                    size: 45, radius: 50),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  mainAxisAlignment: Maa.start,
                                  crossAxisAlignment: Caa.start,
                                  children: [
                                    Text('Hello', style: Gfont.fs14.white),
                                    Text(name,
                                        style: Gfont.white,
                                        overflow: Tof.ellipsis),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children:
                                [Ti.logout].generate((icon, i) {
                              final key = GlobalKey();

                              return Touch(
                                key: key,
                                onTap: () {
                                    Get.dialog(
                                      LzConfirm(
                                            title: 'Logout from App',
                                            confirmText: 'Ya, Logout',
                                            message:
                                                'Are you sure want to logout from this account?',
                                            onConfirm: () {
                                                final LoginController c = Get.put(LoginController());
                                                c.logout();
                                          })
                                    );
                                     
                                },
                                // hoverable: true,
                                child: Container(
                                  margin: Ei.only(l: 10),
                                  padding: Ei.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle),
                                  child: Icon(icon, color: Colors.white),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                )).lz.clip();
          },
        ));
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