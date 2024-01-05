import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/services/utils_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/map/delivery_request_map_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeliveryMapScreen extends StatefulWidget {
  final String idRoute;
  const DeliveryMapScreen({super.key, required this.idRoute});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  int _selectedRequest = 0;
  double _myLatitude = 10.83992321313616;
  double _myLongitude = 106.8103337656761;
  double _myStartLatitude = 10.83992321313616;
  double _myStartLongitude = 106.8103337656761;
  List<List<LatLng>> _streetPointsList = List.empty(growable: true);
  bool _isRefresh = false;
  List<List<double>> _locationAll = List.empty(growable: true);
  final ScheduleRouteController _routeController = Get.find();
  ScheduleRouteDetail? scheduleRouteDetail;
  final UserController _userController = Get.find();
  // Timer? _timer;

  Geolocator _geolocator = Geolocator();

  List<Polyline> _listPolyline() {
    // print('_listPolyline');
    List<Polyline> polylines = List.empty(growable: true);
    if (_streetPointsList.isNotEmpty) {
      Polyline? polylineStorage;
      for (var i = 0; i < _streetPointsList.length; i++) {
        Polyline polyline = Polyline(
          points: _streetPointsList[i],
          color: _selectedRequest == i ? Colors.red : Colors.grey,
          strokeWidth: 4.0,
        );
        if (_selectedRequest == i) {
          polylineStorage = polyline;
        } else {
          polylines.add(polyline);
        }
      }
      polylines.add(polylineStorage!);
    }
    return polylines;
  }

  List<Marker> _listMarker() {
    // print('_listMarkers');
    List<Marker> markers = List.empty(growable: true);

    markers.add(Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(_locationAll.last[0], _locationAll.last[1]),
      builder: (ctx) => const Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 30,
            ),
          ),
        ],
      ),
    ));

    for (var i = 0; i < _locationAll.length - 1; i++) {
      Marker marker = Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(_locationAll[i][0], _locationAll[i][1]),
        builder: (ctx) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10,
              child: Icon(
                Icons.location_on,
                color: _selectedRequest == i ? Colors.yellow : Colors.red,
                size: 30,
              ),
            ),
            Positioned(
                left: 7,
                right: 7,
                top: -6,
                child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10),
                    )))),
          ],
        ),
      );
      markers.add(marker);
    }

    // started point
    markers.add(Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(_myStartLatitude, _myStartLongitude),
      builder: (ctx) => const Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            child: Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    ));

    // my started point, it update every
    markers.add(Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(_myLatitude, _myLongitude),
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
    ));
    return markers;
  }

  void _getData() async {
    scheduleRouteDetail = await ScheduleRouteService.fetchScheduleRouteDetail(widget.idRoute);
        // .then((value) => scheduleRouteDetail = value);

    _locationAll = scheduleRouteDetail!.orderedDeliveryRequests
        .map((e) => e.location)
        .toList();

    // draw my location to the first delivery Request
    await UtilsService.fetchRouteBetweenTwoLocation(
            latitudeFirst: _myLatitude,
            longitudeFirst: _myLongitude,
            latitudeSecond:
                scheduleRouteDetail!.orderedDeliveryRequests[0].location[0],
            longitudeSecond:
                scheduleRouteDetail!.orderedDeliveryRequests[0].location[1])
        .then((value) {
      _streetPointsList.add(value);

      // setState(() {
      // _streetPointsList.add(value);
      // });
    });

    // draw location delivery Request
    for (int i = 0;
        i < scheduleRouteDetail!.orderedDeliveryRequests.length - 1;
        i++) {
      await UtilsService.fetchRouteBetweenTwoLocation(
              latitudeFirst:
                  scheduleRouteDetail!.orderedDeliveryRequests[i].location[0],
              longitudeFirst:
                  scheduleRouteDetail!.orderedDeliveryRequests[i].location[1],
              latitudeSecond: scheduleRouteDetail!
                  .orderedDeliveryRequests[i + 1].location[0],
              longitudeSecond: scheduleRouteDetail!
                  .orderedDeliveryRequests[i + 1].location[1])
          .then((value) {
        _streetPointsList.add(value);

        // setState(() {
        // _streetPointsList.add(value);
        // });
      });
    }

    CurrentScheduledTime time = CurrentScheduledTime(
        day: scheduleRouteDetail!.scheduledTime.day,
        startTime: scheduleRouteDetail!.scheduledTime.startTime,
        endTime: scheduleRouteDetail!.scheduledTime.endTime);

    if (scheduleRouteDetail!.type == 'IMPORT') {
      List<DeliveryItems> list = List.empty(growable: true);
      for (var i = 0;
          i < scheduleRouteDetail!.orderedDeliveryRequests.length - 1;
          i++) {
        list.addAll(scheduleRouteDetail!.orderedDeliveryRequests[i]
            .deliveryItems as Iterable<DeliveryItems>);
      }
      scheduleRouteDetail!.orderedDeliveryRequests.last.deliveryItems = list;

      scheduleRouteDetail!.orderedDeliveryRequests.last.currentScheduledTime =
          time;

          // set status for last point
      // scheduleRouteDetail!.orderedDeliveryRequests.last.status = 
      // scheduleRouteDetail!.orderedDeliveryRequests.firstWhere((element) => element.status == 'DELIVERED',
      // orElse: () => scheduleRouteDetail!.orderedDeliveryRequests.firstWhere((element) => element.status == 'ARRIVED_DELIVERY')
      // ).status;
        
    } else {
      scheduleRouteDetail!.orderedDeliveryRequests.first.deliveryItems =
          scheduleRouteDetail!.orderedDeliveryRequests.last.deliveryItems;
      scheduleRouteDetail!.orderedDeliveryRequests.first.currentScheduledTime =
          time;
      scheduleRouteDetail!.orderedDeliveryRequests.first.status =
          scheduleRouteDetail!.orderedDeliveryRequests.last.status;
    }

    _routeController.updateScheduleRouteDetail(scheduleRouteDetail!);

    setState(() {
      _isRefresh = !_isRefresh;
    });
  }

  void _updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _myLatitude = position.latitude;
      _myLongitude = position.longitude;
    });
  }

    void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    setState(() {
      _myStartLatitude = position.latitude;
      _myStartLongitude = position.longitude;
      _myLatitude = position.latitude;
      _myLongitude = position.longitude;
    });
  }

  @override
  void initState() {
    super.initState();

    _getLocation();
    // _updateLocation();
    _getData();

    // _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
    //   _updateLocation();
    // });

    Geolocator.getPositionStream(locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
      )).listen((Position position) {
      setState(() {
         _myLatitude = position.latitude;
      _myLongitude = position.longitude;
      });
    });
    

    // setState(() {
    //   _isRefresh = !_isRefresh;
    // });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chào ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    _userController.name.value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 2.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(_userController.avatar.value),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
        body: Stack(
          children: [
            scheduleRouteDetail == null
                ? const ShimmerWidget.rectangular(
                    height: double.infinity,
                    width: double.infinity,
                  )
                : FlutterMap(
                    options: MapOptions(
                      center: LatLng(
                          _myLatitude, _myLongitude), // Initial map center
                      // LatLng(scheduleRouteDetail!.orderedDeliveryRequests.first.location[0],scheduleRouteDetail!.orderedDeliveryRequests.first.location[1]),
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      
                      PolylineLayer(polylines: _listPolyline()),
                      MarkerLayer(
                        markers: _listMarker(),
                      ),
                    ],
                  ),
            Positioned(
                bottom: 265,
                right: 15,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.info),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('Chú thích'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.blue,
                                          ),
                                          Text('Vị trí hiện tại của bạn'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                          ),
                                          Text('Vị trí bắt đầu của bạn'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.yellow,
                                          ),
                                          Text('Điểm đang hướng tới'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          Text('Điểm lấy vật phẩm'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          ),
                                          Text('Điểm giao vật phẩm'),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.location_on),
                        onPressed: () async {
                          bool isConfirm = await DialogHelper.showCustomDialog(
                            context: context, 
                            title: 'Mở Google Map', 
                            body: 'Bạn có muốn điều hướng qua Google Map không');

                            if (isConfirm){
                              String locations = _locationAll
                              .map((e) => '${e[0]},${e[1]}')
                              .join('/');

                          String url =
                              // 'https://www.google.com/maps/dir/?api=1&origin=10.8396544,106.807296&destination=10.8461765,106.8037758&waypoints=10.8455988,106.7952347&travelmode=driving';
                              // 'https://www.google.com/maps/dir/10.8396544,106.807296/10.8461765,106.8037758/10.8455988,106.7952347/@10.8441657,106.7934752';
                              'https://www.google.com/maps/dir/$locations';
                          await canLaunchUrlString(url)
                              ? await launchUrlString(url)
                              : throw 'Không thể mở GG map';
                            }
                        },
                      ),
                    ),
                  ],
                )),
            Positioned(
                bottom: 0,
                child: scheduleRouteDetail == null
                    ? ShimmerWidget.circular(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _selectedRequest = index;
                            });
                          },
                          controller: PageController(viewportFraction: 0.85),
                          itemCount:
                              scheduleRouteDetail!.numberOfDeliveryRequests + 1,
                          itemBuilder: (context, index) =>
                              DeliveryRequestMapCard(
                                isImported: _routeController.scheduleRouteDetail.value.type == 'IMPORT',
                            reload: () {
                              setState(() {
                                _isRefresh = !_isRefresh;
                              });
                            },
                            deliveryRequest: scheduleRouteDetail!
                                .orderedDeliveryRequests[index],
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
