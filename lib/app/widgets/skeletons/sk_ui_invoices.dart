part of 'skeleton.dart';

class SkUiInvoices extends StatelessWidget {
  const SkUiInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BounceScroll(),
      padding: Ei.only(t: 15, l: 15, r: 15, b: 100),
      itemCount: 10,
      itemBuilder: (_, i) {
        return Container(
            margin: Ei.only(b: 15),
            width: Get.width,
            padding: Ei.all(15),
            decoration: BoxDecoration(color: Colors.white, border: Br.all()),
            child: Col(
              children: [
                const Skeleton(size: [100, 15]),
                Skeleton(size: const [100, 10], margin: Ei.only(t: 25)),
                Skeleton(size: const [100, 10], margin: Ei.only(t: 5)),
              ],
            ));
      },
    );
  }
}
