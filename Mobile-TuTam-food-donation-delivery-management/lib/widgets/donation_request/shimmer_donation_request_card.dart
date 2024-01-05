import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerDonationRequestCard extends StatelessWidget {
  const ShimmerDonationRequestCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
    color: Colors.black.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 1,
    offset: const Offset(1, 1),
            ),
          ],
            borderRadius: BorderRadius.circular(10.0), color: AppTheme.greyBackground),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerWidget.circular(
            width: 120,
            height: 100,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(width: 10,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(height: 16, width: MediaQuery.of(context).size.width * 0.4,),
            const SizedBox(height: 16,),
            ShimmerWidget.rectangular(height: 12,width: MediaQuery.of(context).size.width * 0.2,),
            const SizedBox(height: 10,),
            ShimmerWidget.rectangular(height: 12,width: MediaQuery.of(context).size.width * 0.3,),
           const SizedBox(height: 10,),
            ShimmerWidget.rectangular(height: 14,width: MediaQuery.of(context).size.width * 0.7,),
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
