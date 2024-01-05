import 'package:food_donation_delivery_app/utils/utils.dart';

class ActivityDetail {
  ActivityDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.estimatedStartDate,
    required this.estimatedEndDate,
    required this.deliveringDate,
    required this.status,
    required this.description,
    required this.images,
    required this.scope,
    required this.isNearby,
    required this.numberOfParticipants,
    required this.activityTypeComponents,
    required this.targetProcessResponses,
    required this.isJoined,
    required this.branchResponses,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String location;
  late final String startDate;
  late final String endDate;
  late final String estimatedStartDate;
  late final String estimatedEndDate;
  late final String deliveringDate;
  late final String status;
  late final String description;
  late final List<String> images;
  late final String scope;
  late final bool isNearby;
  late final int numberOfParticipants;
  late final List<String> activityTypeComponents;
  late final List<TargetProcessResponses> targetProcessResponses;
  late final bool isJoined;
  late final List<BranchResponses> branchResponses;
  int remainingDays = 0;
  double process = 0;
  
  ActivityDetail.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    location = json['location'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    estimatedStartDate = json['estimatedStartDate'] ?? '';
    estimatedEndDate = json['estimatedEndDate'] ?? '';
    deliveringDate = json['deliveringDate'] ?? '';
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    images = List.castFrom<dynamic, String>(json['images']);
    scope = json['scope'] ?? '';
    isNearby = json['isNearby'] ?? '';
    numberOfParticipants = json['numberOfParticipants'] ?? 0;
    activityTypeComponents = List.castFrom<dynamic, String>(json['activityTypeComponents']);
    targetProcessResponses = json['targetProcessResponses'] == null ? List.empty() : List.from(json['targetProcessResponses']).map((e)=>TargetProcessResponses.fromJson(e)).toList();
    isJoined = json['isJoined'];
    branchResponses = json['branchResponses'] == null ? List.empty() :  List.from(json['branchResponses']).map((e)=>BranchResponses.fromJson(e)).toList();

    // calculator 
    if (json['endDate'] == null){
    if (json['startDate'] == null){
      remainingDays = Utils.subDate( DateTime.now().toString(), json['estimatedStartDate']);
    } else{
      remainingDays = Utils.subDate( DateTime.now().toString(), json['estimatedEndDate']);
    }} else {
      remainingDays = -1;
    }
    
    process = (json['totalTargetProcessPercentage'] ?? 0).toDouble();
    
    // if (targetProcessResponses.isNotEmpty){
    //   for (var item in targetProcessResponses){
    //     process += item.percent;
    //   }
    //   process = process / targetProcessResponses.length;
    // }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['location'] = location;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['estimatedStartDate'] = estimatedStartDate;
    data['estimatedEndDate'] = estimatedEndDate;
    data['deliveringDate'] = deliveringDate;
    data['status'] = status;
    data['description'] = description;
    data['images'] = images;
    data['scope'] = scope;
    data['isNearby'] = isNearby;
    data['numberOfParticipants'] = numberOfParticipants;
    data['activityTypeComponents'] = activityTypeComponents;
    data['targetProcessResponses'] = targetProcessResponses.map((e)=>e.toJson()).toList();
    data['isJoined'] = isJoined;
    data['branchResponses'] = branchResponses.map((e)=>e.toJson()).toList();
    return data;
  }
}

class TargetProcessResponses {
  TargetProcessResponses({
    required this.target,
    required this.process,
    required this.itemTemplateResponse,
  });
  late final int target;
  late final int process;
  late final ItemTemplateResponse itemTemplateResponse;
  double percent = 0;
  
  TargetProcessResponses.fromJson(Map<String, dynamic> json){
    target = json['target'];
    process = json['process'];
    itemTemplateResponse = ItemTemplateResponse.fromJson(json['itemTemplateResponse']);
    percent = double.parse(((process/ target) * 100).toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['target'] = target;
    data['process'] = process;
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
    data['unit'] = unit;
    return data;
  }
}

class BranchResponses {
  BranchResponses({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.createdDate,
    required this.status,
    required this.location,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String image;
  late final String createdDate;
  late final String status;
  late final List<double> location;
  
  BranchResponses.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    createdDate = json['createdDate'];
    status = json['status'];
    location = json['location'] == null ? [] : List.castFrom<dynamic, double>(json['location']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['image'] = image;
    data['createdDate'] = createdDate;
    data['status'] = status;
    return data;
  }
}
