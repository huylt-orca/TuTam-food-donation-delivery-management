class ItemAttribute {
  ItemAttribute({
    required this.attributeValue,
  });
  late final String attributeValue;
  
  ItemAttribute.fromJson(Map<String, dynamic> json){
    attributeValue = json['attributeValue'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attributeValue'] = attributeValue;
    return data;
  }
}