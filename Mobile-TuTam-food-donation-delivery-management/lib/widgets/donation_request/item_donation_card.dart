import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/donated_request_list.dart';

class ItemDonationCard extends StatelessWidget {
  final DonatedItemResponses item;
  final bool isFinished;
  const ItemDonationCard({
    super.key,
    required this.item,
    required this.isFinished
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                image: DecorationImage(
                    image: NetworkImage(item.itemTemplateResponse.image), fit: BoxFit.cover)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.itemTemplateResponse.name} ${item.itemTemplateResponse.attributeValues.join(' - ')}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quyên góp: ${item.quantity} ${item.itemTemplateResponse.unit}'),
                    isFinished ?
                    Text('Nhận: ${item.importedQuantity} ${item.itemTemplateResponse.unit}')
                    : const SizedBox()
                    ,

                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
