import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/item_donation_create_detail_dialog.dart';

class ItemDonationCreateCard extends StatefulWidget {
  final void Function()? onDelete;
  final void Function(ItemList) updateItem;
  final ItemList item;
  const ItemDonationCreateCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.updateItem
    });

  @override
  State<ItemDonationCreateCard> createState() => _ItemDonationCreateCardState();
}

class _ItemDonationCreateCardState extends State<ItemDonationCreateCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ItemDonationCreateDetailDialog(
                item: widget.item,
                updateItem: widget.updateItem,
              );
            });
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: widget.item.isValid == -1 ?  Colors.red:  Colors.black12 
              ),
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 2.0),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                    image: DecorationImage(
                        image: NetworkImage(widget.item.image),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(width: 4,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item.name} ${widget.item.attributes.map((e)=> e.attributeValue).join(' - ')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text('Số lượng: ${widget.item.quantity} kg'),
                    Text('Hạn sử dụng: ${widget.item.initialExpirationDate == null ? '' :  Utils.converDate(widget.item.initialExpirationDate.toString())}'),
                    Text('Hạn còn: ${widget.item.leftDate} ngày'),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
