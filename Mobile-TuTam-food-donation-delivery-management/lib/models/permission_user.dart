class PermissionUser {
  PermissionUser({
    required this.permissionId,
    required this.userId,
    required this.status,
    required this.name,
    required this.displayName,
  });
  late final String permissionId;
  late final String userId;
  late final String status;
  late final String name;
  late final String displayName;
  
  PermissionUser.fromJson(Map<String, dynamic> json){
    permissionId = json['permissionId'] ?? '';
    userId = json['userId'] ?? '';
    status = json['status'] ?? '';
    name = json['name'] ?? '';
    displayName = json['displayName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['permissionId'] = permissionId;
    data['userId'] = userId;
    data['status'] = status;
    data['name'] = name;
    data['displayName'] = displayName;
    return data;
  }
}