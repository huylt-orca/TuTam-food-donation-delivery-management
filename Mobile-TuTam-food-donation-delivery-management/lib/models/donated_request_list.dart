class DonatedRequestList {
  DonatedRequestList({
    required this.id,
    required this.images,
    required this.address,
    required this.location,
    required this.createdDate,
    required this.acceptedDate,
    required this.scheduledTimes,
    required this.status,
    required this.simpleBranchResponse,
     this.simpleActivityResponse,
    required this.donatedItemResponses,
  });
  late final String id;
  late final List<String> images;
  late final String address;
  late final List<double> location;
  late final String createdDate;
  late final String? acceptedDate;
  late final List<ScheduledTimes> scheduledTimes;
  late final String status;
  late final SimpleBranchResponse? simpleBranchResponse;
  late final SimpleActivityResponse? simpleActivityResponse;
  late final List<DonatedItemResponses> donatedItemResponses;
  
  DonatedRequestList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    images = List.castFrom<dynamic, String>(json['images']);
    address = json['address'];
    location = List.castFrom<dynamic, double>(json['location']);
    createdDate = json['createdDate'];
    acceptedDate = json['acceptedDate'];
    scheduledTimes = List.from(json['scheduledTimes']).map((e)=>ScheduledTimes.fromJson(e)).toList();
    status = json['status'];
    simpleBranchResponse = json['simpleBranchResponse'] == null ? null : SimpleBranchResponse.fromJson(json['simpleBranchResponse']);
    simpleActivityResponse = json['simpleActivityResponse'] == null ? null : SimpleActivityResponse.fromJson(json['simpleActivityResponse']);
    donatedItemResponses = List.from(json['donatedItemResponses']).map((e)=>DonatedItemResponses.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['images'] = images;
    data['address'] = address;
    data['location'] = location;
    data['createdDate'] = createdDate;
    data['acceptedDate'] = acceptedDate;
    data['scheduledTimes'] = scheduledTimes.map((e)=>e.toJson()).toList();
    data['status'] = status;
    data['simpleBranchResponse'] = simpleBranchResponse?.toJson();
    data['simpleActivityResponse'] = simpleActivityResponse;
    data['donatedItemResponses'] = donatedItemResponses.map((e)=>e.toJson()).toList();
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

class SimpleActivityResponse {
  SimpleActivityResponse({
    required this.id,
    required this.name,
    required this.image,
  });
  late final String id;
  late final String name;
  late final String image;
  
  SimpleActivityResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class SimpleBranchResponse {
  SimpleBranchResponse({
    required this.id,
    required this.name,
    required this.image,
  });
  late final String id;
  late final String name;
  late final String image;
  
  SimpleBranchResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class DonatedItemResponses {
  DonatedItemResponses({
    required this.id,
    required this.quantity,
    required this.importedQuantity,
    required this.initialExpirationDate,
    required this.status,
    required this.itemTemplateResponse,
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
    //  this.categoryResponse,
  });
  late final String id;
  late final String name;
  late final List<String> attributeValues;
  late final String image;
  late final String note;
  late final int estimatedExpirationDays;
  late final int maximumTransportVolume;
  late final String unit;
  // late final Null categoryResponse;
  
  ItemTemplateResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    attributeValues = List.castFrom<dynamic, String>(json['attributeValues']);
    image = json['image'];
    note = json['note'] ?? '';
    estimatedExpirationDays = json['estimatedExpirationDays'];
    maximumTransportVolume = json['maximumTransportVolume'];
    unit = json['unit'];
    // categoryResponse = null;
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
    // _data['categoryResponse'] = categoryResponse;
    return data;
  }
}