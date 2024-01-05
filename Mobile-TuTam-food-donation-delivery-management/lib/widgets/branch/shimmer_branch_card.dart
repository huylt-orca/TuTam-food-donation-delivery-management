import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerBranchCard extends StatelessWidget {
  const ShimmerBranchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                margin: const EdgeInsets.all(8.0),
                child: const Column(
                  children: [
                   ShimmerWidget.circular(
                    width: 80, 
                    height: 80),
                    SizedBox(height: 4,),
                    ShimmerWidget.rectangular(height: 14,
                    width: 80,
                    )
                  ],
                ),
              );
  }
}