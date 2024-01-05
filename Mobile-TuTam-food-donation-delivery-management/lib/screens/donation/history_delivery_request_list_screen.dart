import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/delivery_request_list_user.dart';
import 'package:food_donation_delivery_app/screens/donation/history_delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/services/donated_request_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class HistoryDeliveryRequestListScreen extends StatelessWidget {
  final String idDonatedRequest;
  const HistoryDeliveryRequestListScreen(
      {super.key, required this.idDonatedRequest});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Các đơn đã giao'),
        ),
        body: FutureBuilder<List<DeliveryRequestListUser>>(
            future: DonatedRequestService.fetchDeliveryRequestListByIdDonated(
                donatedRequestId: idDonatedRequest),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) => const Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: ShimmerWidget.rectangular(height: 200)),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ShimmerWidget.rectangular(
                            height: 20,
                            width: 200,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading:
                              ShimmerWidget.circular(width: 50, height: 50),
                          title: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ShimmerWidget.rectangular(
                              height: 20,
                              width: 200,
                            ),
                          ),
                          subtitle: ShimmerWidget.rectangular(
                            height: 20,
                            width: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final data = snapshot.data;
                return (data == null || data.isEmpty)
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
                              'Chưa có đơn được giao',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          HistoryDeliveryRequestDetailScreen(
                            idDeliveryRequest: data[index].id,
                          ),
                        ),
                      );
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: Image.network(data[index].proofImage,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Ngày nhận: ${Utils.converDate(data[index].currentScheduledTime.day)}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data[index].avatar),
                                  ),
                                  title: Text(
                                    data[index].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(data[index].phone),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              }
            }),
      ),
    );
  }
}
