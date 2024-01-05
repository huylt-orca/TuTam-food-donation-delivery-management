class ActivityRole {
  ActivityRole({
    required this.id,
    required this.name,
    required this.description,
    required this.isDefault,
    required this.status,
    required this.activityId,
  });
  late final String id;
  late final String name;
  late final String description;
  late final bool isDefault;
  late final String status;
  late final String activityId;
  
  ActivityRole.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    isDefault = json['isDefault'] ?? '';
    status = json['status'] ?? '';
    activityId = json['activityId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isDefault'] = isDefault;
    data['status'] = status;
    data['activityId'] = activityId;
    return data;
  }
}