import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';

class UpdateItemDeliveryDialog extends StatefulWidget {
  final DeliveryItems item;
  final void Function(int) updateItem;

  const UpdateItemDeliveryDialog(
      {super.key, 
      required this.item, 
      required this.updateItem});

  @override
  State<UpdateItemDeliveryDialog> createState() =>
      _UpdateItemDeliveryDialogState();
}

class _UpdateItemDeliveryDialogState
    extends State<UpdateItemDeliveryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txtQuantity = TextEditingController();
  String _messageQuantity = '';
  bool _isRefresh = false;

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      _messageQuantity = 'Vui lòng nhập số nguyên (0-9999)';
    }
    if (int.tryParse(value!) == null || int.tryParse(value)! < 0 || int.tryParse(value)! > 10000) {
       _messageQuantity = 'Vui lòng nhập số nguyên (0-9999)';
    }
    if (_messageQuantity.isNotEmpty){
      setState(() {
      _isRefresh = !_isRefresh;
    });
    return '';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _txtQuantity.text = widget.item.receivedQuantity == null ?  widget.item.quantity.toString() : widget.item.receivedQuantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Cập nhật'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // _routeController.updateReceiveQuantity(
              //   idDeliveryRequest: widget.idDeliveryRequest, 
              //   idItem: widget.item.deliveryItemId, 
              //   quantity:  int.tryParse(_txtQuantity.text) ?? 0);
              widget.updateItem(int.tryParse(_txtQuantity.text) ?? 0);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(2.0),
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image:  DecorationImage(
                      image: NetworkImage(widget.item.image),
                      fit: BoxFit.cover)),
            ),
            Center(
              child: Text(
                widget.item.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            // Text(widget.item.attributes
            //     .map((e) => e.attributeValue)
            //     .join(' - ')),
            //     const SizedBox(height: 10,),
            const SizedBox(height: 10,),
            Text('Số lượng: ${widget.item.quantity} ${widget.item.unit}'),
            Row(
              children: [
                const Text('Số lượng thực nhận: '),
                SizedBox(
                    width: 50,
                    height: 25,
                    child: TextFormField(
                      validator: _validateQuantity,
                      controller: _txtQuantity,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        if (int.tryParse(value) != null && int.tryParse(value)! >= 0 && int.tryParse(value)! < 10000) {
                              setState(() {
                              _messageQuantity='';
                              });
                        } else {
                          setState(() {
                             _messageQuantity = 'Vui lòng nhập số nguyên (0-9999)';
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    )),
                Text(' ${widget.item.unit}'),
              ],
            ),
            Visibility(
              visible: _messageQuantity.isNotEmpty,
              child: Text(
                _messageQuantity,
                style: const TextStyle(
                  color: Colors.red
                ),
              )
              ),
          ],
        ),
      ),
    );
  }
}
