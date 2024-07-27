part of account;

class ChangePasswordView extends GetView<AccountController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 350)),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return LzLoader.bar();
            }

            Forms.reset(controller.formsPassword);

            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Textr('Ganti Password'),
                centerTitle: true,
              ),
              body: Obx(() {
                bool obsecure = controller.obsecure.value;

                return ListView(
                  physics: BounceScroll(),
                  padding: Ei.all(20),
                  children: [
                    Col(
                      children: [
                        TextInput(
                            label: 'Password Lama *',
                            hint: 'Masukkan password lama',
                            obsecure: obsecure,
                            controller: controller.formsPassword['old_pass']),
                        TextInputGroup(
                          children: [
                            TextInput(
                                label: 'Password Baru *',
                                hint: 'Masukkan password baru',
                                obsecure: obsecure,
                                controller: controller.formsPassword['new_pass']),
                            TextInput(
                                label: 'Konfirmasi Password *',
                                hint: 'Masukkan konfirmasi password',
                                obsecure: obsecure,
                                controller: controller.formsPassword['confirm_pass']),
                          ],
                        ),
                        Textr(
                          'Password minimal 6 karakter terdiri dari huruf kapital, huruf kecil dan angka.',
                          style: Gfont.fs14.copyWith(color: Colors.orange),
                          margin: Ei.only(b: 10),
                        ),
                        TextInput.switches(
                            label: obsecure ? 'Tampilkan Password' : 'Sembunyikan Password',
                            initValue: !obsecure,
                            onSwitch: (_) {
                              controller.obsecure.toggle();
                            })
                      ],
                    ),
                  ],
                );
              }),
              bottomNavigationBar: LzButton(
                text: 'Simpan',
                onTap: (_) => controller.changePassword(),
              ).dark().theme1(),
            );
          }),
    );
  }
}
