import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/services/schedule_route_service.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/delivery_request_card.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/shimmer_delivery_request_card.dart';

class MyHistoryRouteDeliveryScreen extends StatefulWidget {
  const MyHistoryRouteDeliveryScreen({super.key});

  @override
  State<MyHistoryRouteDeliveryScreen> createState() => _MyHistoryRouteDeliveryScreenState();
}

class _MyHistoryRouteDeliveryScreenState extends State<MyHistoryRouteDeliveryScreen> {
  List<ScheduleRouteList> _scheduleRoutes = List.empty(growable: true);
  bool _isLoading = true;

  _getData() async {
    ScheduleRouteService.fetchScheduleRouteList(
      status: 3
    ).then((value){
        _scheduleRoutes = value;
      setState(() {
        _isLoading = false;
      });
    });
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
          title: const Text('Lịch sử chuyến đi'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          (_scheduleRoutes.isEmpty && !_isLoading) ?
          const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Icon(
                            Icons.search,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text(
                            'Không có lịch sử chuyến đi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
          : ListView.builder(
            itemCount: _isLoading ? 4 : _scheduleRoutes.length,
            itemBuilder: (context, index)  =>   _isLoading ? const ShimmerDeliveryRequestCard()
                    : DeliveryRequestCard(
                      route: _scheduleRoutes[index],
                       reload: (){}),
                    ),
        ),
      ),
    );
  }
}