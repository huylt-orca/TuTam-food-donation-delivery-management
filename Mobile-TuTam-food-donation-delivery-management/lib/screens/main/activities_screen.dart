import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/activity.dart';
import 'package:food_donation_delivery_app/models/activity_filter.dart';
import 'package:food_donation_delivery_app/screens/activity/activity_filter_screen.dart';
import 'package:food_donation_delivery_app/screens/activity/my_activities_screen.dart';
import 'package:food_donation_delivery_app/services/activity_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_card.dart';
import 'package:food_donation_delivery_app/widgets/activity/chip_activity_filter_widget.dart';
import 'package:food_donation_delivery_app/widgets/activity/shimmer_activity_card.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final _scrollController = ScrollController();
  final _txtSearch = TextEditingController();
  List<Activity> _activities = List.empty(growable: true);
  ActivityFilter _activityFilter = ActivityFilter();
  // String _keyword = "";
  int _page = 1;
  final List<String> _listStatus = [
    'Tất cả',
    'Sắp mở',
    'Hoạt động',
    'Đã kết thúc'
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    ActivityService.fetchActivitiesList().then((value) {
      _activities = value;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      ActivityService.fetchActivitiesList(
              page: _page, name: _txtSearch.text)
          .then((data) {
        setState(() {
          _activities.addAll(data);
        });
      });
    }
  }

  void _runFilter() {
    setState(() {
      _isLoading = true;
    });
    _page = 1;
    String address = '';
    address = _activityFilter.district == null ? '' : '${_activityFilter.district!.name}, ';
    address = _activityFilter.province == null ? '' : _activityFilter.province!.name;
    ActivityService.fetchActivitiesList(
      name: _txtSearch.text,
      status: _activityFilter.status,
      startDate: _activityFilter.startDate == null ? '' : _activityFilter.startDate.toString(),
      endDate: _activityFilter.endDate == null ? '' : _activityFilter.endDate.toString(),
      activityTypeIds: _activityFilter.activityType == null ? [] : _activityFilter.activityType!.where((element) => element.isTrue == true).map((e) => e.id).toList(),
      branchId: _activityFilter.branch == null ? '' : _activityFilter.branch!.id,
      address: address
      ).then((data) {
      setState(() {
        _activities = data;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách các hoạt động',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => const MyActivitiesScreen(),
                  )
                  );
                },
                 icon: const Icon(Icons.bookmark)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _txtSearch,
            // onChanged: (value) {
            //   // _keyword = value;
            //   _runFilter(value);
            // },
            onSubmitted: (value) {
              _runFilter();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 0.8),
              ),
              labelText: 'Tìm kiếm',
              prefixIcon: IconButton(
                onPressed: () {
                  _runFilter();
                },
                icon: const Icon(Icons.search),
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    _activityFilter.name = _txtSearch.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityFilterScreen(
                          activityFilter: _activityFilter,
                          filter: (value) {
                            setState(() {
                              _activityFilter = value;
                              // _keyword = 'dsfa';
                              _txtSearch.text = value.name ?? '';
                            });
                            _runFilter();
                          },
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    // backgroundColor:
                    //     MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.filter_list)),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Wrap(
            // spacing: 8.0,
            children: [
              ChipActivityFilterWidget(
                text:
                    'Từ ngày: ${_activityFilter.startDate != null ? Utils.converDate(_activityFilter.startDate?.toString()) : ''}',
                visible: _activityFilter.startDate != null,
                onDeleted: () {
                  setState(() {
                    _activityFilter.startDate = null;
                  });
                  _runFilter();
                },
              ),
              ChipActivityFilterWidget(
                text:
                    'Đến ngày: ${_activityFilter.endDate != null ? Utils.converDate(_activityFilter.endDate?.toString()) : ''}',
                visible: _activityFilter.endDate != null,
                onDeleted: () {
                  setState(() {
                    _activityFilter.endDate = null;
                  });
                  _runFilter();
                },
              ),
              ChipActivityFilterWidget(
                text: _listStatus[_activityFilter.status + 1],
                visible: _activityFilter.status != -1,
                onDeleted: () {
                  setState(() {
                    _activityFilter.status = -1;
                  });
                  _runFilter();
                },
              ),
              ChipActivityFilterWidget(
                text: _activityFilter.branch?.name ?? '',
                visible: _activityFilter.branch != null,
                onDeleted: () {
                  setState(() {
                    _activityFilter.branch = null;
                  });
                  _runFilter();
                },
              ),
              ChipActivityFilterWidget(
                text: _activityFilter.province?.name ?? '',
                visible: _activityFilter.province != null,
                onDeleted: () {
                  setState(() {
                    _activityFilter.province = null;
                    _activityFilter.district = null;
                  });
                  _runFilter();
                },
              ),
              ChipActivityFilterWidget(
                text: _activityFilter.district?.name ?? '',
                visible: _activityFilter.district != null,
                onDeleted: () {
                  setState(() {
                    _activityFilter.district = null;
                  });
                  _runFilter();
                },
              ),
              _activityFilter.activityType == null
                  ? const SizedBox()
                  : Wrap(
                      children: _activityFilter.activityType!.map((e) {
                        return ChipActivityFilterWidget(
                          text: e.name,
                          visible: e.isTrue,
                          onDeleted: () {
                            setState(() {
                              e.isTrue = false;
                            });
                            _runFilter();
                          },
                        );
                      }).toList(),
                    ),
            ],
          ),
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
              : SizedBox(
                  height: MediaQuery.of(context).size.height *0.67,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _isLoading ? 4 : _activities.length,
                    itemBuilder: (context, index)  {
                      return _isLoading ? const ShimmerActivityCard()
                      : ActivityCard(
                        activity: _activities[index],
                      );
                    },
                    
                  ),
                ),
        ],
      ),
    );
  }
}
