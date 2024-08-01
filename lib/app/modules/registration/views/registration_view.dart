import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/theme/theme.dart';
import 'package:simanis/app/modules/registration/controllers/registration_controller.dart';
import 'package:simanis/app/ui/widgets/widget.dart';
import 'package:simanis/app/widgets/widget.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final forms = controller.forms;
    final info = GlobalKey();

    void openInfo() {
      LzPopup.show(info.currentContext!,
          child: Col(
            children: [
              Textr(
                'Info Registration',
                margin: Ei.only(b: 15),
                style: Gfont.bold,
              ),
              Text(
                'Silahkan lakukan Registartion agar dapat menggunakan fitur yang disediakan. Password minimal 8 karakter, terdiri dari huruf besar, huruf kecil, angka',
                style: Gfont.black,
              ),
            ],
          ),
          builder: (child) => child
              .onTap(() => Get.back())
              .animate()
              .moveY(begin: 30, duration: 150.ms)
              .then()
              .animate(onPlay: (c) => c.loop(reverse: true))
              .moveY(begin: 5, duration: 700.ms));
    }

    return Wrapper(
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.blueGrey[800],
          title: const Text('Member Baru'),
          actions: [
            IconButton(
                key: info,
                onPressed: () {
                  openInfo();
                },
                icon: const Icon(La.infoCircle)),
          ],
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
                  LzForm.input(
                      label: 'Username *',
                      hint: 'Masukkan username',
                      model: forms['username']),
                  LzForm.input(
                      label: 'Kata Sandi *',
                      hint: 'Masukkan kata sandi',
                      model: forms['password'],
                      obsecureToggle: true),
                  LzForm.input(
                      label: 'Konfirmasi Kata Sandi *',
                      hint: 'Konfirmasi kata sandi',
                      model: forms['passwordk'],
                      obsecureToggle: true),
                ],
              ),
            ]),
        bottomNavigationBar: LzButton(
          text: 'Daftar',
          onTap: (control) {
            controller.onSubmit();
          },
        ).dark().style(LzButtonStyle.shadow, spacing: 20),
      ),
    );
  }
}

class AutoFillAddress extends GetView<RegistrationController> {
  final Function(LzButtonControl state)? onTap;
  const AutoFillAddress({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
        padding: Ei.all(25),
        child: Column(
          children: [
            const Icon(
              La.mapMarked,
              size: 50,
            ),
            Textr(
              'Auto Fill Address',
              style: Gfont.fs20.bold,
              margin: Ei.sym(v: 15),
            ),
            const Text(
              'Isi alamat secara otomatis berdasarkan\nlokasi Anda saat ini.',
              textAlign: Ta.center,
            ).margin(b: 25),
            LzButton(
                    text: 'Periksa Lokasi',
                    icon: La.mapPin,
                    padding: Ei.sym(v: 15, h: 45),
                    radius: 50,
                    onTap: onTap)
                .dark()
          ],
        ));
  }
}
