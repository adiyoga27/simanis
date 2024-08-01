import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/theme/theme.dart';
import 'package:simanis/app/core/utils/refrestordit.dart';
import 'package:simanis/app/core/utils/shortcut.dart';
import 'package:simanis/app/modules/home/controllers/dashboard_controller.dart';
import 'package:simanis/app/modules/home/views/widgets/appbar.dart';
import 'package:simanis/app/routes/app_pages.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> shortcuts = ['Screening Kaki', 'Pilar Tata Laksana', 'Farmakologi', 'Pemantauan Gula Darah' ];
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Stack(
        children: [
          const Header(),
          Refreshtordit(
            onRefresh: () => controller.onScroll,
            child: LzListView(
                padding: Ei.zero,
              scrollLimit: const [50, 150],
              children: [
                SizedBox(
                  height: 650,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: Maa.center,
                      children: [
                         Expanded(
                          child: Container(
                            padding: Ei.only(h: 20, t: 350 / 3),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: Maa.center,
                                children: [],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: Ei.all(35),
                          child: Column(children: [
                             const Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Textr(
                                  'Menu',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Column(
                                children: 
                                  shortcuts.generate((item, i) {
                                      List<String> icons = [
                                              'foot.png',
                                              'book.png',
                                              'medicine.png',
                                              'blood.png',
                                              ];
                                              return Container(
                                                margin: Ei.only(b: 5),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    Bx.shadow(Colors.black12,
                                                          y: 5, blur: 15)
                                                  ],
                                                      borderRadius: Br.radius(7)),
                                                      child: InkTouch(
                                                        onTap:  () {
                                                           if (i == 0) {
                                                              return Get.toNamed(
                                                                  Routes
                                                                      .HOME);
                                                            } else if (i == 1) {
                                                              Get.toNamed(Routes
                                                                  .EDUCATION);
                                                            } else if (i == 2) {
                                                              Get.toNamed(Routes
                                                                  .EDUCATION);
                                                            }else {
                                                              Get.toNamed(Routes
                                                                  .ACCOUNT);
                                                            }
                                                        },
                                                          padding: Ei.sym(v: 15, h: 15),
                                                    color: Colors.white,
                                                    radius: Br.radius(7),
                                                    child:  Padding(
                                                      padding:Ei.only( l: 10, r: 10),
                                                      child: Row(
                                                              children: [
                                                                
                                                                LzImage( icons[i], size: 45, radius: 50),
                                                                const SizedBox(width: 14),
                                                                Textr(item, style: const TextStyle(fontWeight: FontWeight.bold),
                                                                  ),
                                                              ],
                                                            ),
                                                    )
                                                      ),
                                              );
                                  })
                                ,
                              )
                            ],)
                          
                        )
                    ],),
                  ),
                )
              ],
            ),
          ),
        const Appbar()

        ],
      )
    );
  }
}

class Header extends GetView<DashboardController> {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Container(
              width: Get.width,
              height: controller.headerHeight.value,
              color: Colors.blueGrey,
              margin: Ei.only(b: 30),
            ),
            Positioned(
                bottom: 120,
                right: -70,
                child:
                    const Icon(Ti.fingerprint, color: Colors.white12, size: 250)
                        .lz
                        .rotate(25)),
            Positioned(
              bottom: 12,
              right: -10,
              left: -10,
              child: Container(
                width: Get.width,
                height: 30,
                color: Colors.blueGrey,
              ).lz.rotate(3),
            )
          ],
        ));
  }
}