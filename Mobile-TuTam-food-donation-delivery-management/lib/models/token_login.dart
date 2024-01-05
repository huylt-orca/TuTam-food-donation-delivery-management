class TokenLogin {
  String? accessToken;
  String? role;
  String? refreshToken;

  TokenLogin({
    required this.accessToken,
    required this.role,
    required this.refreshToken,
  });

  
  TokenLogin.fromJson(Map<String, dynamic> json){
    accessToken = json['accessToken'];
    role = json['role'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['role'] = role;
    data['refreshToken'] = refreshToken;
    return data;
  }
}