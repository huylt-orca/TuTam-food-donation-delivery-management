import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class DonatedItemDetailCard extends StatelessWidget {
  final String image;
  final String name;
  final String quantity;
  final String unit;
  final String expiredDate;
  
  const DonatedItemDetailCard({
    super.key,
    required this.image,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.expiredDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Colors.black12),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 2.0),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  image: DecorationImage(
                      image:
                          NetworkImage(image),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                   name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Số lượng: $quantity $unit'),
                  Text('Hạn sử dụng: ${Utils.converDate(expiredDate)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}