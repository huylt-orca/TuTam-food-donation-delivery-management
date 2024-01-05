import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/route_delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/map/delivery_map_screen.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_bulky_utils.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_status_utils.dart';
import 'package:food_donation_delivery_app/utils/schedule_route_type_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/text_delivery_card_widget.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryRequestCard extends StatelessWidget {
  final ScheduleRouteList route;
  final VoidCallback reload;
  const DeliveryRequestCard(
      {super.key, required this.route, required this.reload});

  void clickAcceptedButton(BuildContext context) async {
    try {
      DialogHelper.showLoading(context);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      bool isSuccess = await ScheduleRouteService.accepteScheduledRoute(
          scheduledRouteId: route.id,
          latitude: position.latitude,
          longitude: position.longitude);
      if (!context.mounted) return;
      DialogHelper.hideLoading(context);
      if (isSuccess) {
        Fluttertoast.showToast(msg: 'Chấp nhận lịch trình thành công');
        reload();
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
        if (route.status == 'ACCEPTED') {
          bool isSuccess = await ScheduleRouteService.startScheduledRoute(
              scheduledRouteId: route.id,
              latitude: position.latitude,
              longitude: position.longitude);

            if (!context.mounted) return;
            DialogHelper.hideLoading(context);

          if (isSuccess) {
            reload();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryMapScreen(idRoute: route.id),
              ),
            );
          }
        } else {
          if (!context.mounted) return;
          DialogHelper.hideLoading(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryMapScreen(idRoute: route.id),
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
      if (e is MyCustomException){
        DialogHelper.showAwesomeDialogError(context, e.toString());
      } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Vui lòng cấp quyền truy cập vị trí'),
            content:
                const Text('Ứng dụng cần quyền truy cập vị trí để lấy tọa độ.'),
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
      );}
    }
  }

  // void Function()? buttonDeliveryFunction(BuildContext context) {
  //   switch (route.status) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RouteDeliveryRequestDetailScreen(
                  scheduleRouteList: route,
                  reload: reload,
                  ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            color: AppTheme.greyBackground,
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ScheduleRouteTypeUtils.colorStatus(route.type),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              width: 90,
              height: 160,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ScheduleRouteTypeUtils.textStatus(route.type),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        '${route.numberOfDeliveryRequests} đơn',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.converDate(route.scheduledTime.day),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                color: Colors.white,
                              )),
                          Column(
                            children: [
                              Text(
                                route.scheduledTime.startTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                route.scheduledTime.endTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.72,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey)),
                            ),
                            const SizedBox(
                                height: 17,
                                child: VerticalDivider(
                                  thickness: 2,
                                )),
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                route.orderedAddresses.first,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                route.orderedAddresses.last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextDeliveryCardWidget(
                          description: 'Quãng đường',
                          text:
                              Utils.convertMeterToKilometer(route.totalDistanceAsMeters),
                        ),
                        TextDeliveryCardWidget(
                          description: 'Thời gian',
                          text:
                              '${Utils.convertSecondToMinutes(route.totalTimeAsSeconds)} phút',
                        ),
                        TextDeliveryCardWidget(
                          description: 'Lượng hàng',
                          text: ScheduleRouteBulkyUtils.textStatus(
                              route.bulkyLevel),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            switch (route.status) {
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
                                      route.status)),
                          child: Text(
                            ScheduleRouteStatusUtils.textStatusButton(
                                route.status),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
