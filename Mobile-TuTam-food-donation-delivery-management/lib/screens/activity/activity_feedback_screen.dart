import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/services/activity_feedback_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';

class ActivityFeedbackScreen extends StatefulWidget {
  final String idActivity;
  const ActivityFeedbackScreen({
    super.key,
    required this.idActivity,
    });

  @override
  State<ActivityFeedbackScreen> createState() => _ActivityFeedbackScreenState();
}

class _ActivityFeedbackScreenState extends State<ActivityFeedbackScreen> {
  double _rating = 1;
   final TextEditingController _txtDescription = TextEditingController();
  String _txtMessageError = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đóng góp ý kiến'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            const SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              minRating: 1,
              initialRating: 5,
              itemBuilder: (context, index) => const Icon(Icons.star, color: AppTheme.primarySecond,), 
              onRatingUpdate: (rating)=> setState(() {
                _rating = rating;
              })),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 4,
              controller: _txtDescription,
              decoration: const InputDecoration(
                label: Text("Ý kiến đóng góp"),
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
                  if (_txtDescription.text.length < 25 ||
                    _txtDescription.text.length > 500) {
                  setState(() {
                    _txtMessageError =
                        'Ý kiến đóng góp phải có độ dài khoảng 25-500 ký tự';
                  });
                } else {
                  DialogHelper.showLoading(context);
                  bool isSuccess =
                      await ActivityFeedbackService.sendFeedbackToActivity(
                          activityId: widget.idActivity,
                          rating: _rating.toInt(),
                          content: _txtDescription.text);

                  if (!context.mounted) return;
                  DialogHelper.hideLoading(context);

                  if (isSuccess) {
                    Fluttertoast.showToast(
                        msg: 'Gửi thành công', gravity: ToastGravity.CENTER);
                    if (!context.mounted) return;
                    Navigator.of(context).pop(true);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Gửi thất bại', gravity: ToastGravity.CENTER);
                  }
                }

                } catch (e){
                  DialogHelper.hideLoading(context);
                  DialogHelper.showAwesomeDialogError(context, e.toString());
                }
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}