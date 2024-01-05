import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerDeliveryRequestCard extends StatelessWidget {
  const ShimmerDeliveryRequestCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: AppTheme.greyBackground,
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Color(0xFF295298),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            width: 90,
            height: 160,
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: 50,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 25,
                            child: VerticalDivider(
                              color: Colors.white,
                            )),
                        Column(
                          children: [
                            ShimmerWidget.rectangular(
                              height: 12,
                              width: 50,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            ShimmerWidget.rectangular(
                              height: 12,
                              width: 50,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(width: 2.5, color: Colors.grey)),
                          ),
                          const SizedBox(
                              height: 17,
                              child: VerticalDivider(
                                thickness: 2,
                              )),
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(width: 2.5, color: Colors.grey)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget.rectangular(
                            height: 12,
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ShimmerWidget.rectangular(
                            height: 12,
                            width: MediaQuery.of(context).size.width * 0.55,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 40,
                        width: 70,
                      ),
                      ShimmerWidget.rectangular(
                        height: 40,
                        width: 70,
                      ),
                      ShimmerWidget.rectangular(
                        height: 40,
                        width: 70,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ShimmerWidget.circular(
                        width: 100,
                        height: 40,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
