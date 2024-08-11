part of 'account.dart';

class DetailProfileView extends GetView<AccountDetailController> {
  const DetailProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ImagePicker picker = ImagePicker();

    // void changePhoto() async {
    //   final pickedFile = await picker.pickImage(
    //     source: ImageSource.gallery,
    //     maxWidth: 2000,
    //     maxHeight: 2000,
    //     imageQuality: 90,
    //   );

    //   if (pickedFile != null) {
    //     File file = File(pickedFile.path);
    //     Get.dialog(WiPhotoChangePreview(file.path)).then((ok) {
    //       if (ok != null && ok) {
    //         controller.changePhoto(file);
    //       }
    //     });
    //   }
    // }

    final key = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                DropX.show(key,
                    useCaret: false,
                    options: ['Edit Profil'].options(icons: [La.user]),
                    onSelect: (value) async {
                  logg(value.index);
                  // if (value.index == 0) {
                  //   changePhoto();
                  // } else {
                  Map<String, String?> data = {
                    // 'nik_waris': controller.user.nikWaris,
                    // 'waris': controller.user.waris,
                    // 'hubungan': controller.user.hubungan,
                    // 'npwp': controller.user.npwp,
                  };

                  Get.put(AccountUpdateController());
                  Helpers.bottomSheet(EditProfileView(data: data),
                      dragable: true,
                      onClose: (_) => Get.delete<AccountUpdateController>());
                  // }
                });
              },
              icon: Icon(La.bars, key: key))
        ],
      ),
      body: Obx(() {
        bool isLoading = controller.isLoading.value;

        if (isLoading) {
          return LzLoader.bar(message: 'Memuat profil...');
        }

        ProfileModel data = controller.profile;

        List tiles = [
          {
            'label': 'Informasi Pribadi',
            'data': [
              ['Nama', data.name.orIf()],
              ['Jenis Kelamin', data.jk.orIf()],
              ['Username', data.username.orIf()],
            ]
          },
          {
            'label': 'Kontak',
            'data': [
              ['No. Telepon', data.phone.orIf()],
              ['Email', data.phone.orIf()],
              ['Kota/Kabupaten', data.city.orIf()],
              ['Kecamatan', data.subdistrict.orIf()],
              ['Kelurahan', data.village.orIf()],
              ['Alamat', data.address.orIf()],
              ['Kode Pos', data.kodePos.orIf()],
            ]
          },
          {
            'label': 'Kesehatan',
            'data': [
              ['Tinggi Badan', "${data.tall.orIf()} cm"],
              ['Berat Badan', "${data.weight.orIf()} kg"],
              ['Golongan Darah', data.blood.orIf()],

              ['Merokok', data.isSmoke.orIf() > 0 ? 'Ya' : 'Tidak'],
              ['Riwayat', data.medicalHistory.orIf()],
            ]
          },
        ];

        ScrollController scrollController = ScrollController();

        return Refreshtor(
          onRefresh: () => controller.getProfile(),
          child: ListView(
            physics: BounceScroll(),
            controller: scrollController,
            children: [
              // WiAccountProfile(
              //   onTapImage: () {
              //     changePhoto();
              //   },
              // ),
              // const WiAccountVerified(),
              Container(
                padding: Ei.all(20),
                child: Col(
                  children: List.generate(tiles.length, (i) {
                    Map item = tiles[i];
                    String label = item['label'];
                    List options = item['data'];
                    List<IconData> icons = [
                      La.user,
                      La.telegram,
                      La.bookMedical,
                      // La.userTag
                    ];
                    List<GlobalKey> keys = [
                      GlobalKey(),
                      GlobalKey(),
                      GlobalKey(),
                      GlobalKey()
                    ];

                    return StickyHeader(
                        header: InkTouch(
                          onTap: () {
                            Scrollable.ensureVisible(keys[i].currentContext!,
                                duration: const Duration(milliseconds: 300),
                                alignment: .19);
                          },
                          border: Br.all(),
                          color: Colors.white,
                          radius: Br.radius(5),
                          margin: Ei.only(t: 20, b: 5),
                          padding: Ei.sym(v: 15, h: 20),
                          child: Row(
                            mainAxisAlignment: Maa.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(icons[i]),
                                  Textr(
                                    label,
                                    margin: Ei.only(l: 15),
                                  ),
                                ],
                              ),
                              const Icon(
                                La.angleDown,
                                size: 17,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                        content: Container(
                          margin: Ei.only(b: 5),
                          key: keys[i],
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Br.all(color: AppColor.border),
                              borderRadius: Br.radius(5)),
                          child: Col(
                            children: List.generate(options.length, (j) {
                              List option = options[j];
                              String label = option[0];
                              String value =  option[1].toString();

                              bool danger = options[j].length > 2;
                              Color color =
                                  danger ? Colors.red : Colors.black87;

                              return Container(
                                padding: Ei.sym(v: 15, h: 20),
                                decoration: BoxDecoration(
                                    border: Br.only(['t'], except: j == 0)),
                                child: Row(
                                  children: [
                                    Col(
                                      children: [
                                        Text(
                                          label,
                                          style: Gfont.color(Colors.black54),
                                        ),
                                        Textr(
                                          value,
                                          margin: Ei.only(t: 5),
                                          style: Gfont.color(color),
                                        ),
                                      ],
                                    ).lz.flexible(),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ));
                  }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
