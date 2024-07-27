part of skeleton;

class SkUiShop extends StatelessWidget {
  const SkUiShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(physics: const NeverScrollableScrollPhysics(), cacheExtent: 9500, padding: Ei.only(others: 20, b: 100), children: [
      CustomScrollView(physics: const ScrollPhysics(), shrinkWrap: true, slivers: [
        SliverToBoxAdapter(
            child: Column(crossAxisAlignment: Caa.start, children: [
          MasonryGrid(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              column: 2,
              children: List.generate(10, (i) {
                return Container(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(border: Br.all(), borderRadius: Br.radius(5)),
                    child: Column(crossAxisAlignment: Caa.start, children: [
                      Skeleton(
                        size: [
                          Get.width,
                          const [100, 170]
                        ],
                        radiusOnly: CustomRadius(tlr: 5),
                      ),
                      Container(
                          padding: Ei.all(10),
                          child: Column(crossAxisAlignment: Caa.start, children: [
                            Column(
                              crossAxisAlignment: Caa.start,
                              children: [
                                const Skeleton(size: [
                                  [50, 100],
                                  15
                                ], radius: 5),
                                Skeleton(
                                    margin: Ei.only(t: 5),
                                    size: const [
                                      [50, 100],
                                      15
                                    ],
                                    radius: 5),
                              ],
                            ),
                          ])),
                    ]),
                  ),
                );
              }))
        ]))
      ])
    ]);
  }
}
