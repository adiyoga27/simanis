import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';
import 'package:simanis/app/data/services/storage/storage.dart';

class AppConfig {
  /* ------------------------------------------------------------
  | Telegram Bot
  | */

  static const bool botActive = true;
  static const String botToken =
      '5935937070:AAEJZqlHTleJAwxFAiDknaii1F85oAve520';
  static const String botChatId = '-1002180107037'; // Varash Bot

  /* ------------------------------------------------------------
  | Server Base URL
  | */

  static const String baseUrl = 'https://simanis.codingaja.my.id/';

  /* ------------------------------------------------------------
  | Version
  | */

  static const String version = '1.0.0';
  static const String buildDate = '26072024.1'; 


  /* ------------------------------------------------------------
  | LazyUi Configuration
  | */

  static init() async {
    // initialize get storage
    await GetStorage.init();
    storage = GetStorage();

    // listen to firestore app config



    Utils.orientation(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    LzConfirm.config(cancel: 'Batal', confirm: 'Ya, Hapus');

    LazyUi.config(alwaysPortrait: true);

    Errors.config(
        botToken: botToken,
        chatId: botChatId,
        useBot: true,
        useList: true,
        errorBuilder: (ErrorInfo info) async {
          // Get user info
          final auth = await Auth.user();
          String name = auth.name ?? '-';
          String userId = ' - <code>${auth.username}</code>';

          // Errors
          List<String> errorList = [
            info.error,
            '',
            '<b>App, User & Device</b>',
            'Varash App, v$version $buildDate',
            '$name$userId, ${info.device ?? '-'}',
          ];

          if (info.networkError?.path != null) {
            errorList[0] = info.networkError!.path.toString();

            if (!['', null, 'null'].contains(info.networkError!.error)) {
              errorList.insert(1, info.networkError!.error ?? '-');
            }
          }

          Bot.sendMessage(errorList.join('\n'), botToken, botChatId);
        });
  }
}
