import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:food_donation_delivery_app/screens/main/splash_screen.dart';
import 'package:food_donation_delivery_app/services/user_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../app_config.dart';
import '../../app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtConfirmPassword = TextEditingController();

  final _formKeyStateOne = GlobalKey<FormState>();
  final _formKeyStateThree = GlobalKey<FormState>();

  int _stateScreen = 0;
  String _otpPin = '';
  String _tokenStateTwo = '';
  bool _isHidden = true;
  bool _isHiddenConfirm = true;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập lại tên";
    }
    if (value.length < 5 || value.length > 50){
      return "Độ dài của tên phải từ 5-50 ký tự";
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập lại số điện thoại";
    }
    if (value.length < 10 || value.length > 11) {
      return "Số điện thoại sai định dạng";
    }
    final RegExp phoneRegExp = RegExp(r'^(0[1-9][0-9]{8})$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Số điện thoại sai định dạng";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập mật khẩu";
    }
     if (value.length < 8 || value.length > 40){
      return "Độ dài của mật khẩu phải từ 8-40 ký tự";
    }
    final RegExp passRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
    if (!passRegExp.hasMatch(value)) {
      return "Mật khẩu phải có cả kí tự và số";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập mật khẩu xác nhận";
    }
    if (_txtPassword.text != value){
      return "Mật khẩu xác nhận không khớp";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const Text(
                    "Chào mừng bạn đến với",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                          child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                  'assets/myassets/logo_capstone.png')),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        AppConfig.TITLE,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  _changeStateScreen(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn đã có tài khoản? ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  _changeStateScreen() {
    switch (_stateScreen) {
      case 0:
        return _stateRegister();
      case 1:
        return _stateOTP();
      case 2:
        return _statePassword();
      default:
        return _stateRegister();
    }
  }

  _stateRegister() {
    return Column(
      children: [
        Form(
            key: _formKeyStateOne,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _txtName,
                    validator: _validateName,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      labelText: "Tên người dùng",
                      hintText: "Tên người dùng",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _txtPhone,
                    validator: _validatePhone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Số điện thoại",
                      hintText: "Số điện thoại",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Lưu ý: Hệ thống sẽ gửi mã OTP đến số điện thoại này để xác thực tài khoản.",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.primarySecond),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Tiếp tục (1/3)',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        try {
                          if (_formKeyStateOne.currentState!.validate()) {
                            DialogHelper.showLoading(context);
                            bool isStateOne =
                                await UserService.registerStepOne(
                                    _txtName.text, _txtPhone.text);
                            if (!context.mounted) return;
                            DialogHelper.hideLoading(context);
                            if (!isStateOne) {
                              Fluttertoast.showToast(
                                msg: "Số điện thoại đã tồn tại",
                              );
                            } else {
                              setState(() {
                                _stateScreen = 1;
                              });
                            }
                          }
                        } catch (error) {
                          DialogHelper.hideLoading(context);
                          DialogHelper.showAwesomeDialogError(context, error.toString());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  _stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Hệ thống sẽ gửi mã OTP đến\n",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(height: 10),
              ),
              TextSpan(
                text: _txtPhone.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(height: 40),
              ),
              const TextSpan(
                text: "\nNhập mã OTP!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        PinCodeTextField(
          appContext: context,
          keyboardType: TextInputType.number,
          length: 5,
          onChanged: (value) {
            setState(() {
              _otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: AppTheme.primarySecond,
            selectedColor: AppTheme.primarySecond,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Không nhận được mã OTP? ',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  DialogHelper.showLoading(context);
                await UserService.resendOTP(_txtPhone.text);
                if (!context.mounted) return;
                DialogHelper.hideLoading(context);
                 } catch (error){
                DialogHelper.hideLoading(context);
                DialogHelper.showAwesomeDialogError(context, error.toString());
              }
              },
              child: const Text(
                'Gửi lại',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppTheme.primarySecond),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text(
              'Tiếp tục (2/3)',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                DialogHelper.showLoading(context);
                _tokenStateTwo =
                    await UserService.registerStepTwo(_otpPin, _txtPhone.text);
                    if(!context.mounted) return;
                    DialogHelper.hideLoading(context);

                if (_tokenStateTwo == '') {
                  Fluttertoast.showToast(
                    msg: "Mã OTP không khớp",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    fontSize: 16.0,
                  );
                } else {
                  setState(() {
                    _stateScreen = 2;
                  });
                }
              } catch (error) {
                DialogHelper.hideLoading(context);
                DialogHelper.showAwesomeDialogError(context, error.toString());
              }
              // setState(() {
              //       _stateScreen = 2;
              //     });
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              setState(() {
                _stateScreen = 0;
              });
            },
            child: const Text(
              "Quay lại",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _statePassword() {
    return Column(
      children: [
        Form(
            key: _formKeyStateThree,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _txtPassword,
                    obscureText: _isHidden,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.fingerprint),
                      labelText: "Mật khẩu",
                      hintText: "Mật khẩu",
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          icon: Icon(_isHidden
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: _isHiddenConfirm,
                    controller: _txtConfirmPassword,
                    validator: _validateConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.fingerprint),
                      labelText: "Nhập lại mật khẩu",
                      hintText: "Nhập lại mật khẩu",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isHiddenConfirm = !_isHiddenConfirm;
                          });
                        },
                        icon: Icon(_isHiddenConfirm
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.primarySecond),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Đăng ký (3/3)',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        try {
                          if (_formKeyStateThree.currentState!.validate()) {
                            DialogHelper.showLoading(context);
                            bool isStateThree =
                                await UserService.registerStepThree(
                                    _txtPassword.text, _tokenStateTwo);

                            if (!context.mounted) return;
                            DialogHelper.hideLoading(context);
                            if (!isStateThree) {
                              Fluttertoast.showToast(
                                msg: "Tạo mật khẩu thất bại",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                fontSize: 16.0,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Tạo tài khoản thành công",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                fontSize: 16.0,
                              );
                              StorageRepository.savePhone(_txtPhone.text);
                          StorageRepository.savePassword(
                                    _txtPassword.text);
                          StorageRepository.saveIsRemember();
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                              ),
                            );
                            }
                          }
                        } catch (error) {
                          DialogHelper.hideLoading(context);
                          DialogHelper.showAwesomeDialogError(context, error.toString());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
