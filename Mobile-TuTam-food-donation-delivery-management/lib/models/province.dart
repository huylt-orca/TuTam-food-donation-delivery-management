class Province {
  Province({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
  });
  late final String name;
  late final int code;
  late final String divisionType;
  late final String codename;
  
  Province.fromJson(Map<String, dynamic> json){
    name = json['name'];
    code = json['code'];
    divisionType = json['division_type'];
    codename = json['codename'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['division_type'] = divisionType;
    data['codename'] = codename;
    return data;
  }

  static List<Province> listProvince = [
    Province(name: 'Thành phố Hà Nội', code: 1, divisionType: 'divisionType', codename: 'codename'),
    Province(name: 'Thành phố Hồ Chí Minh', code: 2, divisionType: 'divisionType', codename: 'codename'),
    Province(name: 'Đồng Nai', code: 3, divisionType: 'divisionType', codename: 'codename'),
    Province(name: 'Cần Thơ', code: 4, divisionType: 'divisionType', codename: 'codename'),
  ];
}