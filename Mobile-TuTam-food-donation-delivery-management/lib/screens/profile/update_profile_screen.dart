import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/screens/bottom_bar.dart';
import 'package:food_donation_delivery_app/screens/map/open_street_map_screen.dart';
import 'package:food_donation_delivery_app/screens/other/select_photo_options_screen.dart';
import 'package:food_donation_delivery_app/services/user_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../controllers/user_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  final bool isFirst;
  const UpdateProfileScreen({
    Key? key,
    this.isFirst = false,
    }) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _txtFullName = TextEditingController();
  final TextEditingController _txtAddress = TextEditingController();
  final UserController userController = Get.find();
    final TextEditingController _txtPhone = TextEditingController();
  double _latitude = 0;
  double _longitude = 0;
  File? _image;

  final formKey = GlobalKey<FormState>();

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập họ và tên";
    }
    if (value.length < 5 || value.length > 50){
      return "Tên phải có độ dài từ 5-50 ký tự";
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập địa chỉ";
    }
    return null;
  }

    String? _validatePhone(String? value) {
      if (userController.phone.isEmpty){
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
    }
    return null;
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      )),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      if (img != null) {
        setState(() {
          _image = img;
          Navigator.of(context).pop();
        });
      }
    } on PlatformException catch (_) {

      if(!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cắt ảnh',
            toolbarColor: AppTheme.primarySecond,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  void initState() {
   
    super.initState();
    _txtFullName.text = userController.name.value;
    _txtAddress.text = userController.address.value;
    _latitude = double.parse(userController.location.value.split(',')[0]);
      _longitude = double.parse(userController.location.value.split(',')[1]);
    if (widget.isFirst){
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).then((value) {
        _latitude = value.latitude;
        _longitude = value.longitude;
      }).catchError((e) {});
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isFirst,
        title: const Text(
          "Cập nhật thông tin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _image == null
                            ? Image.network(
                                userController.avatar.value,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showSelectPhotoOptions(context);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppTheme.primarySecond,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: _validateFullName,
                      controller: _txtFullName,
                      decoration: const InputDecoration(
                        label: Text("Họ và tên"),
                        prefixIcon: Icon(LineAwesomeIcons.male),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      validator: _validateAddress,
                      controller: _txtAddress,
                      maxLines: _txtAddress.text.isEmpty ? 1 : (_txtAddress.text.length / 35).ceil(),
                      decoration: const InputDecoration(
                        label: Text("Địa chỉ"),
                        prefixIcon: Icon(LineAwesomeIcons.map),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenStreetMapScreen(
                              onTap: (adrress, latitude, longitude) {
                                setState(() {
                                  _txtAddress.text = adrress;
                                  _latitude = latitude;
                                  _longitude = longitude;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  userController.phone.isNotEmpty ? const SizedBox() : const SizedBox(
                    height: 10,
                  ),
                  userController.phone.isNotEmpty ? const SizedBox() : TextFormField(
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                            DialogHelper.showLoading(context);
                            bool isSuccessful = await UserService.putUser(
                              name: _txtFullName.text,
                              address: _txtAddress.text,
                              image: _image,
                              latitude: _latitude,
                              longitude: _longitude,
                              phone: _txtPhone.text
                              );

                            if (!context.mounted) return;
                            DialogHelper.hideLoading(context);
                            if (isSuccessful) {
                              if (widget.isFirst){
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => const BottomBar())
                                  );
                              }
                              Fluttertoast.showToast(
                                  msg: "Chỉnh sửa thông tin thành công");
                              UserService.getUserProfile();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Chỉnh sửa thông tin thất bại");
                            }
                          }
                          } catch (error){
                            DialogHelper.hideLoading(context);
                            DialogHelper.showAwesomeDialogError(context, error.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            backgroundColor: AppTheme.primarySecond),
                        child: const Text(
                          "Cập nhật",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
