import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/report_delivery_request_screen.dart';
import 'package:food_donation_delivery_app/utils/delivery_request_utils.dart';

class DeliveryRequestMapCard extends StatelessWidget {
  final OrderedDeliveryRequests deliveryRequest;
  final VoidCallback reload;
  final bool isImported;
  const DeliveryRequestMapCard({
    super.key,
    required this.deliveryRequest,
    required this.reload,
    required this.isImported
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        deliveryRequest.avatar
                      ),
                    ),
                    deliveryRequest.status == null ? const SizedBox() :
                  Positioned(
                    top: -30,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: DeliveryRequestUtils.colorStatus(deliveryRequest.status ?? ''),
                      ),
                      child: Text(DeliveryRequestUtils.textStatus(deliveryRequest.status ?? ''),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
                  ),
                  ],
                ),
                title: Text(
                            deliveryRequest.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(deliveryRequest.phone),
              ),
              // Row(
              //   mainAxisAlignment:
              //       MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Padding(
              //           padding:
              //               const EdgeInsets.only(right: 10.0),
              //           child: CircleAvatar(
              //             backgroundImage: NetworkImage(
              //                 deliveryRequest.avatar),
              //           ),
              //         ),
              //         Column(
              //           crossAxisAlignment:
              //               CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               deliveryRequest.name,
              //               style: const TextStyle(
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             Text(deliveryRequest.phone),
              //           ],
              //         ),
              //       ],
              //     ),
                  
              //   ],
              // ),
              
              // const SizedBox(
              //   height: 16,
              // ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Thời gian: ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    TextSpan(
                      text: '${deliveryRequest.currentScheduledTime?.startTime}-${deliveryRequest.currentScheduledTime?.endTime}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Địa chỉ: ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    TextSpan(
                      text: deliveryRequest.address,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(4.0)),
                        elevation: MaterialStateProperty.all(1),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(
                              ((deliveryRequest.status == 'SHIPPING' || deliveryRequest.status == 'ARRIVED_PICKUP') && isImported) ?
                                Colors.red : Colors.grey)),
                    onPressed: ((deliveryRequest.status == 'SHIPPING' || deliveryRequest.status == 'ARRIVED_PICKUP') && isImported) ?  () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDeliveryRequestScreen(
                            orderedDeliveryRequests: deliveryRequest,
                          ),
                        ),
                      ).then((value) {
                        if (value == true){
                          reload();
                        }
                      })
                      ;
                    } :  null,
                    icon: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(4.0)),
                        elevation: MaterialStateProperty.all(1),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(
                                Colors.green)),
                    onPressed: () {
                      FlutterPhoneDirectCaller.callNumber(deliveryRequest.phone);
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        AppTheme.primarySecond)),
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryRequestDetailScreen(
                            idDeliveryRequest: deliveryRequest.id,
                            isRunning: true,
                          ),
                        ),
                      ).then((value) => reload());
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}