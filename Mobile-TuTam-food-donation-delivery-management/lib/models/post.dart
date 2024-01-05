class Post {
  Post({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.createdDate,
    required this.status,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String image;
  late final String createdDate;
  late final String status;
  
  Post.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    createdDate = json['createdDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['image'] = image;
    data['createdDate'] = createdDate;
    data['status'] = status;
    return data;
  }
}