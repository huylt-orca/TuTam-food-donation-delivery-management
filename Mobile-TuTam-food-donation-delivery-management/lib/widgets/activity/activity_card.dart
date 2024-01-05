import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/activity.dart';
import 'package:food_donation_delivery_app/screens/activity/activity_detail_screen.dart';
import 'package:food_donation_delivery_app/utils/activity_utils.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailScreen(idActivity: activity.id),
          ),
        );
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
          // color: AppTheme.greyBackground,
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(activity.images.first),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      bottom: -12,
                      left: 24,
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color:
                              ActivityUtils.colorStatus(activity.status),
                        ),
                        child: Text(
                          ActivityUtils.textStatus(activity.status),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(vertical: 2.0),
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 8.0, vertical: 4.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12.0),
                      //     color:
                      //         ActivityUtils.colorStatus(this.activity.status),
                      //   ),
                      //   child: Text(
                      //       ActivityUtils.textStatus(this.activity.status),
                      //       style: const TextStyle(
                      //           fontSize: 10,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w500)),
                      // ),
                      const Divider(),
                      Text(
                        'Loại: ${activity.activityTypeComponents.join(' | ')}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Ngày: ${activity.startDate == '' ? activity.estimatedStartDate : activity.startDate} - ${activity.endDate == '' ? activity.estimatedEndDate : activity.endDate}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Thực hiện: ${activity.branchResponses.map((e) => e.name).toList().join(', ')}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(
                        endIndent: 40,
                      ),
                      Text(
                        'Địa chỉ: ${activity.address == ''? 'Nhiều nơi': activity.address}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
            // RichText(
            //   text: TextSpan(children: [
            //     const TextSpan(
            //       text: 'Thực hiện bởi ',
            //       style: TextStyle(fontSize: 12, color: Colors.black),
            //     ),
            //     TextSpan(
            //         text: this
            //             .activity
            //             .branchResponses
            //             .map((e) => e.name)
            //             .toList()
            //             .join(', '),
            //         style: const TextStyle(
            //             fontWeight: FontWeight.w400,
            //             fontSize: 12,
            //             color: Colors.black,
            //             overflow: TextOverflow.ellipsis)),
            //   ]),
            // ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const Icon(
            //       Icons.location_on,
            //       size: 15.0,
            //     ),
            //     SizedBox(
            //       width: MediaQuery.of(context).size.width * 0.8,
            //       child: Text(
            //         this.activity.address == ''
            //             ? 'Nhiều nơi'
            //             : this.activity.address,
            //         style: const TextStyle(fontSize: 12),
            //         softWrap: true,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
