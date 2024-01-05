class User {
  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.phone,
    required this.address,
    required this.location,
    required this.email,
    required this.collaboratorStatus,
  });
  late final String id;
  late final String name;
  late final String avatar;
  late final String phone;
  late final String location;
  late final String address;
  late final String email;
  late final bool collaboratorStatus;
  
  User.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    avatar = json['avatar'] ?? '';
    phone = json['phone'] ?? '';
    location = json['location'] ?? '0,0';
    address = json['address'] ?? '';
    email = json['email'] ?? '';
    collaboratorStatus = json['collaboratorStatus'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['location'] = location;
    data['address'] = address;
    data['email'] = email;
    data['collaboratorStatus'] = collaboratorStatus;
    return data;
  }
}