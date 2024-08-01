class UserModel {
  int? id;
  String? name;
  String? username;
  String? email;
  String? role;
  String? tokenType;
  String? accessToken;
  Null? avatar;
  String? expiresAt;

  UserModel(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.role,
      this.tokenType,
      this.accessToken,
      this.avatar,
      this.expiresAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    avatar = json['avatar'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['avatar'] = avatar;
    data['expires_at'] = expiresAt;
    return data;
  }
}

