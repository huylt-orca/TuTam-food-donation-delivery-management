class Collaborator {
  Collaborator({
    required this.phone,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.dateOfBirth,
    required this.gender,
    required this.frontOfIdCard,
    required this.backOfIdCard,
    required this.note,
    required this.status,
    this.genderNo = 0
  });
  late final String phone;
  late final String email;
  late final String fullName;
  late final String avatar;
  late final String dateOfBirth;
  late final String gender;
  late final String frontOfIdCard;
  late final String backOfIdCard;
  late final String note;
  late final String status;
  late final int genderNo;
  
  Collaborator.fromJson(Map<String, dynamic> json){
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    fullName = json['fullName'] ?? '';
    avatar = json['avatar'] ?? '';
    dateOfBirth = json['dateOfBirth'] ?? '';
    gender = json['gender'] ?? '';
    frontOfIdCard = json['frontOfIdCard'] ?? '';
    backOfIdCard = json['backOfIdCard'] ?? '';
    note = json['note'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['frontOfIdCard'] = frontOfIdCard;
    data['backOfIdCard'] = backOfIdCard;
    data['note'] = note;
    data['status'] = status;
    return data;
  }
}