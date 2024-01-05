import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/map/delivery_map_screen.dart';
import 'package:food_donation_delivery_app/screens/map/route_detail_map_screen.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/utils/delivery_request_utils.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_bulky_utils.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_status_utils.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_type_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_aim_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RouteDeliveryRequestDetailScreen extends StatefulWidget {
  final VoidCallback reload;
  final ScheduleRouteList scheduleRouteList;
  const RouteDeliveryRequestDetailScreen(
      {super.key, required this.scheduleRouteList, required this.reload});

  @override
  State<RouteDeliveryRequestDetailScreen> createState() =>
      _RouteDeliveryRequestDetailScreenState();
}

class _RouteDeliveryRequestDetailScreenState
    extends State<RouteDeliveryRequestDetailScreen> {
  int _currentStep = 0;
  bool _isLoading = true;
  final ScheduleRouteController _routeController = Get.find();
  bool _isRefresh = true;
  bool _isCancel = false;

  void clickAcceptedButton(BuildContext context) async {
    try {
      DialogHelper.showLoading(context);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      bool isSuccess = await ScheduleRouteService.accepteScheduledRoute(
          scheduledRouteId: widget.scheduleRouteList.id,
          latitude: position.latitude,
          longitude: position.longitude);
      if (!context.mounted) return;
      DialogHelper.hideLoading(context);
      if (isSuccess) {
        Fluttertoast.showToast(msg: 'Chấp nhận chuyến hàng thành công');
        widget.reload();
        setState(() {
          widget.scheduleRouteList.status = 'ACCEPTED';
        });
      }
    } catch (e) {
      DialogHelper.hideLoading(context);
      DialogHelper.showAwesomeDialogError(context, e.toString());
    }
  }

  void clickRunButton(BuildContext context) async {
    try {
      DialogHelper.showLoading(context);

      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (isLocationServiceEnabled) {
        if (widget.scheduleRouteList.status == 'ACCEPTED') {
          bool isSuccess = await ScheduleRouteService.startScheduledRoute(
              scheduledRouteId: widget.scheduleRouteList.id,
              latitude: position.latitude,
              longitude: position.longitude);

          if (!context.mounted) return;
          DialogHelper.hideLoading(context);

          if (isSuccess) {
            widget.reload();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DeliveryMapScreen(idRoute: widget.scheduleRouteList.id),
              ),
            );
          }
        } else {
          if (!context.mounted) return;
          DialogHelper.hideLoading(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DeliveryMapScreen(idRoute: widget.scheduleRouteList.id),
            ),
          );
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.hideLoading(context);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vui lòng bật GPS'),
              content: const Text('Ứng dụng cần GPS để lấy tọa độ.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.hideLoading(context);
      if (e is MyCustomException) {
        DialogHelper.showAwesomeDialogError(context, e.toString());
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vui lòng cấp quyền truy cập vị trí'),
              content: const Text(
                  'Ứng dụng cần quyền truy cập vị trí để lấy tọa độ.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Mở cài đặt'),
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  // void Function()? buttonDeliveryFunction(BuildContext context) {
  //   switch (widget.scheduleRouteList.status) {
  //     case 'PENDING':
  //       clickAcceptedButton(context);
  //       break;
  //     case 'ACCEPTED':
  //       clickRunButton(context);
  //       break;
  //     case 'PROCESSING':
  //       clickRunButton(context);
  //       break;
  //     case 'FINISHED':
  //       null;
  //       break;
  //     case 'CANCEL':
  //       null;
  //       break;
  //     default:
  //       null;
  //       break;
  //   }
  //   return null;
  // }

  StepState _switchStateImport(
      String value, bool isBranch, bool isFinishedBranch) {
    if (isFinishedBranch && isBranch) {
      return StepState.complete;
    }
    switch (value) {
      case 'PENDING' || 'ACCEPTED' || 'SHIPPING' || 'ARRIVED_PICKUP' || '':
        return StepState.indexed;
      case 'COLLECTED' || 'ARRIVED_DELIVERY':
        return StepState.complete;
      case 'DELIVERED' || 'FINISHED':
        return StepState.complete;
      case 'REPORTED':
        return StepState.error;
      default:
        return StepState.disabled;
    }
  }

  StepState _switchStateExport(String value, bool isBranch) {
    switch (value) {
      case 'PENDING' || 'ACCEPTED' || 'SHIPPING' || 'ARRIVED_PICKUP' || '':
        return StepState.indexed;
      case 'COLLECTED' || 'ARRIVED_DELIVERY':
        if (isBranch) return StepState.complete;
        return StepState.indexed;
      case 'DELIVERED' || 'FINISHED':
        return StepState.complete;
      case 'REPORTED':
        return StepState.error;
      default:
        return StepState.disabled;
    }
  }

  List<Step> _listStep() {
    List<Step> steps = List.empty(growable: true);
    for (var item
        in _routeController.scheduleRouteDetail.value.orderedDeliveryRequests) {
      Step step = Step(
        state: _routeController.scheduleRouteDetail.value.type == 'IMPORT'
            ? _switchStateImport(
                item.status ?? '',
                item.id.isEmpty,
                _routeController
                    .scheduleRouteDetail.value.orderedDeliveryRequests
                    .any((e) =>
                        e.status == 'DELIVERED' || e.status == 'FINISHED'))
            : _switchStateExport(item.status ?? '', item.id.isEmpty),
        title: Text(
          item.address,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.currentScheduledTime == null
                ? const SizedBox()
                : Text(
                    'Thời gian nhận: ${item.currentScheduledTime?.startTime} - ${item.currentScheduledTime?.endTime}'),
            item.status == null
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color:
                          DeliveryRequestUtils.colorStatus(item.status ?? ''),
                    ),
                    child: Text(
                        DeliveryRequestUtils.textStatus(item.status ?? ''),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
          ],
        ),
        content: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(item.avatar),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.phone,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                item.id.isEmpty
                    ? _routeController.scheduleRouteDetail.value.type == 'IMPORTED' ? const Text('Nơi giao hàng') : const Text('Nơi nhận hàng') 
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item.deliveryItems?.length,
                        itemBuilder: (context, index) => Text(
                            '${item.deliveryItems?[index].name}: ${item.deliveryItems?[index].receivedQuantity ?? item.deliveryItems?[index].quantity} ${item.deliveryItems?[index].unit}'),
                      ),
              ],
            ),
          ),
        ),
        isActive: true,
      );
      steps.add(step);
    }

    return steps;
  }

  void _getData() async {
    ScheduleRouteDetail? scheduleRouteDetail;
    await ScheduleRouteService.fetchScheduleRouteDetail(
            widget.scheduleRouteList.id)
        .then((value) {
      scheduleRouteDetail = value;
      // _isCancel = value.orderedDeliveryRequests.any((element) => element.status == "ACCEPTED" || element.status == "ARRIVED_PICKUP" || element.status == 'SHIPPING');
      _isCancel = value.isCancelable;
      setState(() {
        _isLoading = false;
      });
    });

    CurrentScheduledTime time = CurrentScheduledTime(
        day: scheduleRouteDetail!.scheduledTime.day,
        startTime: scheduleRouteDetail!.scheduledTime.startTime,
        endTime: scheduleRouteDetail!.scheduledTime.endTime);

    if (scheduleRouteDetail!.type == 'IMPORT') {
      List<DeliveryItems> list = List.empty(growable: true);
      for (var i = 0;
          i < scheduleRouteDetail!.orderedDeliveryRequests.length - 1;
          i++) {
        list.addAll(scheduleRouteDetail?.orderedDeliveryRequests[i]
            .deliveryItems as Iterable<DeliveryItems>);
      }
      scheduleRouteDetail!.orderedDeliveryRequests.last.deliveryItems = list;

      scheduleRouteDetail!.orderedDeliveryRequests.last.currentScheduledTime =
          time;
    } else {
      scheduleRouteDetail?.orderedDeliveryRequests.first.deliveryItems =
          scheduleRouteDetail?.orderedDeliveryRequests.last.deliveryItems;
      scheduleRouteDetail!.orderedDeliveryRequests.first.currentScheduledTime =
          time;
      scheduleRouteDetail!.orderedDeliveryRequests.first.status =
          scheduleRouteDetail!.orderedDeliveryRequests.last.status;
    }

    _routeController.updateScheduleRouteDetail(scheduleRouteDetail!);
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(ScheduleRouteTypeUtils.textStatus(
                  widget.scheduleRouteList.type)),
              const SizedBox(
                width: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: ScheduleRouteStatusUtils.colorStatus(
                      widget.scheduleRouteList.status),
                ),
                child: Text(
                    ScheduleRouteStatusUtils.textStatus(
                        widget.scheduleRouteList.status),
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? ShimmerWidget.rectangular(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    )
                  : SizedBox(
                      height: 300,
                      child: RouteDetailMapScreen(
                          listLocation: _routeController
                              .scheduleRouteDetail.value.orderedDeliveryRequests
                              .map((e) => e.location)
                              .toList()),
                    ),
              Row(
                children: [
                  ActivityAimCard(
                      title: 'Tổng số đơn',
                      subTitle: widget
                          .scheduleRouteList.numberOfDeliveryRequests
                          .toString(),
                      colorIcon: Colors.green,
                      icon: Icons.library_books),
                  ActivityAimCard(
                      title: 'Lượng hàng',
                      subTitle: ScheduleRouteBulkyUtils.textStatus(
                          widget.scheduleRouteList.bulkyLevel),
                      colorIcon: Colors.orange,
                      icon: Icons.fitness_center),
                ],
              ),
              Row(
                children: [
                  ActivityAimCard(
                      title: 'Ngày nhận',
                      subTitle: Utils.converDate(
                          widget.scheduleRouteList.scheduledTime.day),
                      colorIcon: Colors.blue,
                      icon: Icons.calendar_month),
                  ActivityAimCard(
                      title: 'Thời gian nhận',
                      subTitle:
                          '${widget.scheduleRouteList.scheduledTime.startTime} - ${widget.scheduleRouteList.scheduledTime.endTime}',
                      colorIcon: Colors.grey,
                      icon: Icons.access_alarm),
                ],
              ),
              Row(
                children: [
                  ActivityAimCard(
                      title: 'Quãng đường',
                      subTitle: Utils.convertMeterToKilometer(
                          widget.scheduleRouteList.totalDistanceAsMeters),
                      colorIcon: Colors.red,
                      icon: Icons.navigation),
                  ActivityAimCard(
                      title: 'T/g hoàn thành',
                      subTitle:
                          'Khoảng ${Utils.convertSecondToMinutes(widget.scheduleRouteList.totalTimeAsSeconds)} phút',
                      colorIcon: Colors.purple,
                      icon: Icons.timelapse),
                ],
              ),
              _isLoading
                  ? ShimmerWidget.rectangular(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    )
                  : _routeController.scheduleRouteDetail.value
                          .orderedDeliveryRequests.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Stepper(
                            steps: _listStep(),
                            currentStep: _currentStep,
                            onStepTapped: (step) {
                              setState(() {
                                _currentStep = step;
                              });
                            },
                            controlsBuilder:
                                (BuildContext ctx, ControlsDetails dtl) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeliveryRequestDetailScreen(
                                            isRunning: false,
                                            idDeliveryRequest: _routeController
                                                .scheduleRouteDetail
                                                .value
                                                .orderedDeliveryRequests[
                                                    _currentStep]
                                                .id,
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          _isRefresh = !_isRefresh;
                                        });
                                      });
                                    },
                                    child: const Text('Chi tiết'),
                                  ),
                                  TextButton(
                                    onPressed: _currentStep ==
                                            (_routeController
                                                    .scheduleRouteDetail
                                                    .value
                                                    .orderedDeliveryRequests
                                                    .length -
                                                1)
                                        ? null
                                        : dtl.onStepContinue,
                                    child: const Text('Tiếp'),
                                  ),
                                ],
                              );
                            },
                            onStepContinue: () {
                              setState(() {
                                if (_currentStep <
                                    _routeController.scheduleRouteDetail.value
                                            .orderedDeliveryRequests.length -
                                        1) {
                                  _currentStep++;
                                }
                              });
                            },
                          ),
                        ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Visibility(
                        // visible: widget.scheduleRouteList.status == 'ACCEPTED',
                        visible: _isCancel && (_routeController.scheduleRouteDetail.value.status == 'ACCEPTED' || _routeController.scheduleRouteDetail.value.status == 'PROCESSING'),
                        child: Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              bool isConfirm =
                                  await DialogHelper.showCustomDialog(
                                      context: context,
                                      title: 'Hủy chuyến lịch trình',
                                      body: 'Bạn có chắc muốn hủy không?');
                              if (isConfirm) {
                                if (!context.mounted) return;
                                try {
                                  DialogHelper.showLoading(context);
                                  bool isSuccess = await ScheduleRouteService
                                      .cancelScheduledRoute(
                                          scheduledRouteId:
                                              widget.scheduleRouteList.id);
                                  if (!context.mounted) return;
                                  DialogHelper.hideLoading(context);

                                  if (isSuccess) {
                                    widget.reload();
                                    Fluttertoast.showToast(
                                        msg: 'Hủy chuyến đi thành công');
                                    Navigator.of(context).pop();
                                  }
                                } catch (error) {
                                  DialogHelper.hideLoading(context);
                                  DialogHelper.showAwesomeDialogError(
                                      context, error.toString());
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: const StadiumBorder(),
                              // backgroundColor: Colors.red
                            ),
                            child: const Text(
                              'Hủy',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      _isCancel
                          ? const SizedBox(
                              width: 20,
                            )
                          : const SizedBox(),
                      (_routeController.scheduleRouteDetail.value.status == 'ACCEPTED' || _routeController.scheduleRouteDetail.value.status == 'PROCESSING' ||
                      _routeController.scheduleRouteDetail.value.status == 'PENDING') ?
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            switch (widget.scheduleRouteList.status) {
                              case 'PENDING':
                                clickAcceptedButton(context);
                                break;
                              case 'ACCEPTED':
                                clickRunButton(context);
                                break;
                              case 'PROCESSING':
                                clickRunButton(context);
                                break;
                              case 'FINISHED':
                                null;
                                break;
                              case 'CANCEL':
                                null;
                                break;
                              default:
                                null;
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  ScheduleRouteStatusUtils.colorStatusButton(
                                      widget.scheduleRouteList.status)),
                          child: Text(
                            ScheduleRouteStatusUtils.textStatusButton(
                                widget.scheduleRouteList.status),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ) : const SizedBox(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
