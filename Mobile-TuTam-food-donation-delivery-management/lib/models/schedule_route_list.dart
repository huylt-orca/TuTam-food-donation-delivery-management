class ScheduleRouteList {
  ScheduleRouteList({
    required this.id,
    required this.numberOfDeliveryRequests,
    required this.scheduledTime,
    required this.orderedAddresses,
    required this.totalDistanceAsMeters,
    required this.totalTimeAsSeconds,
    required this.bulkyLevel,
    required this.type,
    required this.status,
  });
  late final String id;
  late final int numberOfDeliveryRequests;
  late final ScheduledTime scheduledTime;
  late final List<String> orderedAddresses;
  late final double totalDistanceAsMeters;
  late final double totalTimeAsSeconds;
  late final String bulkyLevel;
  late final String type;
  String status = '';

  static ScheduleRouteList data = ScheduleRouteList(
  id: '3eb8c3b1-4580-ee11-9f24-005056c00008', 
  numberOfDeliveryRequests: 4, 
  scheduledTime: ScheduledTime(
    day:"2023-12-05",
    startTime: "03:00",
    endTime: "08:00"
     ), 
  orderedAddresses: [ "Thủ Đức, Thành phố Hồ Chí Minh", "Khu Công nghệ cao, Quận 9" ], 
  totalDistanceAsMeters: 5599.799999999999, 
  totalTimeAsSeconds: 1000.763358778626, 
  bulkyLevel: "VERY_BULKY", 
  type: "IMPORT", 
  status: "PENDING" 
  );
  
  ScheduleRouteList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    numberOfDeliveryRequests = json['numberOfDeliveryRequests'];
    scheduledTime = ScheduledTime.fromJson(json['scheduledTime']);
    orderedAddresses = List.castFrom<dynamic, String>(json['orderedAddresses']);
    totalDistanceAsMeters = (json['totalDistanceAsMeters'] ?? 0).toDouble();
    totalTimeAsSeconds = (json['totalTimeAsSeconds'] ?? 0).toDouble();
    bulkyLevel = json['bulkyLevel'];
    type = json['type'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['numberOfDeliveryRequests'] = numberOfDeliveryRequests;
    data['scheduledTime'] = scheduledTime.toJson();
    data['orderedAddresses'] = orderedAddresses;
    data['totalDistanceAsMeters'] = totalDistanceAsMeters;
    data['totalTimeAsSeconds'] = totalTimeAsSeconds;
    data['bulkyLevel'] = bulkyLevel;
    data['type'] = type;
    data['status'] = status;
    return data;
  }
}

class ScheduledTime {
  ScheduledTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  late final String day;
  late final String startTime;
  late final String endTime;
  
  ScheduledTime.fromJson(Map<String, dynamic> json){
    day = json['day'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['day'] = day;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}

