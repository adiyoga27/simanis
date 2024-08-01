import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../controllers/education_controller.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          title: const Text('Pencapaian Anda'),
          centerTitle: true,
        ),
        body: ListView(physics: BounceScroll(), padding: Ei.all(20), children: [
          CustomScrollView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                    child: Column(crossAxisAlignment: Caa.start, children: [
                  MasonryGrid(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      column: 2,
                      children: List.generate(1, (i) {
                        List<String> labels = ['Promo Kompetisi'],
                            icons = ['svg/rating.svg'];
                        List<String> desc = ['Lihat promo kompetisi Anda.'];

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
                            children: [
                              LzImage(icons[i], size: 60),
                              Textr(labels[i],
                                  style: Gfont.fs17, margin: Ei.only(t: 15)),
                              Textr(desc[i],
                                  style: Gfont.muted, margin: Ei.only(t: 5)),
                            ],
                          ),
                        );
                      }))
                ]))
              ])
        ]));
  }
}
