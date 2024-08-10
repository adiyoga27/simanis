part of 'account.dart';

class EditProfileView extends GetView<AccountUpdateController> {
  final Map<String, String?> data;
  const EditProfileView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;

    return Wrapper(
        child: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 350)),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LzLoader.bar();
              }


              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                  centerTitle: true,
                ),
                body: LzFormList(
            style: LzFormStyle(activeColor: LzColors.dark),
            children: [
              LzFormGroup(
                label: 'Data Member',
                prefixIcon: La.user,
                children: [
                  LzForm.input(
                      label: 'Nama Lengkap *',
                      hint: 'Masukkan nama lengkap',
                      model: forms['name']),
                  LzForm.input(
                      label: 'Tanggal Lahir *',
                      hint: 'Masukkan tanggal lahir',
                      model: controller.forms['birthdate'],
                      suffixIcon: La.calendar,
                      onTap: (model) {
                        // Maksimal umur 18 tahun
                        DateTime now = DateTime.now(),
                            max = DateTime(now.year - 18, now.month, now.day);
                        DateTime dateTime =
                            model.text.isEmpty ? max : model.text.toDate();

                        LzPicker.datePicker(context,
                                initialDate: dateTime,
                                minDate: DateTime(1920),
                                maxDate: max)
                            .then((value) {
                          if (value != null) {
                            model.text = value.format('dd-MM-yyyy');
                          }
                        });
                      }),
                  LzForm.radio(
                      label: 'Jenis Kelamin *',
                      initValue: const Option(option: 'Laki-laki'),
                      options: ['Laki-laki', 'Perempuan']
                          .generate((data, i) => Option(option: data)),
                      model: forms['jk']),
                  LzForm.input(
                      label: 'Telp',
                      hint: 'Masukkan nomor telp',
                      keyboard: Tit.number,
                      maxLength: 15,
                      model: forms['phone']),
                ],
              ),
              LzFormGroup(
                label: 'Alamat *',
                prefixIcon: La.mapMarked,
                sublabel:
                    'Tap icon di samping alamat untuk mengambil lokasi dan mengisi alamat secara otomatis.',
                children: [
                  LzForm.input(
                      label: 'Alamat Lengkap *',
                      hint: 'Masukkan alamat lengkap',
                      model: forms['address'],
                      maxLines: 2,
                      maxLength: 150,
                      suffix: LzInputicon(
                        icon: La.mapMarked,
                        onTap: () {
                          Get.bottomSheet(AutoFillAddress(
                            onTap: (state) {
                              controller.setByMyLocation(state);
                            },
                          ));
                        },
                      )),
                  ...List.generate(3, (i) {
                    List<String> keys = ['provinsi', 'kota', 'kecamatan'];

                    return LzForm.select(
                      label: '${keys[i].ucwords} *',
                      hint: 'Pilih ${keys[i]}',
                      model: forms[keys[i]],
                      onTap: controller.onTap,
                      onSelect: controller.onSelect
                    );
                  }),
                  LzForm.input(
                      label: 'Kelurahan *',
                      hint: 'Masukkan nama kelurahan',
                      model: forms['kelurahan']),
                  LzForm.input(
                      label: 'Kode Pos',
                      hint: 'Masukkan kode pos',
                      model: forms['kode_pos'],
                      maxLength: 5,
                      keyboard: Tit.number),
                ],
              ),
              LzFormGroup(
                label: 'Kesehatan',
                prefixIcon: La.userTie,
                children: [
                  LzForm.radio(
                      label: 'Perokok *',
                      initValue: const Option(option: 'Laki-laki'),
                      options: ['Merokok', 'Tidak Merokok']
                          .generate((data, i) => Option(option: data)),
                      model: forms['is_smoke']),
                  LzForm.input(
                    label: 'Riwayat Penyakit',
                    hint: 'Masukkan nama riwayat penyakit jika ada',
                    model: forms['medical_history'],
                  ),
                ],
              ),
              LzFormGroup(
                label: 'Akun *',
                sublabelStyle: SublabelStyle.card,
                prefixIcon: La.lock,
                children: [
                   LzForm.input(
                      label: 'Email *',
                      hint: 'Masukkan email ',
                      model: forms['email']),
                ],
              ),
            ]),
                bottomNavigationBar: LzButton(
                  text: 'Simpan',
                  onTap: (_) => controller.updateProfile(),
                ).dark().theme1(),
              );
            }));
  }
}
