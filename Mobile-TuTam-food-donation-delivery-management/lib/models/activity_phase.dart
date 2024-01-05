class ActivityPhase {
  ActivityPhase({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.estimatedStartDate,
    required this.estimatedEndDate,
    required this.status,
    required this.activityId,
  });
  late final String id;
  late final String name;
  late final String startDate;
  late final String endDate;
  late final String estimatedStartDate;
  late final String estimatedEndDate;
  late final String status;
  late final String activityId;
  
  ActivityPhase.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    estimatedStartDate = json['estimatedStartDate'] ?? '';
    estimatedEndDate = json['estimatedEndDate'] ?? '';
    status = json['status'] ?? '';
    activityId = json['activityId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['estimatedStartDate'] = estimatedStartDate;
    data['estimatedEndDate'] = estimatedEndDate;
    data['status'] = status;
    data['activityId'] = activityId;
    return data;
  }
}