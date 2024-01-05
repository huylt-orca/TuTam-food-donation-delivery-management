import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerMyActivityTaskCard extends StatelessWidget {
  const ShimmerMyActivityTaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.4,
            ),
          const SizedBox(height: 10,),
          ShimmerWidget.rectangular(
            height: 12,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          const Divider(),
          Row(
            children: [
              const SizedBox(
                  height: 25,
                  child: VerticalDivider(
                    color: Colors.black,
                  )),
              const Column(
                children: [
                  ShimmerWidget.rectangular(
                    height: 12,
                    width: 100,
                    ),
                    SizedBox(height: 10,),
                     ShimmerWidget.rectangular(
                    height: 12,
                    width: 100,
                    ),
                ],
              ),
              const Expanded(child: SizedBox()),
              ShimmerWidget.circular(
                width: 100,
                height: 30,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                )
            ],
          ),
        ],
      ),
    );
  }
}
