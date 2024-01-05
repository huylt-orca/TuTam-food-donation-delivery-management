import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({super.key});

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  bool _isPhone = false;
  bool _isEmail = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liên kết tài khoản'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số điện thoại: 0123456789',
                  ),
                  Switch(
                    value: _isPhone,
                    activeTrackColor: AppTheme.primarySecond,
                    activeColor: Colors.white,
                    onChanged: (bool value) {
                      if (_isEmail == false && value == false) {
                        Fluttertoast.showToast(
                            msg:
                                'Phải có ít nhất một phương thức đăng nhập cho tài khoản');
                      } else {
                        setState(() {
                          _isPhone = value;
                        });
                      }
                    },
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Email: .............@gmail.com',
                  ),
                  Switch(
                    value: _isEmail,
                    activeTrackColor: AppTheme.primarySecond,
                    activeColor: Colors.white,
                    onChanged: (bool value) {
                      if (_isPhone == false && value == false) {
                        Fluttertoast.showToast(
                            msg:
                                'Phải có ít nhất một phương thức đăng nhập cho tài khoản');
                      } else {
                      setState(() {
                        _isEmail = value;
                      });}
                    },
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
