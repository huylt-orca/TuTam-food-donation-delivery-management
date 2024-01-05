import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarMultiCard extends StatefulWidget {
  final List<DateTime> listDate;
  final Function(List<DateTime>) onValueSelected; 
  const CalendarMultiCard({super.key,
  required this.listDate,
  required this.onValueSelected
  });

  @override
  State<CalendarMultiCard> createState() => _CalendarMultiCardState();
}

class _CalendarMultiCardState extends State<CalendarMultiCard> {
  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _dateRangePickerController.selectedDates = widget.listDate;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SfDateRangePicker(
        minDate: DateTime.now(),
        maxDate: DateTime.now().add(const Duration(days:13)),
        controller: _dateRangePickerController,
        initialSelectedDates: _dateRangePickerController.selectedDates,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.multiple,
        headerHeight: 100,
        showActionButtons: true,
        showNavigationArrow: true,
        onCancel: (){
          Navigator.of(context).pop();
        },
        onSubmit: (Object? val){
          
          widget.onValueSelected(_dateRangePickerController.selectedDates ?? []);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}