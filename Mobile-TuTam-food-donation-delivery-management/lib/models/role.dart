class Role {
  Role({
    required this.id,
    required this.name,
    required this.displayName,
  });
  late final String id;
  late final String name;
  late final String displayName;
  
  Role.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['displayName'] = displayName;
    return data;
  }
}