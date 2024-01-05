import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerCommentCard extends StatelessWidget {
  const ShimmerCommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerWidget.circular(
    width: 40, 
    height: 40),
    const SizedBox(width: 10,),
    ShimmerWidget.circular(height: 60,
    width: 180,
    shapeBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    )
      ],
    );
  }
}