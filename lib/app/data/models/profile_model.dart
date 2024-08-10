
class ProfileModel {
    int? id;
    String? name;
    String? email;
    DateTime? emailVerifiedAt;
    String? username;
    String? role;
    dynamic avatar;
    DateTime? birthdate;
    String? phone;
    String? jk;
    int? isSmoke;
    String? medicalHistory;
    String? province;
    String? city;
    String? subdistrict;
    String? village;
    String? address;
    String? kodePos;
    DateTime? createdAt;
    DateTime? updatedAt;

    ProfileModel({
        this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.username,
        this.role,
        this.avatar,
        this.birthdate,
        this.phone,
        this.jk,
        this.isSmoke,
        this.medicalHistory,
        this.province,
        this.city,
        this.subdistrict,
        this.village,
        this.address,
        this.kodePos,
        this.createdAt,
        this.updatedAt,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        username: json["username"],
        role: json["role"],
        avatar: json["avatar"],
        birthdate: DateTime.parse(json["birthdate"]),
        phone: json["phone"],
        jk: json["jk"],
        isSmoke: json["is_smoke"],
        medicalHistory: json["medical_history"],
        province: json["province"],
        city: json["city"],
        subdistrict: json["subdistrict"],
        village: json["village"],
        address: json["address"],
        kodePos: json["kode_pos"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt!.toIso8601String(),
        "username": username,
        "role": role,
        "avatar": avatar,
        "birthdate": "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "jk": jk,
        "is_smoke": isSmoke,
        "medical_history": medicalHistory,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "village": village,
        "address": address,
        "kode_pos": kodePos,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
