import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerNotificationCard extends StatelessWidget {
  const ShimmerNotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ShimmerWidget.circular(
        width: 70, 
        height: 70),
      title: Align(
        alignment: Alignment.centerLeft,
        child: ShimmerWidget.rectangular(
          height: 14,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ShimmerWidget.rectangular(height: 12,
           width: MediaQuery.of(context).size.width * 0.8,),
          const SizedBox(
            height: 10,
          ),
          ShimmerWidget.rectangular(
            height: 10,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ],
      ),
      isThreeLine: false,
    );
  }
}
