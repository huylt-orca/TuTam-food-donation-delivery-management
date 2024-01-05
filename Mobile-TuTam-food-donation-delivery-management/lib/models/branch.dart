class Branch {
  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.createdDate,
    required this.status,
    required this.description,
    required this.location
  });
  late final String id;
  late final String name;
  late final String address;
  late final String image;
  late final String createdDate;
  late final String status;
  late final String description;
  late final List<double> location;
  late final String rejectingReason;
  
  Branch.fromJson(Map<String, dynamic> json){
    id = json['id']  ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    image = json['image'] ?? '';
    createdDate = json['createdDate'] ?? '';
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    location = json['location'] == null ? [] : List.castFrom<dynamic, double>(json['location']);
    rejectingReason = json['rejectingReason'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['image'] = image;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['description'] = description;
    return data;
  }

  static List<Branch> list = [
    Branch(id: '1', name: 'Tu tam Q1', address: 'adfs', image: 'image', createdDate: 'createdDate', status: 'status', description: '',location: [0,0]),
    Branch(id: '2', name: 'Tu tam Q2', address: 'adfs', image: 'image', createdDate: 'createdDate', status: 'status', description: '',location: [0,0]),
    Branch(id: '3', name: 'Tu tam Q3', address: 'adfs', image: 'image', createdDate: 'createdDate', status: 'status', description: '',location: [0,0]),
    Branch(id: '4', name: 'Tu tam Q4', address: 'adfs', image: 'image', createdDate: 'createdDate', status: 'status', description: '',location: [0,0]),
  ];
}