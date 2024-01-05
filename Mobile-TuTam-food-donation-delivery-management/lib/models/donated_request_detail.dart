import 'package:food_donation_delivery_app/models/branch.dart';

class DonatedRequestDetail {
  DonatedRequestDetail({
    required this.id,
    required this.address,
    required this.location,
    required this.images,
    required this.isConfirmable,
    required this.createdDate,
    required this.acceptedDate,
    required this.scheduledTimes,
    required this.status,
    required this.note,
    required this.acceptedBranch,
    required this.donatedItemResponses,
    required this.simpleUserResponse,
    required this.rejectingBranchResponses,
    required this.simpleActivityResponse,
  });
  late final String id;
  late final String address;
  late final List<double> location;
  late final List<String> images;
  late final bool isConfirmable;
  late final String createdDate;
  late final String? acceptedDate;
  late final List<ScheduledTimes> scheduledTimes;
  late final String status;
  late final String note;
  late final Branch? acceptedBranch;
  late final List<DonatedItemResponses> donatedItemResponses;
  late final SimpleUserResponse simpleUserResponse;
  late final List<Branch>? rejectingBranchResponses;
  late final SimpleActivityResponse? simpleActivityResponse;
  
  DonatedRequestDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    address = json['address'];
    location = List.castFrom<dynamic, double>(json['location']);
    images = List.castFrom<dynamic, String>(json['images']);
    isConfirmable = json['isConfirmable'];
    createdDate = json['createdDate'];
    acceptedDate = json['acceptedDate'];
    scheduledTimes = List.from(json['scheduledTimes']).map((e)=>ScheduledTimes.fromJson(e)).toList();
    status = json['status'];
    note = json['note'] ?? '';
    acceptedBranch = json['acceptedBranch'] == null ? null : Branch.fromJson(json['acceptedBranch']);
    donatedItemResponses = List.from(json['donatedItemResponses']).map((e)=>DonatedItemResponses.fromJson(e)).toList();
    simpleUserResponse = SimpleUserResponse.fromJson(json['simpleUserResponse']);
    rejectingBranchResponses = json['rejectingBranchResponses'] == null ? [] : List.from(json['rejectingBranchResponses']).map((e) => Branch.fromJson(e)).toList();
    simpleActivityResponse = json['simpleActivityResponse'] == null ? null : SimpleActivityResponse.fromJson(json['simpleActivityResponse']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['location'] = location;
    data['images'] = images;
    data['isConfirmable'] = isConfirmable;
    data['createdDate'] = createdDate;
    data['acceptedDate'] = acceptedDate;
    data['scheduledTimes'] = scheduledTimes.map((e)=>e.toJson()).toList();
    data['status'] = status;
    data['note'] = note;
    data['acceptedBranch'] = acceptedBranch;
    data['donatedItemResponses'] = donatedItemResponses.map((e)=>e.toJson()).toList();
    data['simpleUserResponse'] = simpleUserResponse.toJson();
    data['rejectingBranchResponses'] = rejectingBranchResponses;
    data['simpleActivityResponse'] = simpleActivityResponse;
    return data;
  }
}

class ScheduledTimes {
  ScheduledTimes({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  late final String day;
  late final String startTime;
  late final String endTime;
  
  ScheduledTimes.fromJson(Map<String, dynamic> json){
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

class DonatedItemResponses {
  DonatedItemResponses({
    required this.id,
    required this.quantity,
    required this.initialExpirationDate,
    required this.status,
    required this.itemTemplateResponse,
    required this.importedQuantity,
  });
  late final String id;
  late final int quantity;
  late final int importedQuantity;
  late final String initialExpirationDate;
  late final String status;
  late final ItemTemplateResponse itemTemplateResponse;
  
  DonatedItemResponses.fromJson(Map<String, dynamic> json){
    id = json['id'];
    quantity = json['quantity'];
    importedQuantity = json['importedQuantity'];
    initialExpirationDate = json['initialExpirationDate'];
    status = json['status'];
    itemTemplateResponse = ItemTemplateResponse.fromJson(json['itemTemplateResponse']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['importedQuantity'] = importedQuantity;
    data['initialExpirationDate'] = initialExpirationDate;
    data['status'] = status;
    data['itemTemplateResponse'] = itemTemplateResponse.toJson();
    return data;
  }
}

class ItemTemplateResponse {
  ItemTemplateResponse({
    required this.id,
    required this.name,
    required this.attributeValues,
    required this.image,
    required this.note,
    required this.estimatedExpirationDays,
    required this.maximumTransportVolume,
    required this.unit,
  });
  late final String id;
  late final String name;
  late final List<String> attributeValues;
  late final String image;
  late final String note;
  late final int estimatedExpirationDays;
  late final int maximumTransportVolume;
  late final String unit;
  
  ItemTemplateResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    attributeValues = List.castFrom<dynamic, String>(json['attributeValues']);
    image = json['image'];
    note = json['note'] ?? '';
    estimatedExpirationDays = json['estimatedExpirationDays'];
    maximumTransportVolume = json['maximumTransportVolume'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['attributeValues'] = attributeValues;
    data['image'] = image;
    data['note'] = note;
    data['estimatedExpirationDays'] = estimatedExpirationDays;
    data['maximumTransportVolume'] = maximumTransportVolume;
    return data;
  }
}

class SimpleUserResponse {
  SimpleUserResponse({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.role,
    required this.phone,
    required this.email,
    required this.status,
  });
  late final String id;
  late final String fullName;
  late final String avatar;
  late final String role;
  late final String phone;
  late final String email;
  late final String status;
  
  SimpleUserResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['role'] = role;
    data['phone'] = phone;
    data['email'] = email;
    data['status'] = status;
    return data;
  }
}

class SimpleActivityResponse {
  SimpleActivityResponse({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;
  
  SimpleActivityResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}