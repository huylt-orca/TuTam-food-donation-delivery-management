import 'package:food_donation_delivery_app/models/sampledata.dart';

class NotificationList {
  NotificationList({
    required this.id,
    required this.name,
    required this.image,
    required this.content,
    required this.createdDate,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.dataId,
    required this.dataType
  });
  late final String id;
  late final String name;
  late final String image;
  late final String content;
  late final String createdDate;
  late final String receiverId;
  late final String type;
  late String status;
  late final String dataType;
  late final String dataId;
  
  NotificationList.fromJson(Map<String, dynamic> json){
    id = json['id']  ?? '';
    name = json['name'] ?? '';
    image = json['image'] ?? '';
    content = json['content'] ?? '';
    createdDate = json['createdDate'] ?? '';
    receiverId = json['receiverId'] ?? '';
    type = json['type'] ?? '';
    status = json['status'] ?? '';
    dataType = json['dataType'] ?? '';
    dataId = json['dataId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['content'] = content;
    data['createdDate'] = createdDate;
    data['receiverId'] = receiverId;
    data['type'] = type;
    data['status'] = status;
    data['dataType'] = dataType;
    data['dataId'] = dataId;
    return data;
  }

  static List<NotificationList> list = [
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 1', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: DateTime.now().toString(), receiverId: '', type: '', status: 'NEW', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 2', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: DateTime.now().toString(), receiverId: '', type: '', status: 'SEEN', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 3', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: DateTime.now().toString(), receiverId: '', type: '', status: 'NEW', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 4', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: DateTime.now().toString(), receiverId: '', type: '', status: 'NEW', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 5', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: '2023-10-20T18:43:31.8688944', receiverId: '', type: '', status: 'SEEN', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 6', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: '2023-10-19T18:43:31.8688944', receiverId: '', type: '', status: 'NEW', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 7', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: '2023-10-18T18:43:31.8688944', receiverId: '', type: '', status: 'NEW', dataId: '', dataType: ''),
    NotificationList(id: 'ba0d0c66-e26c-ee11-9937-6045bd1c780f', name: 'Yêu cầu quyên góp 8', image: SampleData.image, content: 'Yêu cầu của bạn đã được chấp nhận bởi Branch A', createdDate: '2023-10-17T18:43:31.8688944', receiverId: '', type: '', status: 'SEEN', dataId: '', dataType: ''),
  ];
}