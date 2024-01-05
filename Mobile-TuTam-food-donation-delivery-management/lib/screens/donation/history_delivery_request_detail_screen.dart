import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/delivery_request_detail_user.dart';
import 'package:food_donation_delivery_app/screens/activity/activity_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/donation/user_report_delivery_request_screen.dart';
import 'package:food_donation_delivery_app/services/delivery_request_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/text_delivery_card_widget.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class HistoryDeliveryRequestDetailScreen extends StatefulWidget {
  final String idDeliveryRequest;
  const HistoryDeliveryRequestDetailScreen(
      {super.key, required this.idDeliveryRequest});

  @override
  State<HistoryDeliveryRequestDetailScreen> createState() =>
      _HistoryDeliveryRequestDetailScreenState();
}

class _HistoryDeliveryRequestDetailScreenState
    extends State<HistoryDeliveryRequestDetailScreen> {
  DeliveryRequestDetailUser? _deliveryRequestDetailUser;

  void _getData() {
    DeliveryRequestService.fetchDeliveryRequestDetail(
            idDeliveryRequest: widget.idDeliveryRequest)
        .then((value) {
      setState(() {
        _deliveryRequestDetailUser = value;
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
      child: _deliveryRequestDetailUser == null
          ? ShimmerWidget.rectangular(
              height: MediaQuery.of(context).size.height,
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text('Đơn vận chuyển'),
                actions: [
                  Visibility(
                    visible: !_deliveryRequestDetailUser!.isReported,
                    child: IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserReportDeliveryRequestScreen(
                                      deliveryRequestId:
                                          widget.idDeliveryRequest),
                            ),
                          ).then((value) {
                            if (value == true){
                              setState(() {
                                _deliveryRequestDetailUser!.isReported = true;
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.report)),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Image(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        _deliveryRequestDetailUser!.proofImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0),
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
                                        _deliveryRequestDetailUser!
                                            .branchImage)),
                                title: Text(
                                  _deliveryRequestDetailUser!.branchName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    _deliveryRequestDetailUser!.branchAddress),
                              ),
                            ],
                          )),
                          Card(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Text(
                                  'Người vận chuyển:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        _deliveryRequestDetailUser!
                                            .branchImage)),
                                title: Text(
                                  _deliveryRequestDetailUser!.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(_deliveryRequestDetailUser!.phone),
                              ),
                            ],
                          )),
                          Visibility(
                            visible: _deliveryRequestDetailUser!
                                .activityName.isNotEmpty,
                            child: Card(
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ActivityDetailScreen(
                                                        idActivity:
                                                            _deliveryRequestDetailUser!
                                                                .activityId),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            _deliveryRequestDetailUser!
                                                .activityName,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Danh sách sản phẩm quyên góp',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _deliveryRequestDetailUser!
                                  .deliveryItems.length,
                              itemBuilder: (context, index) => Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        _deliveryRequestDetailUser!
                                                            .deliveryItems[
                                                                index]
                                                            .image),
                                                    fit: BoxFit.cover)),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _deliveryRequestDetailUser!
                                                        .deliveryItems[index]
                                                        .name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                      'Hạn sử dụng: ${Utils.converDate(_deliveryRequestDetailUser!.deliveryItems[index].confirmedExpirationDate)}'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextDeliveryCardWidget(
                                                        description: 'Ban đầu',
                                                        text:
                                                            '${_deliveryRequestDetailUser!.deliveryItems[index].assignedQuantity} ${_deliveryRequestDetailUser!.deliveryItems[index].unit}',
                                                      ),
                                                      TextDeliveryCardWidget(
                                                        description:
                                                            'Thực giao',
                                                        text:
                                                            '${_deliveryRequestDetailUser!.deliveryItems[index].receivedQuantity} ${_deliveryRequestDetailUser!.deliveryItems[index].unit}',
                                                      ),
                                                      TextDeliveryCardWidget(
                                                        description: 'Nhập kho',
                                                        text:
                                                            '${_deliveryRequestDetailUser!.deliveryItems[index].importedQuantity} ${_deliveryRequestDetailUser!.deliveryItems[index].unit}',
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
