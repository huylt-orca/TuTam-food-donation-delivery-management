import 'package:flutter/material.dart';

class ScheduledTimesObject {
  ScheduledTimesObject({
    required this.day,
    required this.startTime,
    required this.endTime,
    this.isValid = false
  });
  DateTime day;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isValid;

   Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['day'] = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    data['startTime'] = '${startTime?.hour}:${startTime?.minute.toString().padLeft(2, '0')}';
    data['endTime'] = '${endTime?.hour}:${endTime?.minute.toString().padLeft(2, '0')}';
    return data;
  }

  static List<ScheduledTimesObject> list = [
    ScheduledTimesObject(day: DateTime.now(), startTime: TimeOfDay.now(), endTime: TimeOfDay(hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute)),
    ScheduledTimesObject(day: DateTime.now().add(const Duration(days: 1)), startTime: TimeOfDay.now(), endTime: TimeOfDay(hour: TimeOfDay.now().hour + 3 , minute: TimeOfDay.now().minute)),
    ScheduledTimesObject(day: DateTime.now().add(const Duration(days: 2)), startTime: TimeOfDay.now(), endTime: TimeOfDay(hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute)),
    ScheduledTimesObject(day: DateTime.now().add(const Duration(days: 3)), startTime: TimeOfDay.now(), endTime: TimeOfDay(hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute)),
  ];
}