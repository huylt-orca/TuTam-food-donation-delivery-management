import 'package:intl/intl.dart';

class ItemTemplateList {
  ItemTemplateList({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.status,
    required this.note,
    required this.unit,
    required this.image,
    required this.itemCategoryResponse,
    required this.attributes,
  });
  late final String id;
  late final String name;
  late final String createdDate;
  late final String status;
  late final String note;
  late final Unit unit;
  late final String image;
  late final ItemCategoryResponse itemCategoryResponse;
  late final List<Attributes> attributes;
  late int quantity = 0 ;
  String? initialExpirationDate;
  late int leftDate = 0;
  
  ItemTemplateList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdDate = json['createdDate'];
    status = json['status'];
    note = json['note'];
    unit = Unit.fromJson(json['unit']);
    image = json['image'];
    itemCategoryResponse = ItemCategoryResponse.fromJson(json['itemCategoryResponse']);
    attributes = List.from(json['attributes']).map((e)=>Attributes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdDate'] = createdDate;
    data['status'] = status;
    data['note'] = note;
    data['unit'] = unit.toJson();
    data['image'] = image;
    data['itemCategoryResponse'] = itemCategoryResponse.toJson();
    data['attributes'] = attributes.map((e)=>e.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toJsonForCreateDonated() {
    final data = <String, dynamic>{};
    data['itemTemplateId'] = id;
    data['quantity'] = quantity;
    data['initialExpirationDate'] = DateFormat("yyyy-MM-dd'T'00:00:00").format(DateTime.parse(initialExpirationDate!));
    return data;
  }
}

class Unit {
  Unit({
    required this.id,
    required this.name,
    required this.symbol,
  });
  late final String id;
  late final String name;
  late final String symbol;
  
  Unit.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    return data;
  }
}

class ItemCategoryResponse {
  ItemCategoryResponse({
    required this.id,
    required this.name,
    required this.type,
  });
  late final String id;
  late final String name;
  late final String type;
  
  ItemCategoryResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}

class Attributes {
  Attributes({
    required this.name,
    required this.id,
    required this.status,
  });
  late final String name;
  late final String id;
  late final String status;
  
  Attributes.fromJson(Map<String, dynamic> json){
    name = json['name'];
    id = json['id'];
    status = json['status'];
  }

  get attributeValue => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}