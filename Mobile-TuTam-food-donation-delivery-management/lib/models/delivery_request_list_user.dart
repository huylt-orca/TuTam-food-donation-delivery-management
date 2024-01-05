class DeliveryRequestListUser {
  DeliveryRequestListUser({
    required this.id,
    required this.currentScheduledTime,
    required this.importedDate,
    required this.importNote,
    required this.proofImage,
    required this.avatar,
    required this.name,
    required this.phone,
  });
  late final String id;
  late final ScheduledTime currentScheduledTime;
  late final String importedDate;
  late final String importNote;
  late final String proofImage;
  late final String avatar;
  late final String name;
  late final String phone;

  
  DeliveryRequestListUser.fromJson(Map<String, dynamic> json){
    id = json['id'];
    currentScheduledTime = ScheduledTime.fromJson(json['currentScheduledTime']);
    importedDate = json['importedDate'];
    importNote = json['importNote'] ?? '';
    proofImage = json['proofImage'];
    avatar = json['avatar'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['currentScheduledTime'] = currentScheduledTime.toJson();
    data['importedDate'] = importedDate;
    data['importNote'] = importNote;
    data['proofImage'] = proofImage;
    data['avatar'] = avatar;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

class ScheduledTime {
  ScheduledTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  late String day;
  late String startTime;
  late String endTime;
  
  ScheduledTime.fromJson(Map<String, dynamic> json){
    day = json['day'] ?? '';
    startTime = json['startTime'] ?? '';
    endTime = json['endTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['day'] = day;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}