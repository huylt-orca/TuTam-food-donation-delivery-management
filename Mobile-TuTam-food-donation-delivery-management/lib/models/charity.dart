class Charity {
  Charity({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.status,
    required this.logo,
    required this.description,
    required this.numberOfCharityUnits,
  });
  late final String id;
  late final String name;
  late final String createdDate;
  late final String status;
  late final String logo;
  late final String description;
  late final int numberOfCharityUnits;
  
  Charity.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    createdDate = json['createdDate'] ?? '';
    status = json['status'] ?? '';
    logo = json['logo'] ?? '';
    description = json['description'] ?? '';
    numberOfCharityUnits = json['numberOfCharityUnits'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['logo'] = logo;
    data['description'] = description;
    data['numberOfCharityUnits'] = numberOfCharityUnits;
    return data;
  }
}