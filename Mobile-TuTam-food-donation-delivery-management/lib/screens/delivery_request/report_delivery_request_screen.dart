import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/models/report_delivery_type.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/services/delivery_request_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:get/get.dart';

class ReportDeliveryRequestScreen extends StatefulWidget {
  final OrderedDeliveryRequests orderedDeliveryRequests;
  const ReportDeliveryRequestScreen({
    super.key,
    required this.orderedDeliveryRequests,
  });

  @override
  State<ReportDeliveryRequestScreen> createState() =>
      ReportDeliveryRequestScreenState();
}

class ReportDeliveryRequestScreenState
    extends State<ReportDeliveryRequestScreen> {
  final TextEditingController _txtDescription = TextEditingController();
  final List<ReportDeliveryType> _types = ReportDeliveryType.sample;
  ReportDeliveryType _selectedType = ReportDeliveryType.sample[0];
  final ScheduleRouteController _routeController = Get.find();
  String _txtMessageError = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.orderedDeliveryRequests.avatar,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.orderedDeliveryRequests.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: DropdownButton<ReportDeliveryType>(
                value: _selectedType,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                itemHeight: 50,
                onChanged: (ReportDeliveryType? value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                items: _types.map<DropdownMenuItem<ReportDeliveryType>>(
                    (ReportDeliveryType value) {
                  return DropdownMenuItem<ReportDeliveryType>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value.description),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 4,
              controller: _txtDescription,
              decoration: const InputDecoration(
                label: Text("Chi tiết báo cáo"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _txtMessageError.isEmpty
                ? const SizedBox()
                : Text(
                    _txtMessageError,
                    style: const TextStyle(color: Colors.red),
                  ),
            SizedBox(
              height: _txtMessageError.isEmpty ? 0 : 4,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Gửi',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                try {
                if (_txtDescription.text.length < 10 ||
                    _txtDescription.text.length > 150) {
                  
                  setState(() {
                    _txtMessageError =
                        'Báo cáo phải có độ dài khoảng 10-150 ký tự';
                  });
                } else {
                  DialogHelper.showLoading(context);
                  bool isSuccess =
                      await DeliveryRequestService.reportDeliveryRequest(
                          deliveryRequestId: widget.orderedDeliveryRequests.id,
                          type: _selectedType.id,
                          title: _selectedType.description,
                          content: _txtDescription.text);

                  if (!context.mounted) return;
                  DialogHelper.hideLoading(context);

                  if (isSuccess) {
                    Fluttertoast.showToast(
                        msg: 'Gửi thành công', gravity: ToastGravity.CENTER);
                    _routeController.updateStatusDeliveryRequest(
                        widget.orderedDeliveryRequests.id, 'REPORTED');

                    List<String> idItemToRemove = widget.orderedDeliveryRequests.deliveryItems!.map((e) => e.deliveryItemId).toList();
                    _routeController.scheduleRouteDetail.value.orderedDeliveryRequests.last.deliveryItems!.removeWhere((element) => idItemToRemove.contains(element.deliveryItemId));
                        
                    if (!context.mounted) return;
                    Navigator.of(context).pop(true);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Gửi thất bại', gravity: ToastGravity.CENTER);
                  }
                }

                } catch (e){
                  
                  if (!context.mounted) return;
                  DialogHelper.hideLoading(context);
                  DialogHelper.showAwesomeDialogError(context, e.toString());
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
