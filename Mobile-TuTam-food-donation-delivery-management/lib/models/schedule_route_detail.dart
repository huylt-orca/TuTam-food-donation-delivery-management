class ScheduleRouteDetail {
  ScheduleRouteDetail({
    required this.id,
    required this.numberOfDeliveryRequests,
    required this.scheduledTime,
    required this.orderedDeliveryRequests,
    required this.totalDistanceAsMeters,
    required this.totalTimeAsSeconds,
    required this.bulkyLevel,
    required this.type,
    required this.status,
  });
  late final String id;
  late final int numberOfDeliveryRequests;
  late final ScheduledTime scheduledTime;
  late final List<OrderedDeliveryRequests> orderedDeliveryRequests;
  late final double totalDistanceAsMeters;
  late final double totalTimeAsSeconds;
  late final String bulkyLevel;
  late final String type;
  late final String status;
  late final bool isCancelable;
  
  ScheduleRouteDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    numberOfDeliveryRequests = json['numberOfDeliveryRequests'];
    scheduledTime = ScheduledTime.fromJson(json['scheduledTime']);
    orderedDeliveryRequests = List.from(json['orderedDeliveryRequests']).map((e)=>OrderedDeliveryRequests.fromJson(e)).toList();
    totalDistanceAsMeters = (json['totalDistanceAsMeters'] ?? 0).toDouble();
    totalTimeAsSeconds = (json['totalTimeAsSeconds'] ?? 0).toDouble();
    bulkyLevel = json['bulkyLevel'];
    type = json['type'];
    status = json['status'];
    isCancelable = json['isCancelable'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['numberOfDeliveryRequests'] = numberOfDeliveryRequests;
    data['scheduledTime'] = scheduledTime.toJson();
    data['orderedDeliveryRequests'] = orderedDeliveryRequests.map((e)=>e.toJson()).toList();
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

class OrderedDeliveryRequests {
  OrderedDeliveryRequests({
    required this.id,
    required this.address,
    required this.location,
    required this.currentScheduledTime,
    required this.avatar,
    required this.name,
    required this.phone,
    required this.deliveryItems,
    required this.status,
    required this.images,
  });
  late final String id;
  late final String address;
  late final List<double> location;
  CurrentScheduledTime? currentScheduledTime;
  late final String avatar;
  late final String name;
  late final String phone;
  List<DeliveryItems>? deliveryItems;
  late final List<String> images;
  late String? status;
  
  OrderedDeliveryRequests.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    address = json['address'];
    location = List.castFrom<dynamic, double>(json['location']);
    currentScheduledTime = json['currentScheduledTime'] == null ? null : CurrentScheduledTime.fromJson(json['currentScheduledTime']);
    avatar = json['avatar'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
    deliveryItems = json['deliveryItems'] == null ? null :  List.from(json['deliveryItems']).map((e)=>DeliveryItems.fromJson(e)).toList();
    images = json['images'] == null ? [] : List.castFrom<dynamic, String>(json['images'] ?? List.empty());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['location'] = location;
    data['currentScheduledTime'] = currentScheduledTime?.toJson();
    data['avatar'] = avatar;
    data['name'] = name;
    data['phone'] = phone;
    data['deliveryItems'] = deliveryItems?.map((e)=>e.toJson()).toList();
    return data;
  }
}

class CurrentScheduledTime {
  CurrentScheduledTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  late final String day;
  late final String startTime;
  late final String endTime;
  
  CurrentScheduledTime.fromJson(Map<String, dynamic> json){
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

class DeliveryItems {
  DeliveryItems({
    required this.deliveryItemId,
    required this.name,
    required this.image,
    required this.unit,
    required this.quantity,
    required this.receivedQuantity,
    required this.expiredDate,
  });
  late final String deliveryItemId;
  late final String name;
  late final String image;
  late final String unit;
  late final int quantity;
  late int? receivedQuantity;
  late final String expiredDate;
  
  DeliveryItems.fromJson(Map<String, dynamic> json){
    deliveryItemId = json['deliveryItemId'];
    name = json['name'];
    image = json['image'];
    unit = json['unit'];
    quantity = json['quantity'];
    receivedQuantity = json['receivedQuantity'];
    expiredDate = json['expiredDate'] ?? '2023-11-12';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['receivedQuantity'] = receivedQuantity ;
    return data;
  }
}