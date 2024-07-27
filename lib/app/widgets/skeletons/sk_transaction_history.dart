part of skeleton;

class SkTransactionHistory extends StatelessWidget {
  const SkTransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) {
        return Container(
            padding: Ei.sym(v: 15, h: 15),
            decoration: BoxDecoration(color: Colors.white, border: Br.except([i == 0 ? '' : 't'])),
            child: Row(mainAxisAlignment: Maa.spaceBetween, children: [
              Flexible(
                  child: Col(children: [
                const Skeleton(size: [100, 10]),
                Skeleton(size: const [
                  [50, 175],
                  10
                ], margin: Ei.only(t: 10)),
              ])),
              const Skeleton(size: [
                [50, 100],
                10
              ]),
            ]));
      }),
    );
  }
}
