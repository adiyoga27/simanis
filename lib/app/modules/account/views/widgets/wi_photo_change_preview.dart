part of '../account.dart';


class WiPhotoChangePreview extends StatelessWidget {
  final String path;
  const WiPhotoChangePreview(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      padding: Ei.zero,
      children: [
        Center(
          child: Container(
            padding: Ei.all(7),
            margin: Ei.only(t: 50),
            decoration:
                BoxDecoration(border: Br.all(color: AppColor.primary.withOpacity(.3), width: 2), color: Colors.white, borderRadius: Br.radius(200)),
            child: LzImage(
              path,
              size: 200,
              fit: BoxFit.cover,
              radius: 200,
            ),
          ),
        ),
        Container(
          margin: Ei.only(t: 60),
          child: Intrinsic(
            children: List.generate(2, (i) {
              return Expanded(
                child: InkTouch(
                  onTap: () {
                    Get.back(result: i == 1);
                  },
                  padding: Ei.all(20),
                  color: i == 0 ? Utils.hex('f1f1f1') : Colors.white,
                  child: Text(
                    ['Batal', 'Simpan'][i],
                    textAlign: Ta.center,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
