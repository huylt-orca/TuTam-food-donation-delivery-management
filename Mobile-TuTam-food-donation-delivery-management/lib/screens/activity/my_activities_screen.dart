import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/activity.dart';
import 'package:food_donation_delivery_app/services/activity_service.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_card.dart';
import 'package:food_donation_delivery_app/widgets/activity/shimmer_activity_card.dart';

class MyActivitiesScreen extends StatefulWidget {
  const MyActivitiesScreen({super.key});

  @override
  State<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends State<MyActivitiesScreen> {
  List<Activity> _activities = List.empty(growable: true);
  bool _isLoading = true;
  final _scrollController = ScrollController();
  int _page = 1;

    void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      ActivityService.fetchActivitiesList(
              page: _page, isJoined: true)
          .then((data) {
        setState(() {
          _activities.addAll(data);
        });
      });
    }
  }

    @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    ActivityService.fetchActivitiesList(isJoined: true).then((value) {
      _activities = value;
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hoạt động đang tham gia'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (_activities.isEmpty && !_isLoading)
              ? const Center(
                child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Icon(
                        Icons.search,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text('Không tìm thấy hoạt động', style: TextStyle(color: Colors.grey),),
                    ],
                  ),
              )
              :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:  _isLoading ? 4 : _activities.length,
                itemBuilder: (context, index) => _isLoading ? const ShimmerActivityCard()
                      : ActivityCard(
                        activity: _activities[index],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}