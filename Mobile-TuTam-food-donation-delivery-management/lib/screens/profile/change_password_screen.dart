import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:food_donation_delivery_app/services/user_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _txtOldPassword = TextEditingController();
  final TextEditingController _txtNewPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isHiddenOld = true;
  bool isHiddenConfirm = true;
  bool isHiddenNew = true;

  String? _validateOldPassword(String? value) { 
    if (value == null || value.isEmpty) {
      return "Nhập lại mật khẩu";
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập lại mật khẩu";
    }
    if (value.length < 8 || value.length > 40){
      return 'Độ dài của mật khẩu từ 8-40 ký tự';
    }

  // Mẫu biểu thức chính quy để kiểm tra mật khẩu
  RegExp regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).+$");

  if (!regex.hasMatch(value)) {
    return 'Mật khẩu phải chứa ít nhất một ký tự chữ cái và một ký tự số';
  }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty || value != _txtNewPassword.text) {
      return "Mật khẩu xác nhận không khớp";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thay đổi mật khẩu'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                      controller: _txtOldPassword,
                      obscureText: isHiddenOld,
                      validator: _validateOldPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.fingerprint),
                        labelText: "Mật khẩu cũ",
                        hintText: "Mật khẩu cũ",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHiddenOld = !isHiddenOld;
                              });
                            },
                            icon: Icon(isHiddenOld
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                      TextFormField(
                      controller: _txtNewPassword,
                      obscureText: isHiddenNew,
                      validator: _validateNewPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.fingerprint),
                        labelText: "Mật khẩu mới",
                        hintText: "Mật khẩu mới",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHiddenNew = !isHiddenNew;
                              });
                            },
                            icon: Icon(isHiddenNew
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: isHiddenConfirm,
                      controller: _txtConfirmPassword,
                      validator: _validateConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.fingerprint),
                        labelText: "Nhập lại mật khẩu mới",
                        hintText: "Nhập lại mật khẩu mới",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isHiddenConfirm = !isHiddenConfirm;
                            });
                          },
                          icon: Icon(isHiddenConfirm
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.primarySecond), 
                            shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), 
                            ),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              DialogHelper.showLoading(context);
                              bool isSuccessful = await UserService.changePassword(
                                oldPassword: _txtOldPassword.text, 
                                newPassword: _txtNewPassword.text);

                              if (!context.mounted) return;
                              DialogHelper.hideLoading(context);

                              if (isSuccessful) {
                              Fluttertoast.showToast(
                                  msg: "Đổi mật khẩu thành công");
                              StorageRepository.savePassword(_txtNewPassword.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Đổi mật khẩu thất bại");
                            }
                            }
                          } catch (error){
                            DialogHelper.hideLoading(context);
                            DialogHelper.showAwesomeDialogError(context, error.toString());
                          }
                        },
                        child: const Text(
                          'Thay đổi mật khẩu',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
