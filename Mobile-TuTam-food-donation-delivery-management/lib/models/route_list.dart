// data fake, can remove
class RouteList {
  RouteList({
    required this.id,
    required this.name,
    this.isTrue = false,
    this.type = 'Nhan'
  });
  late final String id;
  late final String name;
  late final String type;
  late bool isTrue;
  
  RouteList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  static List<RouteList> list = [
    RouteList(id: 'f312b640-2751-ee11-9f1b-c809a8bfd17d', name: 'Quyên góp',isTrue: false),
    RouteList(id: '69db3c47-2751-ee11-9f1b-c809a8bfd17d', name: 'Lao động tình nguyện',isTrue: false, type: 'Giao'),
    RouteList(id: 'e76ac04f-2751-ee11-9f1b-c809a8bfd17d', name: 'Hỗ trợ phát đồ',isTrue: false),
  ];

  static List<RouteList> list2  = [
    RouteList(id: 'f312b640-2751-ee11-9f1b-c809a8bfd17d', name: 'Quyên góp',isTrue: true),
  ];

}