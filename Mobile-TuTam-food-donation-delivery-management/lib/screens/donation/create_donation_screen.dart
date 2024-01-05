import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/models/activity_detail.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/models/scheduled_times_object.dart';
import 'package:food_donation_delivery_app/screens/map/open_street_map_custom_screen.dart';
import 'package:food_donation_delivery_app/screens/other/select_photo_options_screen.dart';
import 'package:food_donation_delivery_app/services/donated_request_service.dart';
import 'package:food_donation_delivery_app/services/utils_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/calendar_multi_card.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/item_donation_create_card.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/search_item_donation_dialog.dart';
import 'package:food_donation_delivery_app/widgets/time_select_widget.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CreateDonationScreen extends StatefulWidget {
  final ActivityDetail? activity;
  final List<ItemList>? itemsList;
   
  const CreateDonationScreen({
    super.key, 
    this.activity,
    this.itemsList
    });

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<ScheduledTimesObject> _timeObjects = List.empty(growable: true);
  bool _isAll = true;
  int _indexDate = -1;
  List<File> _images = List.empty(growable: true);
  List<ItemList> _itemsList = List.empty(growable: true);
  final int _limitImage = AppConfig.LIMIT_No_IMAGE_DONATED_REQUEST;
  final TextEditingController _txtAddress = TextEditingController();
  final TextEditingController _txtNote = TextEditingController();
  double _latitude = 0;
  double _longitude = 0;
  final UserController _userController = Get.find();

  String _messageListImageError = '';
  String _messageListItemError = '';
  String _messageListTimeError = '';
  String _messageTimeInListError = '';
  String _messageAddressError = '';
  String _messageNoteError = '';

  String _messageTimeError = '';
  bool _isRefresh = false;

  void _addItemToList(ItemList item) {
    _messageListItemError = '';
    if (_itemsList
        .any((element) => element.itemTemplateId == item.itemTemplateId)) {
      
      Fluttertoast.showToast(
        msg:'Vật phẩm đã được thêm vào trước đó',
        gravity: ToastGravity.CENTER
        );
    } else {
      item.initialExpirationDate = DateTime.now().add(const Duration(days: 2));
      item.leftDate = 2;
      setState(() {
        _itemsList.add(item);
      });
    }
  }

  Future<String> _checkAddress()async{
    bool isNear = await UtilsService.checkNearbyBranchByLocation(latitude: _latitude, longitude: _longitude);
    if (isNear){
      return '';
    }
    return 'Rất tiếc, bạn đang ở ngoài khu vực hỗ trợ của chúng tôi. Chúng tôi chỉ có thể cung cấp hỗ trợ trong phạm vi chạy 10km gần các chi nhánh.';
  }

  String _checkExpiredDayToDelivery(){
    DateTime? date = _itemsList.reduce((a, b) => a.initialExpirationDate!.isBefore(b.initialExpirationDate!) ? a : b).initialExpirationDate;
    String message = '';
    for (var item in _timeObjects){

      if (Utils.subDate(item.day.toString(), date!.toString()) >= 2){
        //  item.isValid = true;
      }else{
        message = 'Vật phẩm sẽ hết hạn trong những ngày này, vui lòng chọn những ngày giao trước các vật phẩm hết hạn 2 ngày';
      }
    }
    return message;
  }

  bool _checkData()  {
    _messageListImageError =
        _images.isEmpty ? 'Vui lòng chọn ít nhất từ 1 đến 5 ảnh' : '';
    _messageListItemError =
        _itemsList.isEmpty ? 'Vui lòng chọn vật phẩm quyên góp' : '';
    _messageListTimeError =
        _timeObjects.isEmpty ? 'Vui lòng chọn thời gian nhận' : '';
    _messageNoteError = _txtNote.text.length > 500 ? 'Ghi chú có độ dài nhỏ hơn 500 ký tự' : '';
    
    if (_messageAddressError.isEmpty){
    _checkAddress().then((value) => _messageAddressError = value);}

   
      _messageListItemError = _checkListItem()
          ? 'Vui lòng kiểm tra số lượng vật phẩm quyên góp'
          : '';
      _messageTimeInListError = _checkListTimeObject();

//  if (_messageListItemError.isEmpty){
      //   _messageTimeInListError = _messageTimeInListError.isEmpty
      // ?  _checkListTimeObject()
      // : _messageTimeInListError ;
      // }

    // _messageTimeInListError = _messageTimeInListError.isEmpty 
    // ? _checkExpiredDayToDelivery()
    // : _messageTimeInListError;

    setState(() {
      _isRefresh = !_isRefresh;
    });

    if (_messageListImageError.isNotEmpty ||
        _messageListItemError.isNotEmpty ||
        _messageListTimeError.isNotEmpty ||
        _messageTimeInListError.isNotEmpty ||
        _messageTimeError.isNotEmpty ||
        _messageAddressError.isNotEmpty ||
        _messageNoteError.isNotEmpty
        ) return false;
    return true;
  }

  bool _checkListItem() {
    // false: Ok
    // true: item have error (0 quantity)
    bool isSuccess = false;
    for (var item in _itemsList) {
      if (item.isValid != 1) {
        item.isValid = -1;
        isSuccess = true;
      }
    }
    return isSuccess;
  }

  String _checkListTimeObject() {
    String message = '';
    if (_timeObjects.isNotEmpty) {
      for (var element in _timeObjects) {
        if (element.endTime == null ||
            element.startTime == null ||
            element.isValid == false
            ) {
          message = 'Vui lòng kiểm tra lại thời gian nhận';
          element.isValid = false;
        } else {
          if ( Utils.converDate(element.day.toString()) == Utils.converDate(DateTime.now().toString())
            &&
            Utils.compareTimeOfDay(TimeOfDay.now(), element.startTime!) < 60){
              message = 'Thời gian bắt đầu nhận của ngày hôm nay phải sớm hơn thời gian hiện tại là 1 tiếng';
          element.isValid = false;
          break;
          } else {
                message = message.isEmpty
                ? _checkExpiredDayToDelivery()
                : _messageTimeInListError;
          }
        }
      }
    }
    return message;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      if (img != null) {
        _messageListImageError = '';
        setState(() {
          _images.add(img!);
          Navigator.of(context).pop();
        });
      }
    } on PlatformException catch (_) {
      
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
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

  bool _checkTimeToday(TimeOfDay time) {
    if (_indexDate != -1 &&
        Utils.converDate(_timeObjects[_indexDate].day.toString()) ==
            Utils.converDate(DateTime.now().toString())) {
      int compareTwoTime = Utils.compareTimeOfDay(TimeOfDay.now(), time);

      if (compareTwoTime < 0) {
        return false;
      }
    }
    return true;
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _timeObjects[_indexDate].startTime ?? TimeOfDay.now(),
      helpText: 'Chọn thời gian bắt đầu',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null && pickedTime != _startTime) {
      if (_checkTimeToday(pickedTime)) {
        if (_endTime != null) {
          int endTimeMinutes = _endTime!.hour * 60 + _endTime!.minute;
          int startTimeMinutes = pickedTime.hour * 60 + pickedTime.minute;
          if (endTimeMinutes - startTimeMinutes < 60) {
            _messageTimeError =
                'Thời gian bắt đầu phải trước thời gian kết thúc ít nhất 1 tiếng';
            _timeObjects[_indexDate].isValid = false;
          } else {
            _messageTimeError = '';
            _timeObjects[_indexDate].isValid = true;
          }
        }
      } else {
        _messageTimeError =
            'Thời gian bắt đầu phải sau thời gian hiện tại';
        _timeObjects[_indexDate].isValid = false;
      }

      _startTime = pickedTime;
      _timeObjects[_indexDate].startTime = pickedTime;
      if (_isAll) {
        for (var element in _timeObjects) {
          element.startTime = pickedTime;
          element.isValid = _timeObjects[_indexDate].isValid;
        }
      }
      setState(() {
        _isRefresh = !_isRefresh;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _timeObjects[_indexDate].endTime ?? TimeOfDay.now(),
      helpText: 'Chọn thời gian kết thúc',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _endTime) {
      if (_checkTimeToday(pickedTime)) {
        if (_startTime != null) {
          int endTimeMinutes = pickedTime.hour * 60 + pickedTime.minute;
          int startTimeMinutes = _startTime!.hour * 60 + _startTime!.minute;
          if (endTimeMinutes - startTimeMinutes <= 60) {
            _messageTimeError =
                'Thời gian kết thúc phải sau thời gian bắt đầu ít nhất 1 tiếng';
            _timeObjects[_indexDate].isValid = false;
          } else {
            _messageTimeError = '';
            _timeObjects[_indexDate].isValid = true;
          }
        }
      } else {
        _messageTimeError =
            'Thời gian kết thúc phải sau thời gian hiện tại';
        _timeObjects[_indexDate].isValid = false;
      }
      _endTime = pickedTime;
      _timeObjects[_indexDate].endTime = pickedTime;
      if (_isAll) {
        for (var element in _timeObjects) {
          element.endTime = pickedTime;
          element.isValid = _timeObjects[_indexDate].isValid;
        }
      }
      setState(() {
        _isRefresh = !_isRefresh;
      });
    }
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

  @override
  void initState() {
    super.initState();

    _txtAddress.text = _userController.address.value;
    _latitude = double.parse(_userController.location.value.split(',')[0]);
    _longitude = double.parse(_userController.location.value.split(',')[1]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo yêu cầu quyên góp đồ'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.activity == null 
                ? const SizedBox()
                : Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quyên góp cho hoạt động:'),
                        Text(widget.activity!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text: 'Thực hiện bởi: ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            TextSpan(
                                text: widget.activity!
                                  .branchResponses
                                  .map((e) => e.name)
                                  .toList()
                                  .join(', '),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87)),
                          ]),
                        ),
                        Text(
                          'Thời gian: ${Utils.converDate(widget.activity!.startDate == '' ? widget.activity!.estimatedStartDate : widget.activity!.startDate)} - ${Utils.converDate(widget.activity!.endDate == '' ? widget.activity!.estimatedEndDate : widget.activity!.endDate)}',
                                    style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text('Chụp ảnh vật phẩm:',
                    style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemCount: _images.length < _limitImage
                          ? (_images.length + 1)
                          : _images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0 && _images.length < _limitImage) {
                          return GestureDetector(
                            onTap: () {
                              _showSelectPhotoOptions(context);
                            },
                            child: Container(
                                width: 150,
                                height: 100,
                                margin: const EdgeInsets.all(4.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppTheme.greyBackground,
                                ),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: _messageListImageError.isEmpty
                                      ? Colors.black
                                      : Colors.red,
                                  strokeWidth: 1.0,
                                  radius: const Radius.circular(8.0),
                                  dashPattern: const [10, 5],
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 40,
                                          color: _messageListImageError.isEmpty
                                              ? Colors.black
                                              : Colors.red,
                                        ),
                                        Text(
                                          'Thêm ảnh',
                                          style: TextStyle(
                                            color:
                                                _messageListImageError.isEmpty
                                                    ? Colors.black
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: FileImage(_images[
                                      _images.length < _limitImage
                                          ? index - 1
                                          : index]),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 8,
                                right: 8,
                                child: 
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.removeAt(
                                          _images.length < _limitImage
                                              ? index - 1
                                              : index);
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                     borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ),
                          ],
                        );
                      }),
                ),
                const SizedBox(
                  height: 4,
                ),
                _messageListImageError.isNotEmpty
                    ? Text(
                        _messageListImageError,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Text('Chọn vật phẩm quyên góp:',
                    style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SearchItemDonationDialog(
                                onTap: _addItemToList,
                                list: widget.itemsList,
                              );
                            });
                      },
                    )
                  ],
                ),
                _messageListItemError.isNotEmpty
                    ? Text(
                        _messageListItemError,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                ListView.builder(
                  itemCount: _itemsList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ItemDonationCreateCard(
                    onDelete: () {
                      setState(() {
                        _itemsList.removeAt(index);
                      });
                    },
                    item: _itemsList[index],
                    updateItem: (value) {
                      setState(() {
                        _itemsList[index] = value;
                      });
                    },
                  ),
                ),
                Visibility(
                    visible: _itemsList.isNotEmpty,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Ngày nhận:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CalendarMultiCard(
                                      listDate: _timeObjects
                                          .map((e) => e.day)
                                          .toList(),
                                      onValueSelected: (value) {
                                        _indexDate = -1;
                                        List<ScheduledTimesObject> newList =
                                            List.empty(growable: true);
                                        if (value.isNotEmpty) {
                                          value.sort(
                                              (a, b) => a.day.compareTo(b.day));
                                          for (var e in value) {
                                            newList.add(_timeObjects.firstWhere(
                                              (element) => element.day == e,
                                              orElse: () {
                                                _timeObjects.add(
                                                    ScheduledTimesObject(
                                                        day: e,
                                                        startTime: null,
                                                        endTime: null));
                                                return ScheduledTimesObject(
                                                    day: e,
                                                    startTime: null,
                                                    endTime: null);
                                              },
                                            ));
                                          }
                                          _messageListTimeError = '';
                                        }
                                        setState(() {
                                          _timeObjects = newList;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        _messageListTimeError.isNotEmpty
                            ? Text(
                                _messageListTimeError,
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: _timeObjects.isEmpty ? 0 : 70,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _timeObjects.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _messageTimeError = '';
                                    _indexDate =
                                        index == _indexDate ? -1 : index;
                                    _startTime = _timeObjects[index].startTime;
                                    _endTime = _timeObjects[index].endTime;

                                    setState(() {
                                      _isRefresh = !_isRefresh;
                                    });
                                  },
                                  child: TimeSelectWidget(
                                    background:
                                    _indexDate == index ? AppTheme.primaryFirst 
                                       : (_messageTimeInListError.isNotEmpty &&
                                                _timeObjects[index].isValid ==
                                                    false)
                                            ? Colors.red
                                            :AppTheme.greyBackground,

                                            textColor: _indexDate == index ? Colors.white
                                            : (_messageTimeInListError.isNotEmpty &&
                                                _timeObjects[index].isValid ==
                                                    false)
                                            ? Colors.white
                                            // : _indexDate == index ? Colors.white 
                                            : Colors.black,
                                    txtDate: Utils.converDate(
                                        _timeObjects[index].day.toString()),
                                    txtHour: (_timeObjects[index].startTime ==
                                                null ||
                                            _timeObjects[index].endTime == null)
                                        ? ' - '
                                        : '${Utils.convertTimeTo24H(_timeObjects[index].startTime!)} - ${Utils.convertTimeTo24H(_timeObjects[index].endTime!)}',
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        _messageTimeInListError.isNotEmpty
                            ? Text(
                                _messageTimeInListError,
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                        Visibility(
                            visible: _indexDate != -1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    'Cài đặt thời gian nhận đươc vào ngày ${_indexDate < 0 ? '' : Utils.converDate(_timeObjects[_indexDate].day.toString())}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4.0))),
                                      ),
                                      onPressed: () =>
                                          _selectStartTime(context),
                                      child: Text(_startTime != null ? Utils.convertTimeTo24H(_startTime!) :
                                          "Thời gian bắt đầu"),
                                    ),
                                    const Text(' : '),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4.0))),
                                      ),
                                      onPressed: () => _selectEndTime(context),
                                      child: Text(_endTime != null ? Utils.convertTimeTo24H(_endTime!) :
                                          "Thời gian kết thúc"),
                                    ),
                                  ],
                                ),
                                _messageTimeError.isNotEmpty
                                    ? Text(
                                        _messageTimeError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _isAll,
                                        onChanged: (value) async {
                                          _isAll = !_isAll;
                                          if (_isAll == true &&
                                              _endTime != null &&
                                              _startTime != null) {
                                            for (var element in _timeObjects) {
                                              element.startTime = _startTime;
                                              element.endTime = _endTime;
                                            }
                                          }
                                          setState(() {
                                            _isRefresh = !_isRefresh;
                                          });
                                        }),
                                    const Text("Áp dụng tất cả ngày")
                                  ],
                                ),
                              ],
                            )),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text('Địa chỉ nhận hàng:',
                style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  keyboardType: TextInputType.none,
                  controller: _txtAddress,
                  maxLines: (_txtAddress.text.length / 35).ceil(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(LineAwesomeIcons.map),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenStreetMapCustomScreen(
                          locationBranches: widget.activity == null ? [] : widget.activity!.branchResponses.map((e) => e.location).toList(),
                          latitude: _latitude,
                          longitude: _longitude,
                          onTap: (adrress, latitude, longitude) async{
                            _txtAddress.text = adrress;
                            _latitude = latitude;
                            _longitude = longitude;

                            _messageAddressError = await _checkAddress();
                            setState(() {
                              _isRefresh = !_isRefresh;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                _messageAddressError.isNotEmpty
                                    ? Text(
                                        _messageAddressError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                const Text('Ghi chú:',
                style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),),
                const SizedBox(
                  height: 4,
                ),
                TextField(
                  maxLines: _txtNote.text.length < 35*3 ? 3 : (_txtNote.text.length/ 35).ceil(),
                  controller: _txtNote,
                  onChanged: (value){
                    setState(() {
                      _isRefresh = !_isRefresh;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Những điều cần lưu ý khi lấy vật phẩm',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
                _messageNoteError.isNotEmpty
                                    ? Text(
                                        _messageNoteError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          DialogHelper.showLoading(context);

                          bool isValid = _checkData();
                        if (!isValid) {
                          Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              msg: 'Vui lòng kiểm tra lại thông tin',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER);
                        } else {
                          bool isSuccess =
                              await DonatedRequestService.createDonatedRequest(
                                  images: _images,
                                  address: _txtAddress.text,
                                  latitude: _latitude,
                                  longitude: _longitude,
                                  scheduledTime: _timeObjects,
                                  note: _txtNote.text,
                                  items: _itemsList,
                                  activityId: widget.activity?.id  //== null ? null : widget.activity?.id
                                  );
                          if (isSuccess){
                             Fluttertoast.showToast(msg: 'Tạo yêu cầu quyên góp thành công',
                             gravity: ToastGravity.CENTER
                            );

                            if(!context.mounted) return;
                            DialogHelper.hideLoading(context);
                            Navigator.of(context).pop(true);
                          } else {
                            Fluttertoast.showToast(msg: 'Tạo yêu cầu quyên góp thất bại',
                          gravity: ToastGravity.CENTER
                          );
                          }
                        }
                         if (!context.mounted)return ;
                          DialogHelper.hideLoading(context);
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
      ),
    );
  }
}
