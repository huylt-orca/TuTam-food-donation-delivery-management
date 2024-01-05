import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/activity_task.dart';
import 'package:food_donation_delivery_app/utils/activity_task_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class MyActivityTaskCard extends StatelessWidget {
  final ActivityTask task; 
  const MyActivityTaskCard({
    super.key,
    required this.task
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: task.status == 'DONE' ? TextDecoration.lineThrough : TextDecoration.none,
            decorationThickness: 2.0,
          ),
          ),
          Text(task.description),
          const Divider(),
          Row(
              children: [
                const SizedBox(
                    height: 25,
                    child: VerticalDivider(
                      color: Colors.black,
                    )),
                Column(
                  children: [
                    Text(
                      Utils.converDate(task.startDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      Utils.converDate(task.endDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ActivityTaskUtils.colorStatus(task.status),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(ActivityTaskUtils.textStatus(task.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}