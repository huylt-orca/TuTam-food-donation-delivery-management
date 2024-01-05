import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils{

  static String converDate (String? date){
    if (date == null || date.isEmpty){
      return '';
    }
    DateTime originalDateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(originalDateTime);
  }

  static int subDate (String dateBefore, String dateAfter){
    // DateTime dateTime1 = DateTime.parse(dateBefore); 
    // DateTime dateTime2 = DateTime.parse(dateAfter);
     DateTime dateTime1 = parseAndSetTimeToZero(dateBefore); 
    DateTime dateTime2 = parseAndSetTimeToZero(dateAfter);
    //dateAftter - dateBefore
    Duration difference = dateTime2.difference(dateTime1);
    return difference.inDays;
  }

  static DateTime parseAndSetTimeToZero(String inputTimeString) {
    // Parse the input string
    DateTime parsedDateTime = DateTime.parse(inputTimeString);
    
    // Set hours, minutes, seconds, and milliseconds to 0
    parsedDateTime = DateTime(
      parsedDateTime.year,
      parsedDateTime.month,
      parsedDateTime.day,
    );

    return parsedDateTime;
  }


  static String convertDay (String? date){
    if (date == null || date.isEmpty){
      return '';
    }
    DateTime originalDateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(originalDateTime);
  }

  static String convertDateToTimeDate (String date){
     DateTime originalDateTime = DateTime.parse(date);
    return DateFormat('H:mm, dd-MM-yyyy').format(originalDateTime);
  }

    static String convertDateToTimeDateVN (String date){
     DateTime originalDateTime = DateTime.parse(date);
    return DateFormat("d 'tháng' MM, yyyy 'lúc' HH:mm").format(originalDateTime);
  }

  static int compareTimeOfDay (TimeOfDay first, TimeOfDay second){
    int firstTimeMinutes = first.hour * 60 + first.minute;
    int secondMinutes = second.hour * 60 + second.minute;
    return secondMinutes - firstTimeMinutes;
  }

  static String convertMeterToKilometer (double meter){
    
    if (meter / 1000 < 1){
      return '${meter.toStringAsFixed(1)} m';
    }
    return '${(meter / 1000).toStringAsFixed(1)} km';
  }

   static int convertSecondToMinutes (double second){
    return (second / 60).ceil();
  }

  static String convertTimeTo24H(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat("HH:mm");  
    return format.format(dt);
  }

  
}