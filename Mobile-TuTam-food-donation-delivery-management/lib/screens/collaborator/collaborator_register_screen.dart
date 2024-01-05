import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/collaborator.dart';
import 'package:food_donation_delivery_app/screens/other/select_photo_options_screen.dart';
import 'package:food_donation_delivery_app/services/collaborator_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CollaboratorRegisterScreen extends StatefulWidget {
  const CollaboratorRegisterScreen({super.key});

  @override
  State<CollaboratorRegisterScreen> createState() =>
      _CollaboratorRegisterScreenState();
}

class _CollaboratorRegisterScreenState
    extends State<CollaboratorRegisterScreen> {
  File? _frontOfIdCardImage;
  File? _backOfIdCardImage;
  File? _image;
  final TextEditingController _txtFullName = TextEditingController();
  final TextEditingController _txtBirthDate = TextEditingController();
  int _selectedValueGender = 1;
  DateTime? _selectedDateBirth = DateTime.now();
  String _messageError = '';
  final _formKey = GlobalKey<FormState>();

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập họ và tên";
    }
    if (value.trim().length < 5 || value.trim().length > 50) {
      return "Độ dài tên phải từ 5-50 kí tự";
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập ngày sinh";
    }
    return null;
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedValueGender = value!;
    });
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      return img;
    } on PlatformException catch (_) {
      if (!context.mounted) return null;
      Navigator.of(context).pop();
    }
    return null;
  }

  Future<File?> _pickImageAvatar(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      File? img = File(image.path);
      img = await _cropImageAvatar(imageFile: img);
      return img;
    } on PlatformException catch (_) {
      
      if (!context.mounted) return null;
      Navigator.of(context).pop();
    }
    return null;
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
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

  Future<File?> _cropImageAvatar({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
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

  void _showSelectPhotoOptionsFront(BuildContext context) {
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
                onTap: (value) async {
                  File? img = await _pickImage(value);
                  if (img != null) {
                    setState(() {
                      _frontOfIdCardImage = img;
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            );
          }),
    );
  }

  void _showSelectPhotoOptionsBack(BuildContext context) {
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
                onTap: (value) async {
                  File? img = await _pickImage(value);
                  if (img != null) {
                    setState(() {
                      _backOfIdCardImage = img;
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            );
          }),
    );
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
                onTap: (value) async {
                  File? img = await _pickImageAvatar(value);
                  if (img != null) {
                    setState(() {
                      _image = img;
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng ký vận chuyển'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showSelectPhotoOptions(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: AppTheme.greyBackground,
                    ),
                    width: 120,
                    height: 120,
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 40,
                                color: (_messageError != '' && _image == null)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Text(
                                'Ảnh đại diện',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (_messageError != '' && _image == null)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: _validateFullName,
                      controller: _txtFullName,
                      decoration: const InputDecoration(
                        label: Text("Họ và tên"),
                        prefixIcon: Icon(LineAwesomeIcons.male),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        validator: _validateBirthDate,
                        controller: _txtBirthDate,
                        keyboardType: TextInputType.none,
                        decoration: const InputDecoration(
                          label: Text("Ngày sinh"),
                          prefixIcon: Icon(Icons.date_range),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateBirth ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (picked != null && picked != _selectedDateBirth) {
                            _txtBirthDate.text =
                                Utils.converDate(picked.toString());
                                _selectedDateBirth = picked;
                          }
                        }),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Giới tính',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text('Nam'),
                            value: 1,
                            groupValue: _selectedValueGender,
                            onChanged: _handleRadioValueChange,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text('Nữ'),
                            value: 0,
                            groupValue: _selectedValueGender,
                            onChanged: _handleRadioValueChange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Ảnh căn cước công dân mặt trước',
                style: TextStyle(
                  fontSize: 16,
                  color: (_messageError != '' && _frontOfIdCardImage == null)
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showSelectPhotoOptionsFront(context);
                },
                child: _frontOfIdCardImage == null
                    ? Container(
                        height: 200,
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.greyBackground,
                        ),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeWidth: 1.0,
                          radius: const Radius.circular(8.0),
                          dashPattern: const [10, 5],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 40,
                                  color: (_messageError != '' &&
                                          _frontOfIdCardImage == null)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                Text(
                                  'Ảnh căn cước công dân mặt trước',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (_messageError != '' &&
                                            _frontOfIdCardImage == null)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : Container(
                        height: 200,
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppTheme.greyBackground,
                            image: DecorationImage(
                                image: FileImage(_frontOfIdCardImage!),
                                fit: BoxFit.fill)),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Ảnh căn cước công dân mặt sau',
                style: TextStyle(
                  fontSize: 16,
                  color: (_messageError != '' && _backOfIdCardImage == null)
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showSelectPhotoOptionsBack(context);
                },
                child: _backOfIdCardImage == null
                    ? Container(
                        height: 200,
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.greyBackground,
                        ),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeWidth: 1.0,
                          radius: const Radius.circular(8.0),
                          dashPattern: const [10, 5],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 40,
                                  color: (_messageError != '' &&
                                          _backOfIdCardImage == null)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                Text(
                                  'Ảnh căn cước công dân mặt sau',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (_messageError != '' &&
                                            _backOfIdCardImage == null)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : Container(
                        height: 200,
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppTheme.greyBackground,
                            image: DecorationImage(
                              image: FileImage(_backOfIdCardImage!),
                              fit: BoxFit.fill,
                            )),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: true,
                child: Center(
                  child: Text(
                    _messageError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                        if (_image == null ||
                            _frontOfIdCardImage == null ||
                            _backOfIdCardImage == null) {
                          setState(() {
                            _messageError = 'Vui lòng điền đầy đủ thông tin';
                          });
                        } else {
                          DialogHelper.showLoading(context);
                          Collaborator collaborator = Collaborator(
                              phone: '',
                              email: '',
                              fullName: _txtFullName.text,
                              avatar: '',
                              dateOfBirth: _selectedDateBirth.toString(),
                              gender: '',
                              frontOfIdCard: '',
                              backOfIdCard: '',
                              note: '',
                              status: '',
                              genderNo: _selectedValueGender);

                          bool isSuccessful = await CollaboratorService()
                              .registerCollaborator(collaborator, _image!,
                                  _frontOfIdCardImage!, _backOfIdCardImage!);
                          
                          if (!context.mounted) return;
                          DialogHelper.hideLoading(context);

                          if (isSuccessful) {
                            Fluttertoast.showToast(
                                msg:
                                    "Đăng kí vận chuyển thành công");
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Đăng kí vận chuyển thất bại");
                          }
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
                      "Gửi",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
