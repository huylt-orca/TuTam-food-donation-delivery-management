import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';

class ItemDonationCreateSearchCard extends StatelessWidget {
  final ItemList item;
  const ItemDonationCreateSearchCard({
    super.key,
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
                  margin: const EdgeInsets.all(4.0),
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      image: DecorationImage(
                          image: NetworkImage(item.image),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                      ),
                     Text(item.attributes.map((e) => e.attributeValue).join(' - '))
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}