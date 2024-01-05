class CharityUnit {
  CharityUnit({
    required this.name,
    required this.status,
    required this.email,
    required this.id,
    required this.phone,
    required this.description,
    required this.image,
    required this.legalDocuments,
    required this.location,
    required this.address,
    required this.updatedBy,
    required this.confirmBy,
    required this.createdDate,
  });
  late final String name;
  late final String status;
  late final String email;
  late final String id;
  late final String phone;
  late final String description;
  late final String image;
  late final String legalDocuments;
  late final String location;
  late final String address;
  late final String updatedBy;
  late final String confirmBy;
  late final String createdDate;
  late final int numberOfPost; 
  late final String charityId;
  
  CharityUnit.fromJson(Map<String, dynamic> json){
    name = json['name'] ?? '';
    status = json['status'] ?? '';
    email = json['email'] ?? '';
    id = json['id'] ?? '';
    phone = json['phone'] ?? '';
    description = json['description'] ?? '';
    image = json['image'] ?? '';
    legalDocuments = json['legalDocuments'] ?? '';
    location = json['location'] ?? '';
    address = json['address'] ?? '';
    updatedBy = json['updatedBy'] ?? '';
    confirmBy = json['confirmBy'] ?? '';
    createdDate = json['createdDate'] ?? '';
    numberOfPost = json['numberOfPost'] ?? 0;
    charityId = json['charityId'] ??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    data['email'] = email;
    data['id'] = id;
    data['phone'] = phone;
    data['description'] = description;
    data['image'] = image;
    data['legalDocuments'] = legalDocuments;
    data['location'] = location;
    data['address'] = address;
    data['updatedBy'] = updatedBy;
    data['confirmBy'] = confirmBy;
    data['createdDate'] = createdDate;
    data['charityId'] = charityId; 
    return data;
  }
}