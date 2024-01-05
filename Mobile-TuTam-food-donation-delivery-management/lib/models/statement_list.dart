class StatementList {
  StatementList({
    required this.id,
    required this.quantity,
    required this.name,
    required this.attributeValues,
    required this.unit,
    required this.pickUpPoint,
    required this.deliveryPoint,
    required this.createdDate,
    required this.type,
    required this.note,
    required this.activityName,
  });
  late final String id;
  late final int quantity;
  late final String name;
  late final List<String> attributeValues;
  late final String unit;
  late final String pickUpPoint;
  late final String deliveryPoint;
  late final String createdDate;
  late final String type;
  late final String note;
  late final String activityName;
  late final String donorName;
  
  StatementList.fromJson(Map<String, dynamic> json){
    id = json['id'] ??'';
    quantity = json['quantity'];
    name = json['name'];
    attributeValues = json['attributeValues'] == null ? [] : List.castFrom<dynamic, String>(json['attributeValues']);
    unit = json['unit'];
    pickUpPoint = json['pickUpPoint'] ??'';
    deliveryPoint = json['deliveryPoint'] ??'';
    createdDate = json['createdDate'];
    type = json['type'];
    note = json['note']??'';
    activityName = json['activityName']??'';
    donorName = json['donorName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['name'] = name;
    data['attributeValues'] = attributeValues;
    data['unit'] = unit;
    data['pickUpPoint'] = pickUpPoint;
    data['deliveryPoint'] = deliveryPoint;
    data['createdDate'] = createdDate;
    data['type'] = type;
    data['note'] = note;
    data['activityName'] = activityName;
    return data;
  }
}