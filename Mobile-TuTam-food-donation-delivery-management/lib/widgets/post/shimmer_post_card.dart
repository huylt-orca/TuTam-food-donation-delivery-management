import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      decoration: const BoxDecoration(
        color: AppTheme.mainBackground,
        border: Border.symmetric(
            horizontal: BorderSide(
          color: Colors.grey,
          width: 1.0,
        )),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                      child:
                          ShimmerWidget.circular(width: 40, height: 40),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget.rectangular(
                          height: 14,
                          width: 70,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ShimmerWidget.rectangular(
                          height: 10,
                          width: 100,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ShimmerWidget.rectangular(
                  height: 12,
                ),
                SizedBox(
                  height: 8,
                ),
                ShimmerWidget.rectangular(
                  height: 12,
                ),
                SizedBox(
                  height: 8,
                ),
                ShimmerWidget.rectangular(
                  height: 12,
                  width: 170,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: const ShimmerWidget.rectangular(height: 170),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget.circular(
                width: 10, height: 10),
                SizedBox(width: 10,),
                ShimmerWidget.circular(
                width: 10, height: 10),
                SizedBox(width: 10,),
                ShimmerWidget.circular(
                width: 10, height: 10),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: SizedBox(),),
                ShimmerWidget.rectangular(height: 16, width: 100,),
                Expanded(child: SizedBox(),),
                 ShimmerWidget.rectangular(height: 16, width: 100,),
                 Expanded(child: SizedBox(),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
