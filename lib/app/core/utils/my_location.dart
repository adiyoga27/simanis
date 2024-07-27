import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lazyui/lazyui.dart' hide Position;
import 'package:permission_handler/permission_handler.dart';
import 'package:simanis/app/core/utils/toast.dart';

class MyLocation {
  final String? postalCode, country, province, city, subdistrict, village, street, number;
  final double? latitude, longitude;

  MyLocation({
    this.postalCode,
    this.country,
    this.province,
    this.city,
    this.subdistrict,
    this.village,
    this.street,
    this.number,
    this.latitude,
    this.longitude,
  });

  factory MyLocation.fromJson(Map<String, dynamic> json) => MyLocation(
        postalCode: json["postal_code"],
        country: json["country"],
        province: json["province"],
        city: json["city"],
        subdistrict: json["subdistrict"],
        village: json["village"],
        street: json["street"],
        number: json["number"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "postal_code": postalCode,
        "country": country,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "village": village,
        "street": street,
        "number": number,
        "latitude": latitude,
        "longitude": longitude,
      };

  static Future get() async {
    try {
      // check and request permission
      if (await Permission.location.request().isDenied) {
        return Toasts.show('Anda harus mengizinkan akses lokasi untuk menggunakan fitur ini.');
      }

      // check location service
      if (!await Geolocator.isLocationServiceEnabled()) {
        return Toasts.show('Anda harus mengaktifkan layanan lokasi untuk menggunakan fitur ini.');
      }

      // get user location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        return MyLocation(
          postalCode: placemark.postalCode, // kode pos
          country: placemark.country, // negara
          province: placemark.administrativeArea, // provinsi
          city: placemark.subAdministrativeArea, // kota
          subdistrict: placemark.locality, // kecamatan
          village: placemark.subLocality, // kelurahan
          street: placemark.thoroughfare, // jalan
          number: placemark.subThoroughfare, // nomor
          latitude: position.latitude, // latitude
          longitude: position.longitude, // longitude
        );
      } else {
        return Toasts.show('Lokasi tidak ditemukan.');
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }
}
