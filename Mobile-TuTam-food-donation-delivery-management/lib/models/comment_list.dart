class CommentList {
  CommentList({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.content,
    required this.image
  });
  late final String id;
  late final String name;
  late final String createdDate;
  late final String content;
  late final String image;
  
  CommentList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdDate = json['createdDate'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdDate'] = createdDate;
    data['content'] = content;
    data['image'] = image;
    return data;
  }
}