import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:simanis/app/core/theme/theme.dart';

import '../controllers/education_controller.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Pilar Tata Laksana'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomScrollView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                    child: Column(crossAxisAlignment: Caa.start, children: [
                  MasonryGrid(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      column: 2,
                      children: List.generate(4, (i) {
                        List<String> labels = ['Edukasi', 'TNM', 'Latihan Fisik', 'Perawatan Kaki'],
                            icons = ['svg/rating.svg','svg/rating.svg','svg/rating.svg','svg/rating.svg'];
                        // List<String> desc = ['Lihat promo kompetisi Anda.'];
          
                        return InkTouch(
                          onTap: () {
                            // switch (i) {
                            //   case 0:
                            //     Get.lazyPut<AchievementController>(
                            //       () => AchievementController(),
                            //     );
                            //     Helpers.bottomSheet(
                            //         const CompetitionPromoView());
                            //     break;
                            // }
                          },
                          color: Colors.white,
                          border: Br.all(),
                          padding: Ei.all(15),
                          radius: Br.radius(5),
                          child: Colr(
                            mainAxisAlignment: Maa.center,
                            crossAxisAlignment: Caa.center,
                            children: [
                              LzImage(icons[i], size: 60),
                              Textr(labels[i],
                                  style: Gfont.fs17, margin: Ei.only(t: 15)),
                              // Textr(desc[i],
                              //     style: Gfont.muted, margin: Ei.only(t: 5)),
                            ],
                          ),
                        );
                      }))
                ]))
              ]),
        ));
  }
}
