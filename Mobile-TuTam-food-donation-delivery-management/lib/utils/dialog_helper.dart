import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class DialogHelper {
  static bool _isDialogShowing = false;

  static void showLoading(BuildContext context) {
    _isDialogShowing = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _isDialogShowing = false;
            return true;
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primarySecond,
            ),
          ),
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  static void hideLoading(BuildContext context) {
    if (_isDialogShowing) {
      Navigator.of(context).pop();
      _isDialogShowing = false;
    }
  }

  static void showAwesomeDialogWarning(
      BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Cảnh báo',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.amber)
        .show();
  }

  static void showAwesomeDialogError(BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Lỗi',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.red)
        .show();
  }

  static void showAwesomeDialogInfor(BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Thông tin',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.blue)
        .show();
  }

  static void showAwesomeDialogSuccess(
      BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Thành công',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.green)
        .show();
  }

  static void showAwesomeDialogInfoReverse(
      BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.infoReverse,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Thông tin ngược',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.amber)
        .show();
  }

  static void showAwesomeDialogNoHeader(
      BuildContext context, String description) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'No header',
            desc: description,
            btnOkOnPress: () {},
            btnOkColor: Colors.black)
        .show();
  }

  static Future<bool> showCustomDialog({
    required BuildContext context,
    required String title,
    required String body,
    String okButton = 'Ok',
    String cancelButton = 'Đóng'
    }) async {
    bool isConfirm = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              child:  Text(cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(okButton),
              onPressed: () {
                 Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        isConfirm = true;
      }
    });
    return isConfirm;
  }
}
