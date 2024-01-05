import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/activity_detail.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/screens/activity/my_tasks_screen.dart';
import 'package:food_donation_delivery_app/screens/donation/create_donation_screen.dart';
import 'package:food_donation_delivery_app/screens/statement/statements_screen.dart';
import 'package:food_donation_delivery_app/services/activity_member_service.dart';
import 'package:food_donation_delivery_app/services/activity_service.dart';
import 'package:food_donation_delivery_app/utils/activity_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_join_dialog.dart';
import 'package:food_donation_delivery_app/widgets/activity/activity_stepper_widget.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

import '../../widgets/activity/activity_aim_card.dart';
import '../../widgets/progress_bar_widget.dart';
import '../../widgets/progress_item_widget.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String idActivity;
  const ActivityDetailScreen({super.key, required this.idActivity});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<ActivityDetail>(
          future: ActivityService.fetchActivityDetail(activityId: idActivity),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerWidget.rectangular(
                height: MediaQuery.of(context).size.height,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final activity = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      const Text('Chi tiết hoạt động'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: ActivityUtils.colorStatus(activity!.status),
                        ),
                        child: Text(ActivityUtils.textStatus(activity.status),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                  controller:
                                      PageController(viewportFraction: 1),
                                  itemCount: activity.images.length,
                                  itemBuilder: (context, index) {
                                    return Image(
                                      image:
                                          NetworkImage(activity.images[index]),
                                      width: MediaQuery.of(context).size.width,
                                      // height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                            ),
                            Row(
                              children: [
                                activity.startDate == ''
                                    ? ActivityAimCard(
                                        title: 'Ngày bắt đầu',
                                        subTitle: Utils.converDate(
                                            activity.estimatedStartDate),
                                        colorIcon: const Color(0xFF27FF5E),
                                        icon: Icons.calendar_month)
                                    : ActivityAimCard(
                                        title: 'Ngày kết thúc',
                                        subTitle: Utils.converDate(
                                            activity.endDate == ''
                                                ? activity.estimatedEndDate
                                                : activity.endDate),
                                        colorIcon: const Color(0xFF27FF5E),
                                        icon: Icons.calendar_month),
                                ActivityAimCard(
                                    title: 'Thời gian còn lại',
                                    subTitle: (activity.status != 'ENDED' &&
                                            activity.remainingDays == -1)
                                        ? 'Còn hoạt động'
                                        : (activity.status == 'ENDED' ||
                                                activity.remainingDays == -1)
                                            ? 'Đã kết thúc'
                                            : 'Còn ${activity.remainingDays} ngày',
                                    colorIcon: const Color(0xFF5BC3F8),
                                    icon: Icons.alarm),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                        text: 'Thực hiện bởi: ',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                          text: activity.branchResponses
                                              .map((e) => e.name)
                                              .toList()
                                              .join(', '),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87)),
                                    ]),
                                  ),
                                  Text(
                                    'Loại: ${activity.activityTypeComponents.join(' | ')}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Thời gian: ${Utils.converDate(activity.startDate == '' ? activity.estimatedStartDate : activity.startDate)} - ${Utils.converDate(activity.endDate == '' ? activity.estimatedEndDate : activity.endDate)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  activity.address == ''
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Text(
                                          'Địa chỉ: ${activity.address}',
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                  ActivityStepperWidget(
                                    activityId: activity.id,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Visibility(
                                      visible: activity
                                          .targetProcessResponses.isNotEmpty,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Tiến độ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ProgressBarWidget(
                                            percent: activity.process,
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tiến độ: ${activity.process}%',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              GestureDetector(
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      "Xem sao kê quyên góp",
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .primarySecond,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      size: 16,
                                                      color: AppTheme
                                                          .primarySecond,
                                                    )
                                                  ],
                                                ),
                                                onTap: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StatementsScreen(
                                                                type: 2,
                                                                id: activity
                                                                    .id)),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Danh sách vật phẩm cần quyên góp',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: activity
                                                  .targetProcessResponses
                                                  .length,
                                              itemBuilder: (context, index) =>
                                                  ProgressItemWidget(
                                                    index: index + 1,
                                                    itemName:
                                                        '${activity.targetProcessResponses[index].itemTemplateResponse.name} ${activity.targetProcessResponses[index].itemTemplateResponse.attributeValues.join(' - ')}',
                                                    itemAim:
                                                        '${activity.targetProcessResponses[index].target} ${activity.targetProcessResponses[index].itemTemplateResponse.unit}',
                                                    itemCurrent:
                                                        '${activity.targetProcessResponses[index].process} ${activity.targetProcessResponses[index].itemTemplateResponse.unit}',
                                                    percent: activity
                                                        .targetProcessResponses[
                                                            index]
                                                        .percent,
                                                  )),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )),
                                  const Text(
                                    'Hoạt động',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  Text(activity.description),
                                  const SizedBox(
                                    height: 70,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      // left: (MediaQuery.of(context).size.width - 300) / 2,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: activity.activityTypeComponents
                                .contains(AppConfig.TYPE_ACTIVITY_1) && activity.status=='STARTED',
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    List<ItemList> items = activity
                                        .targetProcessResponses
                                        .map((e) => ItemList(
                                            itemTemplateId:
                                                e.itemTemplateResponse.id,
                                            name: e.itemTemplateResponse.name,
                                            image: e.itemTemplateResponse.image,
                                            unit: Unit(
                                                id: '',
                                                name:
                                                    e.itemTemplateResponse.unit,
                                                symbol: e
                                                    .itemTemplateResponse.unit),
                                            attributes: e.itemTemplateResponse
                                                .attributeValues
                                                .map((e) => Attributes(
                                                    attributeValue: e))
                                                .toList()))
                                        .toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateDonationScreen(
                                          activity: activity,
                                          itemsList: items,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppTheme.primarySecond),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  child: const Text(
                                    'Quyên Góp',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: activity.scope == 'PUBLIC' && activity.status != 'ENDED',
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (activity.isJoined) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyTasksScreen(
                                              activityId: activity.id,
                                            ),
                                          ));
                                    } else {
                                      if (await ActivityMemberService
                                          .checkUserSendActivityApplication(
                                              activityId: idActivity)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Bạn đã gửi đơn, vui lòng đợi');
                                      } else {
                                        if (!context.mounted) return;
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ActivityJoinDialog(
                                            activityId: activity.id,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppTheme.primaryFirst),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  child: Text(
                                    activity.isJoined ? 'Nhiệm vụ' : 'Tham gia',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
