part of 'account.dart';

class EditProfileView extends GetView<AccountUpdateController> {
  final Map<String, String?> data;
  const EditProfileView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
        child: FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 350)),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LzLoader.bar();
              }

              Forms.fill(controller.forms, data);

              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                  centerTitle: true,
                ),
                body: ListView(
                  physics: BounceScroll(),
                  padding: Ei.all(20),
                  children: [
                    Col(
                      children: [
                        TextInput(
                          label: 'NIK Ahli Waris *',
                          hint: 'Masukkan NIK ahli waris',
                          controller: controller.forms['nik_waris'],
                          formatters: [InputFormat.numeric],
                          keyboardType: Tit.number,
                          maxLength: 16,
                        ),
                        TextInput(
                          label: 'Nama Ahli Waris *',
                          hint: 'Masukkan nama ahli waris',
                          controller: controller.forms['waris'],
                        ),
                        RadioInput(
                            label: 'Hubungan *', options: const ['Suami', 'Istri', 'Anak', 'Lainnya'], controller: controller.forms['hubungan']),
                        TextInput(
                            label: 'NPWP',
                            hint: 'Masukkan nomor NPWP',
                            controller: controller.forms['npwp'],
                            formatters: [InputFormat.numeric],
                            keyboardType: Tit.number,
                            maxLength: 16),
                      ],
                    ),
                  ],
                ),
                bottomNavigationBar: LzButton(
                  text: 'Simpan',
                  onTap: (_) => controller.updateProfile(),
                ).dark().theme1(),
              );
            }));
  }
}
