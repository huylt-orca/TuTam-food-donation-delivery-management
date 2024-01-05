import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/donated_request_detail.dart';
import 'package:food_donation_delivery_app/screens/donation/history_delivery_request_list_screen.dart';
import 'package:food_donation_delivery_app/services/donated_request_service.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/utils/donated_request_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/donated_item_detail_card.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:food_donation_delivery_app/widgets/time_select_widget.dart';

class DonatedRequestDetailUserScreen extends StatelessWidget {
  final String idDonatedRequest;
  const DonatedRequestDetailUserScreen(
      {super.key, required this.idDonatedRequest});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<DonatedRequestDetail>(
          future: DonatedRequestService.fetchDonatedRequestDetail(
              idDonatedRequest: idDonatedRequest),
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
              final donatedRequest = snapshot.data;
              List<DonatedItemResponses> rejectedItems = List.empty(growable: true);

              donatedRequest!.donatedItemResponses.removeWhere((e){
                if (e.status == 'REJECTED'){
                  rejectedItems.add(e);
                  return true;
                }
                return false;
              });
              bool isEmptyRejectedItem = rejectedItems.isEmpty;
              bool isEmptyNonRejectedItem = donatedRequest.donatedItemResponses.isEmpty;

              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      const Text('Yêu cầu quyên góp'),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: DonatedRequestUtils.colorStatus(
                              donatedRequest.status),
                        ),
                        child: Text(
                            DonatedRequestUtils.textStatus(
                                donatedRequest.status),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                          controller: PageController(viewportFraction: 1),
                          itemCount: donatedRequest.images.length,
                          itemBuilder: (context, index) {
                            return Image(
                              image: NetworkImage(donatedRequest.images[index]),
                              width: MediaQuery.of(context).size.width,
                              // height: 200,
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          donatedRequest.acceptedBranch == null
                              ? donatedRequest.rejectingBranchResponses!.isEmpty ?
                              const Card(
                                  child: ListTile(
                                  title: Text('Chưa có Nơi nhận'),
                                )) 
                                : 
                                Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                        child: Text(
                                            'Nơi từ chối:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: donatedRequest.rejectingBranchResponses!.length,
                                        itemBuilder: (context,index)=> 
                                        ListTile(
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              donatedRequest
                                                  .rejectingBranchResponses![index].image)),
                                      title: Text(
                                        donatedRequest.rejectingBranchResponses![index].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(donatedRequest
                                              .rejectingBranchResponses![index].address),
                                          Text('Lý do: ${donatedRequest.rejectingBranchResponses![index].rejectingReason}',
                                          style: const TextStyle(color: Colors.red),
                                          ),   
                                        ],
                                      ),
                                    ),
                                        ),
                                    ],
                                  ),
                                )
                              : Card(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.0, left: 8.0),
                                      child: Text(
                                        'Nơi nhận:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              donatedRequest
                                                  .acceptedBranch!.image)),
                                      title: Text(
                                        donatedRequest.acceptedBranch!.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(donatedRequest
                                          .acceptedBranch!.address),
                                    ),
                                  ],
                                )),
                          const SizedBox(
                            height: 4,
                          ),
                          donatedRequest.simpleActivityResponse == null
                              ? const SizedBox()
                              : Card(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Quyên góp cho hoạt động: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Text(
                                                donatedRequest
                                                    .simpleActivityResponse!
                                                    .name,
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // RichText(
                                        //   text: TextSpan(
                                        //     style: const TextStyle(
                                        //         fontSize: 12,
                                        //         color: Colors.black),
                                        //     children: <TextSpan>[
                                        //       const TextSpan(
                                        //           text:
                                        //               'Quyên góp cho hoạt động: ',
                                        //           style: TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight.w500)),
                                        //       TextSpan(
                                        //         text: donatedRequest
                                        //             .simpleActivityResponse!
                                        //             .name,
                                        //             style: const TextStyle(
                                        //               color: Colors.blue,
                                        //               decoration: TextDecoration.underline,
                                        //             )
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      )),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Thời gian nhận:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: donatedRequest.scheduledTimes.length,
                                itemBuilder: (context, index) {
                                  return TimeSelectWidget(
                                    txtDate: Utils.converDate(donatedRequest
                                        .scheduledTimes[index].day),
                                    txtHour:
                                        '${donatedRequest.scheduledTimes[index].startTime} - ${donatedRequest.scheduledTimes[index].endTime}',
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 12,
                          ),

                          isEmptyNonRejectedItem ? const SizedBox() :
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Danh sách sản phẩm quyên góp',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HistoryDeliveryRequestListScreen(
                                        idDonatedRequest: donatedRequest.id,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Vật phẩm đã giao',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primarySecond),
                                ),
                              ),
                            ],
                          ),

                          isEmptyNonRejectedItem ? const SizedBox() :
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                donatedRequest.donatedItemResponses.length,
                            itemBuilder: (context, index) =>
                                DonatedItemDetailCard(
                                    image: donatedRequest
                                        .donatedItemResponses[index]
                                        .itemTemplateResponse
                                        .image,
                                    name: donatedRequest
                                        .donatedItemResponses[index]
                                        .itemTemplateResponse
                                        .name,
                                    quantity: donatedRequest
                                        .donatedItemResponses[index].quantity
                                        .toString(),
                                    unit: donatedRequest
                                        .donatedItemResponses[index]
                                        .itemTemplateResponse
                                        .unit,
                                    expiredDate: donatedRequest
                                        .donatedItemResponses[index]
                                        .initialExpirationDate),
                          ),

                          // Danh sách vật phẩm bị từ chối

                           isEmptyRejectedItem ? const SizedBox() :
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              const Text(
                            'Danh sách vật phẩm quyên góp bị từ chối',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                rejectedItems.length,
                            itemBuilder: (context, index) =>
                                DonatedItemDetailCard(
                                    image: rejectedItems[index]
                                        .itemTemplateResponse
                                        .image,
                                    name: rejectedItems[index]
                                        .itemTemplateResponse
                                        .name,
                                    quantity: rejectedItems[index].quantity
                                        .toString(),
                                    unit: rejectedItems[index]
                                        .itemTemplateResponse
                                        .unit,
                                    expiredDate: rejectedItems[index]
                                        .initialExpirationDate),
                          ),
                          const SizedBox(height: 5,),
                          
                          donatedRequest.acceptedBranch == null ? const SizedBox():
                           donatedRequest.acceptedBranch!.rejectingReason.isEmpty ? const SizedBox() :
                          Text('Lý do bị từ chối: ${donatedRequest.acceptedBranch!.rejectingReason}',
                                          style: const TextStyle(color: Colors.red),
                                          ),   
                                          const SizedBox(height: 5,),
                            ],
                           ),
                          
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Ghi chú :',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(donatedRequest.note),
                          const SizedBox(
                            height: 30,
                          ),
                          Visibility(
                            visible: donatedRequest.status == 'PENDING' ||
                                donatedRequest.status == 'ACCEPTED',
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    bool isConfirm = await DialogHelper.showCustomDialog(
                                      context: context, 
                                      title: 'Hủy yêu cầu quyên góp', 
                                      body: 'Bạn có chắc muốn hủy không?');
                                      if (isConfirm){
                                    try {
                                      if (context.mounted) DialogHelper.showLoading(context);

                                      bool isSuccess =
                                          await DonatedRequestService
                                              .cancelDonatedRequest(
                                                  idDonatedRequest:
                                                      donatedRequest.id);
                                      if (isSuccess) {
                                        Fluttertoast.showToast(
                                            msg: 'Hủy thành công');
                                      }

                                      if (!context.mounted) return;
                                      DialogHelper.hideLoading(context);

                                      Navigator.of(context).pop(true);
                                    } catch (error) {
                                      DialogHelper.hideLoading(context);
                                      DialogHelper.showAwesomeDialogError(
                                          context, error.toString());
                                    }
                                  }},
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide.none,
                                      shape: const StadiumBorder(),
                                      backgroundColor: AppTheme.primarySecond),
                                  child: const Text(
                                    "Hủy",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              );
            }
          }),
    );
  }
}
