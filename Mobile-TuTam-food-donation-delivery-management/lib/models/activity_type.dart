class ActivityType {
  ActivityType({
    required this.id,
    required this.name,
    this.isTrue = false
  });
  late final String id;
  late final String name;
  late bool isTrue;
  
  ActivityType.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  static List<ActivityType> list = [
    ActivityType(id: 'f312b640-2751-ee11-9f1b-c809a8bfd17d', name: 'Quyên góp',isTrue: false),
    ActivityType(id: '69db3c47-2751-ee11-9f1b-c809a8bfd17d', name: 'Lao động tình nguyện',isTrue: false),
    ActivityType(id: 'e76ac04f-2751-ee11-9f1b-c809a8bfd17d', name: 'Hỗ trợ phát đồ',isTrue: false),
  ];

}