import 'dart:ui';

import 'package:flutter/material.dart';
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
                                child: const LzImage('profile.png',
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
