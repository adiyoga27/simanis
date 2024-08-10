import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;
import 'package:simanis/app/core/app_config.dart';
import 'package:simanis/app/widgets/widget.dart';

import '../controllers/account_controller.dart';
import 'account.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final userController = Get.put(UserController());

    List<Map<String, dynamic>> options = [
      {
        'options': [
          [La.user, 'Detail Profil'],
        ]
      },
      {
        'title': 'Informasi',
        'options': [
          [La.infoCircle, 'Tentang SIMANIS App'],
          [La.fileSignature, 'Kebijakan Privasi'],
          [La.fileInvoice, 'Syarat & Ketentuan'],
          [La.star, 'Berikan Penilaian'],
          [La.comment, 'Kritik & Saran'],
          [La.phone, 'Kontak Kami']
        ]
      },
      {
        'title': 'Akun',
        'options': [
          [La.lock, 'Ganti Password'],
          [La.arrowLeft, 'Logout'],
        ]
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
       
      ),
      backgroundColor: Colors.white,
      body: Refreshtor(
        onRefresh: () async {
          // await userController.getUserCareer(setState: true);
          // controller.getProfile();
        },
        child: ListView(
            padding: Ei.only(t: 0, b: 100),
            physics: BounceScroll(),
            children: [
              Col(
                children: [
                  // const WiAccountProfile(),
                  Container(
                    padding: Ei.all(20),
                    child: Col(
                      children: List.generate(options.length, (i) {
                        String title = options[i]['title'] ?? '';
                        List childs = options[i]['options'];

                        return Container(
                            margin: Ei.only(t: 0),
                            child: Col(
                              children: [
                                title.isEmpty
                                    ? const None()
                                    : Textr(
                                        title,
                                        style:
                                            Gfont.bold.copyWith(fontSize: 20),
                                        padding: Ei.all(20),
                                        margin: Ei.only(t: 10),
                                      ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Br.all(),
                                      borderRadius: Br.radius(5)),
                                  child: ClipRRect(
                                    borderRadius: Br.radius(5),
                                    child: Col(
                                        children:
                                            List.generate(childs.length, (j) {
                                      IconData icon = childs[j][0];
                                      String label = childs[j][1];

                                      GlobalKey key =
                                          (childs[j] as List).length > 2
                                              ? childs[j][2]['key']
                                              : GlobalKey();

                                      return WiAccountOption(
                                        key: key,
                                        label: label,
                                        icon: icon,
                                        border: Br.only(['t'], except: j == 0),
                                      );
                                    })),
                                  ),
                                ),
                              ],
                            ));
                      }),
                    ),
                  ),
                  Container(
                    padding: Ei.only(t: 0, others: 20),
                    child: Col(children: [
                      Row(
                        mainAxisAlignment: Maa.center,
                        children: [
                          Textr('v${AppConfig.version} ${AppConfig.buildDate}',
                              style: Gfont.muted),
                          // Textr('#sehatkayabahagia', style: Gfont.muted)
                        ],
                      ),
                    ]),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
