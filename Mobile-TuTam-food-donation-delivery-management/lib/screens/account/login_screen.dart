import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:food_donation_delivery_app/screens/profile/update_profile_screen.dart';
import 'package:food_donation_delivery_app/services/auth_service.dart';
import 'package:food_donation_delivery_app/services/user_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:get/get.dart';
import '../../app_config.dart';
import '../../app_theme.dart';
import '../bottom_bar.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final UserController _userController = Get.find();
  bool _isHidden = true;
  bool _isRemember = false;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Nhập số điện thoại";
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
    return null;
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    _txtEmail.text = await StorageRepository.getPhone() ?? '';
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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    width: 120,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child:
                              Image.asset('assets/myassets/logo_capstone.png')),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      AppConfig.TITLE,
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _txtEmail,
                            validator: _validateUsername,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_outlined),
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
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: _isHidden,
                            controller: _txtPassword,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.fingerprint),
                              labelText: "Mật khẩu",
                              hintText: "Mật khẩu",
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                                icon: Icon(_isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: _isRemember,
                                      onChanged: (value) async {
                                        setState(() {
                                          _isRemember = !_isRemember;
                                        });
                                      }),
                                  const Text("Ghi nhớ đăng nhập")
                                ],
                              ),
                              TextButton(
                                onPressed: () async {},
                                child: const Text('Quên mật khẩu?'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
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
                        'Đăng nhập',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            DialogHelper.showLoading(context);

                            bool isSuccess = false;

                            if (_txtPassword.text.length >= 8 &&
                                _txtPassword.text.length <= 40) {
                              isSuccess = await _authService.loginWithPhone(
                                  _txtEmail.text, _txtPassword.text);
                            }

                            if (!context.mounted) return;
                            DialogHelper.hideLoading(context);

                            if (!isSuccess) {
                              
                              Fluttertoast.showToast(
                                msg: "Đăng nhập thất bại",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                fontSize: 16.0,
                              );
                            } else {
                              // UserService.updateDeviceToken();
                              // await UserService.getUserProfile();

                              await UserService.settingForUser();
                              
                              StorageRepository.savePhone(_txtEmail.text);
                              if (_isRemember) {
                                StorageRepository.savePassword(
                                    _txtPassword.text);
                                StorageRepository.saveIsRemember();
                              }
                              if (!context.mounted) return;
                              if (_userController.address.value.isEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfileScreen(
                                      isFirst: true,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomBar(),
                                  ),
                                );
                              }
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const BottomBar(),
                              //   ),
                              // );
                            }
                          }
                        } catch (error) {
                          Fluttertoast.showToast(msg: error.toString());
                          DialogHelper.hideLoading(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("- - - - - - - Hoặc - - - - - - -"),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    height: 50,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade900),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        bool isSuccess = false;
                        isSuccess = await _authService.loginWithGoogle();
                        if (isSuccess) {
                          if (!context.mounted) return;
                          DialogHelper.showLoading(context);
                          // UserService.getUserProfile();
                          await UserService.settingForUser();
                          
                          if (!context.mounted) return;
                          DialogHelper.hideLoading(context);
                    
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const BottomBar(),
                          //   ),
                          // );
                          if (_userController.address.value.isEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfileScreen(
                                      isFirst: true,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomBar(),
                                  ),
                                );
                              }

                        } else {
                          Fluttertoast.showToast(
                            msg: "Đăng nhập thất bại",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 20,
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          Text(
                            ' Đăng nhập bằng tài khoản Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản? Vui lòng ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Đăng ký',
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
}
