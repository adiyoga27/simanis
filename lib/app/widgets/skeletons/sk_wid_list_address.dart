part of skeleton;

class SkWidListAddress extends StatelessWidget {
  const SkWidListAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        decoration: BoxDecoration(border: Br.all(), color: Colors.white),
        child: Col(
          children: [
            Container(
              padding: Ei.only(l: 15, t: 10, b: 10, r: 15),
              child: const Row(
                mainAxisAlignment: Maa.spaceBetween,
                children:  [
                  Skeleton(size: [100, 15]),
                ],
              ),
            ),
            Col(
                children: List.generate(2, (i) {
              return Container(
                padding: Ei.all(15),
                decoration: BoxDecoration(border: Border(top: Br.side(i == 0 ? Colors.transparent : Colors.black12))),
                child: Row(
                  mainAxisAlignment: Maa.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Col(
                              children: [
                                const Skeleton(size: [100, 15]),
                                Skeleton(size: const [100, 15], margin: Ei.only(t: 5)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }))
          ],
        ));
  }
}
