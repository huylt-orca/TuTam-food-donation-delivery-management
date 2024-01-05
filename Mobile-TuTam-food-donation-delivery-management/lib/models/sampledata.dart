import 'package:food_donation_delivery_app/models/activity.dart';

class SampleData{
  SampleData._();

  static const String image = 'https://static-images.vnncdn.net/files/publish/2023/3/25/thien-nguyen-4-947.jpg';
  static const String text = 'Từ Tâm';
  static const String longText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  static List<Activity> activities = 
  [
    Activity(id: '1', name: 'Demo test 01', address: '2131sdfa', startDate: '12/1/2023', endDate: '15/1/2023', estimatedStartDate: '12/1/2023', estimatedEndDate: '15/1/2023', deliveringDate: '', status: 'NOT_STARTED', description: 'description', images: [SampleData.image], scope: 'PUBLIC', isNearby: false, numberOfParticipants: 10, activityTypeComponents: [], targetProcessResponses: [], isJoined: false, branchResponses: []),
    Activity(id: '1', name: 'Demo test 02', address: '2131sdfa', startDate: '12/1/2023', endDate: '15/1/2023', estimatedStartDate: '12/1/2023', estimatedEndDate: '15/1/2023', deliveringDate: '', status: 'NOT_STARTED', description: 'description', images: [SampleData.image], scope: 'PUBLIC', isNearby: false, numberOfParticipants: 10, activityTypeComponents: [], targetProcessResponses: [], isJoined: false, branchResponses: []),
    Activity(id: '1', name: 'Demo test 03', address: '2131sdfa', startDate: '12/1/2023', endDate: '15/1/2023', estimatedStartDate: '12/1/2023', estimatedEndDate: '15/1/2023', deliveringDate: '', status: 'NOT_STARTED', description: 'description', images: [SampleData.image], scope: 'PUBLIC', isNearby: false, numberOfParticipants: 10, activityTypeComponents: [], targetProcessResponses: [], isJoined: false, branchResponses: [])
  ];
}