class DeliveryRequestDetailUser {
  DeliveryRequestDetailUser({
    required this.id,
    required this.currentScheduledTime,
    required this.importedDate,
    required this.importNote,
    required this.proofImage,
    required this.avatar,
    required this.name,
    required this.phone,
    required this.isReported,
    required this.activityId,
    required this.activityName,
    required this.branchId,
    required this.branchName,
    required this.branchAddress,
    required this.branchImage,
    required this.deliveryItems,
  });
  late final String id;
  late final CurrentScheduledTime currentScheduledTime;
  late final String importedDate;
  late final String importNote;
  late final String proofImage;
  late final String avatar;
  late final String name;
  late final String phone;
  late bool isReported;
  late final String activityId;
  late final String activityName;
  late final String branchId;
  late final String branchName;
  late final String branchAddress;
  late final String branchImage;
  late final List<DeliveryItemsDetail> deliveryItems;
  
  DeliveryRequestDetailUser.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    currentScheduledTime = CurrentScheduledTime.fromJson(json['currentScheduledTime']);
    importedDate = json['importedDate'] ?? '';
    importNote = json['importNote'] ?? '';
    proofImage = json['proofImage'] ?? '';
    avatar = json['avatar'] ?? '';
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    isReported = json['isReported'] ?? '';
    activityId = json['activityId'] ?? '';
    activityName = json['activityName'] ?? '';
    branchId = json['branchId'] ?? '';
    branchName = json['branchName'] ?? '';
    branchAddress = json['branchAddress'] ?? '';
    branchImage = json['branchImage'] ?? '';
    deliveryItems = List.from(json['deliveryItems']).map((e)=>DeliveryItemsDetail.fromJson(e)).toList();
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
    data['isReported'] = isReported;
    data['activityId'] = activityId;
    data['activityName'] = activityName;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['branchAddress'] = branchAddress;
    data['branchImage'] = branchImage;
    data['deliveryItems'] = deliveryItems.map((e)=>e.toJson()).toList();
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

class DeliveryItemsDetail {
  DeliveryItemsDetail({
    required this.deliveryItemId,
    required this.name,
    required this.image,
    required this.unit,
    required this.confirmedExpirationDate,
    required this.assignedQuantity,
    required this.receivedQuantity,
    required this.importedQuantity,
  });
  late final String deliveryItemId;
  late final String name;
  late final String image;
  late final String unit;
  late final String confirmedExpirationDate;
  late final int assignedQuantity;
  late final int receivedQuantity;
  late final int importedQuantity;
  
  DeliveryItemsDetail.fromJson(Map<String, dynamic> json){
    deliveryItemId = json['deliveryItemId'];
    name = json['name'];
    image = json['image'];
    unit = json['unit'];
    confirmedExpirationDate = json['confirmedExpirationDate'];
    assignedQuantity = json['assignedQuantity'];
    receivedQuantity = json['receivedQuantity'];
    importedQuantity = json['importedQuantity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deliveryItemId'] = deliveryItemId;
    data['name'] = name;
    data['image'] = image;
    data['unit'] = unit;
    data['confirmedExpirationDate'] = confirmedExpirationDate;
    data['assignedQuantity'] = assignedQuantity;
    data['receivedQuantity'] = receivedQuantity;
    data['importedQuantity'] = importedQuantity;
    return data;
  }
}