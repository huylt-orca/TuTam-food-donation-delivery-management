import 'package:food_donation_delivery_app/models/sampledata.dart';
import 'package:intl/intl.dart';

class ItemList {
  ItemList({
    required this.itemTemplateId,
    required this.name,
    required this.image,
    required this.unit,
    required this.attributes,
  });
  late final String itemTemplateId;
  late final String name;
  late final String image;
  late final Unit unit;
  late final List<Attributes> attributes;
  late int quantity = 0 ;
  DateTime? initialExpirationDate;
  late int leftDate = 2;
  int isValid = 0;
  
  ItemList.fromJson(Map<String, dynamic> json){
    itemTemplateId = json['itemTemplateId'];
    name = json['name'];
    image = json['image'];
    unit = Unit.fromJson(json['unit']);
    attributes = List.from(json['attributes']).map((e)=>Attributes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJsonForCreateDonated() {
    final data = <String, dynamic>{};
    data['itemTemplateId'] = itemTemplateId;
    data['quantity'] = quantity;
    data['initialExpirationDate'] = DateFormat("yyyy-MM-dd'T'00:00:00").format(initialExpirationDate!);
    return data;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['itemTemplateId'] = itemTemplateId;
    data['name'] = name;
    data['image'] = image;
    data['unit'] = unit.toJson();
    data['attributes'] = attributes.map((e)=>e.toJson()).toList();
    return data;
  }

  static ItemList sample = ItemList(
    itemTemplateId: '', 
    name: '', 
    image: SampleData.image, 
    unit: Unit(id: '', name: '', symbol: ''), 
    attributes: []);
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

class Attributes {
  Attributes({
    required this.attributeValue,
  });
  late final String attributeValue;
  
  Attributes.fromJson(Map<String, dynamic> json){
    attributeValue = json['attributeValue'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attributeValue'] = attributeValue;
    return data;
  }
}