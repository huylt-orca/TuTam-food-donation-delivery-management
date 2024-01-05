import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/services/delivery_request_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';

class UserReportDeliveryRequestScreen extends StatefulWidget {
  final String deliveryRequestId;
  const UserReportDeliveryRequestScreen({
    super.key,
    required this.deliveryRequestId,
  });

  @override
  State<UserReportDeliveryRequestScreen> createState() =>
      UserReportDeliveryRequestScreenState();
}

class UserReportDeliveryRequestScreenState
    extends State<UserReportDeliveryRequestScreen> {
  final TextEditingController _txtContent = TextEditingController();
  final TextEditingController _txtTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập tiêu đề báo cáo";
    }
    if (value.length < 10 || value.length > 150) {
      return "Tiêu đề phải có độ dài từ 10-150 ký tự";
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập nội dung báo cáo";
    }
    if (value.length < 10 || value.length > 150) {
      return "Nội dung phải có độ dài từ 10-150 ký tự";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo đơn vận chuyển'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLines: 1,
                controller: _txtTitle,
                validator: _validateTitle,
                decoration: const InputDecoration(
                  label: Text("Tiêu đề báo cáo"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 4,
                controller: _txtContent,
                validator: _validateContent,
                decoration: const InputDecoration(
                  label: Text("Nội dung báo cáo"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: const Text(
                  'Gửi báo cáo',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      DialogHelper.showLoading(context);

                      bool isSuccess = await DeliveryRequestService
                          .sendReportForDeliveryRequestFromUser(
                              deliveryRequestId: widget.deliveryRequestId,
                              title: _txtTitle.text,
                              content: _txtContent.text);

                      if (!context.mounted) return;
                      DialogHelper.hideLoading(context);

                      if (isSuccess){
                        Fluttertoast.showToast(msg: 'Gửi báo cáo thành công');
                        Navigator.of(context).pop(true);
                      }

                    }
                  } catch (error) {
                    DialogHelper.showAwesomeDialogError(context, error.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
