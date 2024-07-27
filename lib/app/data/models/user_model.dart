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
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role'] = this.role;
    data['token_type'] = this.tokenType;
    data['access_token'] = this.accessToken;
    data['avatar'] = this.avatar;
    data['expires_at'] = this.expiresAt;
    return data;
  }
}

