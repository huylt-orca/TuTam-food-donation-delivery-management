class BranchDetail {
  BranchDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.image,
    required this.createdDate,
    required this.status,
    required this.description,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String location;
  late final String image;
  late final String createdDate;
  late final String status;
  late final String description;
  
  BranchDetail.fromJson(Map<String, dynamic> json){
    id = json['id']?? '';
    name = json['name']?? '';
    address = json['address']?? '';
    location = json['location']?? '';
    image = json['image']?? '';
    createdDate = json['createdDate'] ?? '';
    status = json['status'] ?? '';
    description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['location'] = location;
    data['image'] = image;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['description'] = description;
    return data;
  }
}