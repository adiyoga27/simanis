import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;
import 'package:simanis/app/modules/login/controllers/login_controller.dart';
import 'package:simanis/app/ui/widgets/widget.dart';
import 'package:simanis/app/widgets/widget.dart';

class ForgetPasswordView extends GetView<LoginController> {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      padding: Ei.all(20),
      child: Col(
        children: [
          Col(
            children: [
              Text(
                'Lupa Kata Sandi',
                style: Gfont.fs17.bold,
              ),
              Textr(
                'Silakan masukkan ID Member Anda untuk dapat menerima kode OTP.',
                margin: Ei.only(b: 25, t: 5),
                style: Gfont.muted,
              ),
              Container(
                padding: Ei.only(r: 3, l: 20),
                decoration: BoxDecoration(border: Br.all(color: LzColors.dark), borderRadius: Br.radius(100)),
                child: Row(
                  children: [
                    Expanded(
                      child: LzTextField(
                        hint: 'Masukkan ID member',
                        keyboard: Tit.number,
                        maxLength: 10,
                        autofocus: true,
                        formatters: [InputFormat.numeric],
                        // controller: controller.fpForms['username'],
                      ),
                    ),
                    LzButton(
                        text: 'Kirim OTP',
                        radius: 50,
                        padding: Ei.sym(v: 10, h: 30),
                        onTap: (state) {
                          // controller.requestOtp(state);
                        }).dark()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
