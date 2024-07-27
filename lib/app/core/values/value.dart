library value;

import 'package:simanis/app/core/app_config.dart';

part 'strings.dart';

String version = '${AppConfig.version} ${AppConfig.buildDate}';

class MixShared {
  static const List<String> bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static const List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
}
