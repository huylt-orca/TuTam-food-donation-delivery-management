class ActivityTask {
  ActivityTask({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.phaseId,
    required this.description,
    required this.activityRole,
  });
  late final String id;
  late final String name;
  late final String startDate;
  late final String endDate;
  late final String status;
  late final String description;
  late final String phaseId;
  late final List<ActivityRole> activityRole;
  
  ActivityTask.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    status = json['status'] ?? '';
    phaseId = json['phaseId'] ?? '';
    description = json['description']  ?? '';
    activityRole = json['activityRole'] == null ? List.empty() : List.from(json['activityRole']).map((e)=>ActivityRole.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['status'] = status;
    data['phaseId'] = phaseId;
    data['activityRole'] = activityRole.map((e)=>e.toJson()).toList();
    return data;
  }
}

class ActivityRole {
  ActivityRole({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });
  late final String id;
  late final String name;
  late final String description;
  late final String status;
  
  ActivityRole.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}