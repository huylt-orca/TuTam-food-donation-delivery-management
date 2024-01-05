import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerActivityCard extends StatelessWidget {
  const ShimmerActivityCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
        color: Colors.white,
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
                    child: ShimmerWidget.circular(
                      width: 120,
                      height: 120,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Positioned(
                      bottom: -5,
                      left: 24,
                      child: ShimmerWidget.rectangular(
                        height: 20,
                        width: 78,
                      )),
                ],
              ),
              const SizedBox(
                width: 4,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: 200,
                    ),
                    Divider(),
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 150,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 170,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 130,
                    ),
                    Divider(
                      endIndent: 40,
                    ),
                    ShimmerWidget.rectangular(
                      height: 14,
                      width: 180,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

