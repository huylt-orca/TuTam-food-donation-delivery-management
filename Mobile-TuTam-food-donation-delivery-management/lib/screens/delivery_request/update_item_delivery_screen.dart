import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/services/delivery_request_service.dart';
import 'package:food_donation_delivery_app/services/utils_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/update_item_delivery_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class UpdateItemDeliveryScreen extends StatefulWidget {
  final String idDeliveryRequest;
  const UpdateItemDeliveryScreen({
    super.key,
    required this.idDeliveryRequest
    });

  @override
  State<UpdateItemDeliveryScreen> createState() => _UpdateItemDeliveryScreenState();
}

class _UpdateItemDeliveryScreenState extends State<UpdateItemDeliveryScreen> {
  String _messageError = '';
   File? _image;
    List<DeliveryItems> _deliveryItems = List.empty(growable: true);
  final ScheduleRouteController _routeController = Get.find();

  void _getData(){
    _deliveryItems = _routeController.getListDeliveryItemsClone(widget.idDeliveryRequest);
  }
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      return File(image.path);
      // if (context.mounted) DialogHelper.showLoading(context);

      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      // DateTime now = DateTime.now();

      // var imageRead = img.decodeImage(await File(image.path).readAsBytes());

      // img.fillRect(imageRead!,
      //     x1: 0,
      //     y1: 0,
      //     x2: imageRead.width,
      //     y2: 130,
      //     color: img.ColorRgba8(0, 0, 0, 100));
      // img.drawString(imageRead, '${position.latitude},${position.longitude}',
      //     font: img.arial48, x: 10, y: 20, color: img.ColorRgb8(255, 255, 255));
      // img.drawString(imageRead, now.toString(),
      //     font: img.arial48, x: 10, y: 70, color: img.ColorRgb8(255, 255, 255));

      // // Lưu ảnh mới vào tập tin tạm thời
      // final tempDir = await getTemporaryDirectory();
      // File tempImage = File('${tempDir.path}/temp_image.png')
      //   ..writeAsBytesSync(img.encodePng(imageRead));

      // if (context.mounted) DialogHelper.hideLoading(context);

      // return tempImage;
    } on PlatformException catch (_) {
      
      if (context.mounted) Navigator.of(context).pop();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách hàng nhận'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chụp một bức ảnh vật phẩm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
              ),
              const SizedBox(height: 8,),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.camera).then((value) {
                      if (value != null){
                        setState(() {
                          _image = value;
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppTheme.greyBackground,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
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
                                'Chụp ảnh vật phẩm',
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
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 4,),
              Text(_messageError,
              style: const TextStyle(
                color: Colors.red
              ),
              ),
              const SizedBox(
                height: 20,
              ),
               const Text('Danh sách vật phẩm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
              ),
              const SizedBox(height: 8,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _deliveryItems.length,
                itemBuilder: (context, index) =>  UpdateItemDeliveryCard(
                  item: _deliveryItems[index],
                  updateItem: (quantity){
                    setState(() {
                      _deliveryItems[index].receivedQuantity = quantity;
                    });
                  },
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
                        if (_image == null) {
                          setState(() {
                            _messageError = 'Vui lòng chụp một bức ảnh bằng chứng';
                          });
                        } else {
                          DialogHelper.showLoading(context);
                          for(var item in _deliveryItems){
                            // item.receivedQuantity = item.receivedQuantity ?? item.quantity;
                            _routeController.updateReceiveQuantity(
                              idDeliveryRequest: widget.idDeliveryRequest, 
                              idItem: item.deliveryItemId, 
                              quantity: item.receivedQuantity ?? item.quantity);
                          }
                          String imageUrl = await UtilsService.uploadImage(_image!);
                          // print(imageUrl);
                          // Navigator.of(context).pop(true);
                          bool isSuccess = await DeliveryRequestService.updateReceivedQuantity(
                            deliveryRequestId: widget.idDeliveryRequest, 
                            imageUrl: imageUrl, 
                            items: _routeController.getListDeliveryItemsClone(widget.idDeliveryRequest));
                            if (!context.mounted) return;
                            DialogHelper.hideLoading(context);
                          if (isSuccess){
                            Navigator.of(context).pop(true);
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
                      "Xác nhận",
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

