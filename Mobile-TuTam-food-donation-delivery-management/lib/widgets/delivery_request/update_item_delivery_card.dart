import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/update_item_delivery_dialog.dart';

class UpdateItemDeliveryCard extends StatelessWidget {
  final DeliveryItems item;
  final void Function(int) updateItem;

  const UpdateItemDeliveryCard({
    super.key,
    required this.item,
    required this.updateItem
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return UpdateItemDeliveryDialog(
                item: item,
                updateItem: updateItem,
              );
            });
      },
      child: Card(
          child: Container(
            decoration: BoxDecoration(
      border: Border.all(
        width: 1,
        color:   Colors.black12 
      ),
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
                image: NetworkImage(item.image),
                fit: BoxFit.cover)),
      ),
      const SizedBox(width: 4,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text('Số lượng: ${item.receivedQuantity ?? item.quantity} ${item.unit}'),
            Text('Hạn sử dụng: ${Utils.converDate(item.expiredDate)}'),
          ],
        ),
      ),
              ],
            ),
          ),
        ),
    );
  }
}