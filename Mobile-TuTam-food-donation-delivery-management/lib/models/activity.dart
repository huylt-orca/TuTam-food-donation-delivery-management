import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/sampledata.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class Activity {
  Activity({
    required this.id,
    required this.name,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.estimatedStartDate,
    required this.estimatedEndDate,
    required this.deliveringDate,
    required this.status,
    required this.description,
    required this.images,
    required this.scope,
    required this.isNearby,
    required this.numberOfParticipants,
    required this.activityTypeComponents,
    required this.targetProcessResponses,
    required this.isJoined,
    required this.branchResponses,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String startDate;
  late final String endDate;
  late final String estimatedStartDate;
  late final String estimatedEndDate;
  late final String deliveringDate;
  late final String status;
  late final String description;
  late final List<String> images;
  late final String scope;
  late final bool isNearby;
  late final int numberOfParticipants;
  late final List<String> activityTypeComponents;
  late final List<dynamic> targetProcessResponses;
  late final bool isJoined;
  late final List<Branch> branchResponses;
  // int remainingDays =0;
  
  Activity.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    startDate = Utils.converDate(json['startDate']);
    endDate = Utils.converDate(json['endDate']);
    estimatedStartDate = Utils.converDate(json['estimatedStartDate']); 
    estimatedEndDate = Utils.converDate(json['estimatedEndDate']); 
    deliveringDate = Utils.converDate(json['deliveringDate']);  
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    images = List.castFrom<dynamic, String>(json['images'] ?? List.empty());
    scope = json['scope'] ?? '';
    isNearby = json['isNearby'] ?? false;
    numberOfParticipants = json['numberOfParticipants'] ?? 0;
    activityTypeComponents = List.castFrom<dynamic, String>(json['activityTypeComponents'] ?? List.empty());
    targetProcessResponses = List.castFrom<dynamic, dynamic>(json['targetProcessResponses'] ?? List.empty());
    isJoined = json['isJoined'] ?? false;
    branchResponses = json['branchResponses'] == null ? List.empty() : List.from(json['branchResponses']).map((e)=>Branch.fromJson(e)).toList()  ;
    
    // if (json['endDate'] == ''){
    // if (json['startDate'] == ''){
    //   remainingDays = Utils.SubDate( DateTime.now().toString(), json['estimatedStartDate']);
    // } else{
    //   remainingDays = Utils.SubDate( DateTime.now().toString(), json['estimatedEndDate']);
    // }} else {
    //   remainingDays = -1;
    // }
     
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['estimatedStartDate'] = estimatedStartDate;
    data['estimatedEndDate'] = estimatedEndDate;
    data['deliveringDate'] = deliveringDate;
    data['status'] = status;
    data['description'] = description;
    data['images'] = images;
    data['scope'] = scope;
    data['isNearby'] = isNearby;
    data['numberOfParticipants'] = numberOfParticipants;
    data['activityTypeComponents'] = activityTypeComponents;
    data['targetProcessResponses'] = targetProcessResponses;
    data['isJoined'] = isJoined;
    data['branchResponses'] = branchResponses.map((e)=>e.toJson()).toList();
    return data;
  }

  static Activity sample = Activity(
    id: '', 
    name: 'Demo test 01', 
    address: 'address', 
    startDate: '2023-09-15T17:00:00', 
    endDate: '2023-09-15T17:00:00', 
    estimatedStartDate: '2023-09-15T17:00:00', 
    estimatedEndDate: '2023-09-15T17:00:00', 
    deliveringDate: '2023-09-15T17:00:00', 
    status: 'NOT_STARTED', 
    description: 'description', 
    images: [
           SampleData.image
        ], 
    scope: "PUBLIC", 
    isNearby: false, 
    numberOfParticipants: 10, 
    activityTypeComponents: [
            "Quyên góp",
            "Lao động tình nguyện"
        ], 
    targetProcessResponses: [],
     isJoined: true, 
     branchResponses: []);
}




