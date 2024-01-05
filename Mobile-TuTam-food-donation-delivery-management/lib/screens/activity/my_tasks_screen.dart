import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/activity_task.dart';
import 'package:food_donation_delivery_app/screens/activity/activity_feedback_screen.dart';
import 'package:food_donation_delivery_app/services/activity_feedback_service.dart';
import 'package:food_donation_delivery_app/services/activity_task_service.dart';
import 'package:food_donation_delivery_app/widgets/activity/my_activity_task_card.dart';
import 'package:food_donation_delivery_app/widgets/activity/shimmer_my_activity_tack_card.dart';

class MyTasksScreen extends StatefulWidget {
  final String activityId;
  const MyTasksScreen({super.key, required this.activityId});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  bool _isSend = true;
  List<ActivityTask> _tasks = List.empty(growable: true);
  bool _isLoading = true;

  void _getData() async{
    _isSend = await ActivityFeedbackService.checkUserSendActivityFeedbackIsSend(activityId: widget.activityId);
    await ActivityTaskService.fetchActivityTaskList(
                  activityId: widget.activityId).then((value){
                     _tasks = value; 
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
          title: const Text('Nhiệm vụ của tôi'),
          actions: [
           _isSend ? const SizedBox() : IconButton(
                onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityFeedbackScreen(
                            idActivity: widget.activityId,
                          ),
                        ),
                      );
                },
                icon: const Icon(Icons.chat)),
          ],
        ),
        body: SingleChildScrollView(
          child: 
                   (_tasks.isEmpty && !_isLoading)
                      ? const Center(
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
                            'Không có nhiệm vụ cho bạn',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                      : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _isLoading ? 4 : _tasks.length,
                        itemBuilder: (context, index) =>
                        _isLoading ? const ShimmerMyActivityTaskCard()
                            : MyActivityTaskCard(task: _tasks[index])
                      ),
        ),
      ),
    );
  }
}

