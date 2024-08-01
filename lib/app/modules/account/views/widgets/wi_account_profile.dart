part of '../account.dart';

class WiAccountProfile extends StatelessWidget {
  final Function()? onTapImage;
  const WiAccountProfile({Key? key, this.onTapImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Ei.sym(v: 50),
      width: Get.width,
      child: Column(
                  children: [
                    Touch(
                      onTap: onTapImage ??
                          () {
                            WiAccountProfile.detail();
                          },
                      child: Container(
                          margin: Ei.sym(v: 35),
                          width: 130,
                          height: 130,
                          padding: Ei.all(5),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Br.all(color: AppColor.primary, width: 1)),
                          child: ClipRRect(borderRadius: Br.circle, child: const LzImage("", fit: BoxFit.cover))),
                    ),
                    Column(
                      children: [
                        Textr("test", style: Gfont.bold.copyWith(fontSize: 20), textAlign: Ta.center, margin: Ei.only(b: 5)),
                      ],
                    ).padding(h: 10),
                  ],
                ),
    );
  }

  static detail() {
    Get.put(AccountDetailController());
    Helpers.bottomSheet(const DetailProfileView(), onClose: (_) {
      Get.delete<AccountDetailController>();
    });
  }
}
