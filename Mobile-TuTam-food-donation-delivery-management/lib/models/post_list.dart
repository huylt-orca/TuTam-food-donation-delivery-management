class PostList {
  PostList({
    required this.content,
    required this.id,
    required this.images,
    required this.createdDate,
    required this.status,
    required this.createBy,
  });
  late final String content;
  late final String id;
  late final List<String> images;
  late final String createdDate;
  late final String status;
  late final CreateBy createBy;
  
  PostList.fromJson(Map<String, dynamic> json){
    content = json['content'];
    id = json['id'];
    images = List.castFrom<dynamic, String>(json['images']);
    createdDate = json['createdDate'];
    status = json['status'];
    createBy = CreateBy.fromJson(json['createBy']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content;
    data['id'] = id;
    data['images'] = images;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['createBy'] = createBy.toJson();
    return data;
  }
}

class CreateBy {
  CreateBy({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.role,
    required this.phone,
    required this.email,
    required this.status,
  });
  late final String id;
  late final String fullName;
  late final String avatar;
  late final String role;
  late final String phone;
  late final String email;
  late final String status;
  
  CreateBy.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['role'] = role;
    data['phone'] = phone;
    data['email'] = email;
    data['status'] = status;
    return data;
  }
}