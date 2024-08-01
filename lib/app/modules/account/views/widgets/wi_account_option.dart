part of '../account.dart';

class WiAccountOption extends GetView<AccountController> {
  final String label;
  final IconData icon;
  final BoxBorder? border;
  final List<int> dangers;

  const WiAccountOption({Key? key, required this.label, required this.icon, this.border, this.dangers = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkTouch(
      onTap: () => onAction(context),
      color: Colors.white,
      child: Container(
        padding: Ei.sym(v: 18, h: 20),
        decoration: BoxDecoration(border: border),
        width: Get.width,
        child: Row(
          mainAxisAlignment: Maa.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                Textr(label, margin: Ei.only(l: 15)),
              ],
            ),
            const Icon(La.angleRight, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Future onAction(BuildContext context) async {
    switch (label) {
      case 'Detail Profil':
        WiAccountProfile.detail();
        break;

   
      case 'Tentang Varash App':
        Helpers.bottomSheet(const WiAboutApp(), dragable: true);
        break;

      case 'Kebijakan Privasi':
        Get.toNamed(Routes.WEBVIEW, arguments: Webview(title: label, url: 'https://reseller.saddannusantara.com/privacy-policy.php'));
        break;

      case 'Syarat & Ketentuan':
        Get.toNamed(Routes.WEBVIEW, arguments: Webview(title: label, url: 'https://reseller.saddannusantara.com/terms.php'));
        break;



      case 'Berikan Penilaian':
        Helpers.goto(Platform.isAndroid ? Values.playstore : Values.appstore);
        break;



      case 'Kontak Kami':
        Helpers.bottomSheet(const WiContact(), dragable: true);
        break;

      case 'Ganti Password':
        Helpers.bottomSheet(const ChangePasswordView());
        break;

      case 'Logout':
        Get.dialog(LzConfirm(
            title: 'Keluar Akun',
            message: 'Yakin ingin keluar dari akun ini?\nAnda dapat login kembali kapan saja dengan akun yang sama.',
            confirmText: 'Ya, Keluar',
            onConfirm: () {
               final LoginController c = Get.put(LoginController());
               c.logout();
            }));

        break;
      default:
    }
  }
}
