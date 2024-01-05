import 'package:food_donation_delivery_app/models/activity_type.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/province.dart';

class ActivityFilter{
  String? name;
  int status = -1;
  List<ActivityType>? activityType;
  DateTime? startDate;
  DateTime? endDate; 
  Branch? branch;
  Province? province;
  Province? district;

  
  ActivityFilter({
    this.name,
    this.status = -1,
    this.activityType ,
    this.startDate,
    this.endDate,
    this.branch,
    this.province,
    this.district
    });
}