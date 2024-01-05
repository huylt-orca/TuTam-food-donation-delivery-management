import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/logging.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/my_history_route_delivery_screen.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/services/signalr_schedule_route_service.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/delivery_request_card.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/shimmer_delivery_request_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DeliveryRequestsScreen extends StatefulWidget {
  const DeliveryRequestsScreen({super.key});

  @override
  State<DeliveryRequestsScreen> createState() =>
      DeliveryRequestsScreenState();
}

class DeliveryRequestsScreenState
    extends State<DeliveryRequestsScreen> {
      bool _isLoadingMy = true;
      bool _isLoadingOther = true;
      final UserController _userController = Get.find();
      List<ScheduleRouteList> _myRunningList = List.empty(growable: true);
      List<ScheduleRouteList> _myPendingList = List.empty(growable: true);
      List<ScheduleRouteList> _otherRouteList = List.empty(growable: true);
      double _myLatitude = 0.0;
      double _myLongitude = 0.0;
      final SignalRScheduleRouteService signalRService = SignalRScheduleRouteService();
      final log = logger;
      bool _isRefresh = true;
      String _idRemove = '';
  Future<void> _getRunningScheduleRoute()async {
    await ScheduleRouteService.fetchScheduleRouteList(
      status: 2
    ).then((value){
      setState(() {
        _myRunningList = value;
      });
    });
  }

  Future<void> _getPendingScheduleRoute()async {
    await ScheduleRouteService.fetchScheduleRouteList(
      status: 1
    ).then((value){
      setState(() {
        _myPendingList = value;
      });
    });
  }

  Future<void> _getOtherScheduleRoute()async {
    try {
    await ScheduleRouteService.fetchScheduleRouteList(
      longitude: _myLongitude.toString(),
      latitude: _myLatitude.toString(),
      status: 0
    ).then((value){
      setState(() { 
        _otherRouteList = value;
      });
      
    });
    } catch (e){
      log.w(e);
    }
  }

  void _getData()async{
    setState(() {
      _isLoadingOther = true;
       _isLoadingMy = true;
    });
     Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
    _myLatitude = position.latitude;
    _myLongitude = position.longitude;
    print(_myLongitude);
    print(_myLatitude);
   
   await Future.wait([_getRunningScheduleRoute(), _getPendingScheduleRoute(), _getOtherScheduleRoute()]);
      
       setState(() {
      _isLoadingOther = false;
       _isLoadingMy = false;
    });
   
  }

  void _refreshOtherScheduleRoute()async{
    setState(() {
      _isLoadingOther = true;
    });
    await _getOtherScheduleRoute();
    setState(() {
      _isLoadingOther = false;
    });
  }

  void _refreshMyScheduleRoute() async{
    setState(() {
      _isLoadingMy = true;
    });
    await Future.wait([_getRunningScheduleRoute(), _getPendingScheduleRoute()]);
    if (_idRemove.isNotEmpty){
_otherRouteList.removeWhere((item) => item.id == _idRemove);
    }
    setState(() {
      _isLoadingMy = false;
    });
  }

  @override
  void initState() {
    super.initState();
   
    _getData();

    signalRService.startConnection().then((_) {
      signalRService.registerListeners((message) {
        String itemIdToRemove = message[0]['scheduledRouteId'];
    
      //  print(itemIdToRemove);
      //  print(_otherRouteList.map((e) => e.id).toList().join(' - '));
      //  _otherRouteList.removeWhere((item) => item.id == itemIdToRemove);
      //     print(_otherRouteList.map((e) => e.id).toList().join(' - '));
          _idRemove = itemIdToRemove;
        // setState(() {
          
        // });
      });
    });

  }

  @override
  void dispose() {
   signalRService.hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title:  Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chào ',
                style: TextStyle(fontSize: 12),
                ),
                Text(
                  _userController.name.value,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip
                      ),
                ),
              ],
            ),
          ),
          leading:  Padding(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lịch trình của bạn',
                     style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                      )),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                             Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                const MyHistoryRouteDeliveryScreen(),
                            ),
                          );
                            },
                           icon: const Icon(Icons.history)),
                           IconButton(
                        onPressed: (){
                          _refreshMyScheduleRoute();
                        },
                       icon: const Icon(Icons.refresh))
                        ],
                      )
                  ],
                ),
                (_myPendingList.isEmpty && _myRunningList.isEmpty && !_isLoadingMy) 
                ? const Center(
                child: Column(
                    children: [
                      Icon(
                        Icons.assignment,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text('Bạn đang không có chuyến hàng', style: TextStyle(color: Colors.grey),),
                    ],
                  ),
              )
                :  Column(
                  children: [
                    (_myRunningList.isEmpty && !_isLoadingMy) ? const SizedBox()
                     : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _isLoadingMy ? 1 : _myRunningList.length,
                        itemBuilder: (context, index) => 
                        _isLoadingMy ? const ShimmerDeliveryRequestCard() 
                        : DeliveryRequestCard(
                          route: _myRunningList[index],
                          reload: _refreshMyScheduleRoute,
                        ),
                        ),

                    (_myPendingList.isEmpty && !_isLoadingMy) ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _isLoadingMy ? 1 : _myPendingList.length,
                        itemBuilder: (context, index) => 
                        _isLoadingMy ? const ShimmerDeliveryRequestCard() 
                        : DeliveryRequestCard(
                          route: _myPendingList[index],
                           reload: _refreshMyScheduleRoute,
                        ),
                        ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lịch trình đang đợi',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                      )),
                    IconButton(
                        onPressed: (){
                          _refreshOtherScheduleRoute();
                        },
                       icon: const Icon(Icons.refresh))
                  ],
                ),
                (_otherRouteList.isEmpty && !_isLoadingOther) 
                ? const Center(
                child: Column(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text('Hệ thống Không có chuyến hàng', style: TextStyle(color: Colors.grey),),
                    ],
                  ),
              )
                  : 
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _isLoadingOther ? 3 :_otherRouteList.length,
                    itemBuilder: (context, index) => 
                    _isLoadingOther ? const ShimmerDeliveryRequestCard()
                    : DeliveryRequestCard(
                      route: _otherRouteList[index],
                      //  reload: _getData,
                      reload: ()async{
                        _refreshMyScheduleRoute();
                        _otherRouteList.remove(_otherRouteList[index]);
                      },
                    ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

