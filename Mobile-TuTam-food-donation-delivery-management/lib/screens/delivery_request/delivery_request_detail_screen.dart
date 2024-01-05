import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/image_for_delivery_unit.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/report_delivery_request_screen.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/update_item_delivery_screen.dart';
import 'package:food_donation_delivery_app/services/delivery_request_service.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/utils/delivery_request_utils.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_aim_card.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/donated_item_detail_card.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class DeliveryRequestDetailScreen extends StatefulWidget {
  final String idDeliveryRequest;
  final bool isRunning;
  const DeliveryRequestDetailScreen(
      {super.key, required this.idDeliveryRequest, required this.isRunning});

  @override
  State<DeliveryRequestDetailScreen> createState() =>
      _DeliveryRequestDetailScreenState();
}

class _DeliveryRequestDetailScreenState
    extends State<DeliveryRequestDetailScreen> {
  bool _isImport = true;
  List<DeliveryItems> _deliveryItems = List.empty(growable: true);
  final ScheduleRouteController _routeController = Get.find();
  late OrderedDeliveryRequests _deliveryRequests;
  bool _isRefresh = true;

  Widget _buttonStatus() {
    String? status = _routeController
        .getOrderDeliveryRequestById(widget.idDeliveryRequest)
        .status;
    switch (status) {
      case 'PENDING' || 'ACCEPTED':
        return const ButtonChangeStatus(
          onPress: null,
          // () {
          //   setState(() {
          //     _routeController.updateStatusDeliveryRequest(
          //         widget.idDeliveryRequest, 'SHIPPING');
          //   });
          // },
          color: Colors.grey,
          text: 'Không có quyền',
        );
      case 'SHIPPING':
        return ButtonChangeStatus(
          onPress: () async {
            try {
              DialogHelper.showLoading(context);
              bool isSuccess = _isImport
                  ? await DeliveryRequestService
                      .updateNextStatusDeliveryRequest(
                          deliveryRequestId: widget.idDeliveryRequest)
                  : await ScheduleRouteService
                      .updateAllDeliveryInScheduledRoute(
                          scheduledRouteId:
                              _routeController.scheduleRouteDetail.value.id);

              if (!context.mounted) return;
              DialogHelper.hideLoading(context);

              if (isSuccess) {
                setState(() {
                  _routeController.updateStatusDeliveryRequest(
                      widget.idDeliveryRequest, 'ARRIVED_PICKUP');

                  if (!_isImport) {
                    _routeController.scheduleRouteDetail.value
                            .orderedDeliveryRequests.last.status =
                        _routeController.scheduleRouteDetail.value
                            .orderedDeliveryRequests.first.status;
                  }
                });
              } else {
                Fluttertoast.showToast(msg: 'Thất bại');
              }
            } catch (error) {
              DialogHelper.hideLoading(context);
              DialogHelper.showAwesomeDialogError(context, error.toString());
            }
          },
          text: 'Đã đến',
        );
      case 'ARRIVED_PICKUP':
        return ButtonChangeStatus(
          onPress: () async {
            try {
              if (_routeController.scheduleRouteDetail.value.type == 'IMPORT') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateItemDeliveryScreen(
                      idDeliveryRequest: widget.idDeliveryRequest,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      _routeController.updateStatusDeliveryRequest(
                          widget.idDeliveryRequest, 'COLLECTED');
                    });
                  }
                });
              } else {
                DialogHelper.showLoading(context);
                bool isSuccess = await ScheduleRouteService
                    .updateAllDeliveryInScheduledRoute(
                        scheduledRouteId:
                            _routeController.scheduleRouteDetail.value.id);

                if (!context.mounted) return;
                DialogHelper.hideLoading(context);

                if (isSuccess) {
                  setState(() {
                    _routeController.updateStatusDeliveryRequest(
                        widget.idDeliveryRequest, 'COLLECTED');
                  });
                  if (!_isImport) {
                    _routeController.scheduleRouteDetail.value
                            .orderedDeliveryRequests.last.status =
                        _routeController.scheduleRouteDetail.value
                            .orderedDeliveryRequests.first.status;
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Thất bại');
                }
              }
            } catch (error) {
              DialogHelper.hideLoading(context);
              DialogHelper.showAwesomeDialogError(context, error.toString());
            }
          },
          text: 'Lấy vật phẩm',
        );
      case 'REPORTED':
        return const ButtonChangeStatus(
          onPress: null,
          text: 'Báo cáo',
          color: Colors.grey,
        );
      case 'COLLECTED' || null:
        if (_isImport && widget.idDeliveryRequest.isNotEmpty ||
            !_isImport && widget.idDeliveryRequest.isEmpty) {
          return const ButtonChangeStatus(
            onPress: null,
            color: Colors.grey,
            text: 'Đã lấy',
          );
        } else {
          return ButtonChangeStatus(
            onPress: () async {
              try {
                DialogHelper.showLoading(context);
                bool isSuccess = _isImport
                    ? await ScheduleRouteService
                        .updateAllDeliveryInScheduledRoute(
                            scheduledRouteId:
                                _routeController.scheduleRouteDetail.value.id)
                    : await DeliveryRequestService
                        .updateNextStatusDeliveryRequest(
                            deliveryRequestId: widget.idDeliveryRequest);
                if (!context.mounted) return;
                DialogHelper.hideLoading(context);

                if (isSuccess) {
                  // if(!_isImport){
                  //     _routeController.scheduleRouteDetail.value.orderedDeliveryRequests.last.status = _routeController.scheduleRouteDetail.value.orderedDeliveryRequests.first.status;
                  //   }
                  setState(() {
                    _routeController.updateStatusDeliveryRequest(
                        widget.idDeliveryRequest, 'ARRIVED_DELIVERY');
                  });
                } else {
                  Fluttertoast.showToast(msg: 'Thất bại');
                }
              } catch (error) {
                DialogHelper.hideLoading(context);
                DialogHelper.showAwesomeDialogError(context, error.toString());
              }
            },
            text: 'Đã đến điểm giao',
          );
        }
      case 'ARRIVED_DELIVERY':
        if (_isImport && widget.idDeliveryRequest.isNotEmpty ||
            !_isImport && widget.idDeliveryRequest.isEmpty) {
          return const ButtonChangeStatus(
            onPress: null,
            color: Colors.grey,
            text: 'Đã lấy',
          );
        } else {
          if (_isImport) {
            return ButtonChangeStatus(
              onPress: () async {
                try {
                  DialogHelper.showLoading(context);
                  bool isSuccess = await ScheduleRouteService
                      .updateAllDeliveryInScheduledRoute(
                          scheduledRouteId:
                              _routeController.scheduleRouteDetail.value.id);
                  if (!context.mounted) return;
                  DialogHelper.hideLoading(context);

                  if (isSuccess) {
                    // if(!_isImport){
                    //     _routeController.scheduleRouteDetail.value.orderedDeliveryRequests.last.status = _routeController.scheduleRouteDetail.value.orderedDeliveryRequests.first.status;
                    //   }
                    setState(() {
                      _routeController.updateStatusDeliveryRequest(
                          widget.idDeliveryRequest, 'DELIVERED');
                    });
                  } else {
                    Fluttertoast.showToast(msg: 'Thất bại');
                  }
                } catch (error) {
                  DialogHelper.hideLoading(context);
                  DialogHelper.showAwesomeDialogError(
                      context, error.toString());
                }
              },
              text: 'Hoàn thành',
            );
          } else {
            return ButtonChangeStatus(
              onPress: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageForDeliveryUnit(
                            idDeliveryRequest: widget.idDeliveryRequest,
                          )),
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      _routeController.updateStatusDeliveryRequest(
                          widget.idDeliveryRequest, 'FINISHED');
                    });
                    Fluttertoast.showToast(msg: 'Bạn đã hoàn thành');
                  }
                });
              },
              text: 'Hoàn thành',
            );
          }
        }

      case 'DELIVERED':
        return const ButtonChangeStatus(
          onPress: null,
          color: Colors.grey,
          text: 'Đã giao',
        );

      // code test logic
      // if (_isImport && widget.idDeliveryRequest.isNotEmpty ||
      //     !_isImport && widget.idDeliveryRequest.isEmpty) {
      //   return const ButtonChangeStatus(
      //     onPress: null,
      //     color: Colors.grey,
      //     text: 'Đã giao',
      //   );
      // } else {
      //   return ButtonChangeStatus(
      //     onPress: () {
      //       setState(() {
      //         _routeController.updateStatusDeliveryRequest(
      //             widget.idDeliveryRequest, 'FINISHED');
      //       });
      //     },
      //     text: 'Giao Hàng',
      //   );
      // }

      case 'FINISHED':
        return const ButtonChangeStatus(
          onPress: null,
          color: Colors.grey,
          text: 'Hoàn thành',
        );
      default:
        return const ButtonChangeStatus(
          onPress: null,
          color: Colors.grey,
          text: 'Error',
        );
    }
  }

  String _textItems() {
    if (_isImport && widget.idDeliveryRequest.isNotEmpty) {
      return 'Danh sách các vật phẩm nhận';
    }

    if (_isImport && widget.idDeliveryRequest.isEmpty) {
      return 'Danh sách các vật phẩm giao';
    }

    if (!_isImport && widget.idDeliveryRequest.isNotEmpty) {
      return 'Danh sách các vật phẩm giao';
    }

    if (!_isImport && widget.idDeliveryRequest.isEmpty) {
      return 'Danh sách các vật phẩm nhận';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();

    _isImport = _routeController.scheduleRouteDetail.value.type == 'IMPORT';
    _deliveryRequests =
        _routeController.getOrderDeliveryRequestById(widget.idDeliveryRequest);
    _deliveryItems = _deliveryRequests.deliveryItems ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Đơn vận chuyển'),
              const SizedBox(
                width: 10,
              ),
              _routeController
                          .getOrderDeliveryRequestById(widget.idDeliveryRequest)
                          .status ==
                      null
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: DeliveryRequestUtils.colorStatus(_routeController
                                .getOrderDeliveryRequestById(
                                    widget.idDeliveryRequest)
                                .status ??
                            ''),
                      ),
                      child: Text(
                          DeliveryRequestUtils.textStatus(_routeController
                                  .getOrderDeliveryRequestById(
                                      widget.idDeliveryRequest)
                                  .status ??
                              ''),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deliveryRequests.images.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          height: 200,
                          child: PageView.builder(
                              controller: PageController(viewportFraction: 1),
                              itemCount: _deliveryRequests.images.length,
                              itemBuilder: (context, index) {
                                return Image(
                                  image: NetworkImage(
                                      _deliveryRequests.images[index]),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 200,
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                  Row(
                    children: [
                      ActivityAimCard(
                          title: 'Ngày nhận',
                          subTitle: Utils.converDate(
                              _deliveryRequests.currentScheduledTime?.day),
                          colorIcon: const Color(0xFF27FF5E),
                          icon: Icons.calendar_month),
                      ActivityAimCard(
                          title: 'Thời gian nhận',
                          subTitle:
                              '${_deliveryRequests.currentScheduledTime?.startTime}-${_deliveryRequests.currentScheduledTime?.endTime}',
                          colorIcon: const Color(0xFF5BC3F8),
                          icon: Icons.alarm),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.idDeliveryRequest.isEmpty
                              ? 'Thông tin chi nhánh'
                              : _isImport
                                  ? 'Thông tin người quyên góp'
                                  : 'Thông tin tổ chức nhận',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            _deliveryRequests.avatar),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _deliveryRequests.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _deliveryRequests.phone,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('Địa chỉ: ${_deliveryRequests.address}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _textItems(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _deliveryItems.length,
                          itemBuilder: (context, index) =>
                              DonatedItemDetailCard(
                            image: _deliveryItems[index].image,
                            name: _deliveryItems[index].name,
                            quantity: (_deliveryItems[index].receivedQuantity ??
                                    _deliveryItems[index].quantity)
                                .toString(),
                            expiredDate: _deliveryItems[index].expiredDate,
                            unit: _deliveryItems[index].unit,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 450,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(_deliveryRequests.location.first,
                            _deliveryRequests.location.last),
                        zoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 30.0,
                              height: 30.0,
                              point: LatLng(_deliveryRequests.location.first,
                                  _deliveryRequests.location.last),
                              builder: (ctx) => const Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: -10,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 70,
                  // )
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Visibility(
                visible: widget.isRunning,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(4.0)),
                            elevation: MaterialStateProperty.all(1),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(((_deliveryRequests.status == 'SHIPPING' || _deliveryRequests.status == 'ARRIVED_PICKUP')&& _routeController.scheduleRouteDetail.value.type == 'IMPORT' ) ?
                                Colors.red : Colors.grey)),
                        onPressed: ((_deliveryRequests.status == 'SHIPPING' || _deliveryRequests.status == 'ARRIVED_PICKUP')&& _routeController.scheduleRouteDetail.value.type == 'IMPORT' )  ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDeliveryRequestScreen(
                                orderedDeliveryRequests: _deliveryRequests,
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                _isRefresh = !_isRefresh;
                              });
                            }
                          });
                        } : null,
                        icon: const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(4.0)),
                            elevation: MaterialStateProperty.all(1),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: () {
                          FlutterPhoneDirectCaller.callNumber(_deliveryRequests.phone);
                        },
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(child: _buttonStatus()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonChangeStatus extends StatelessWidget {
  final void Function()? onPress;
  final String text;
  final Color color;

  const ButtonChangeStatus(
      {super.key,
      required this.onPress,
      required this.text,
      this.color = AppTheme.primarySecond});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
