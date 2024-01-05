import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class ItemDonationCreateDetailDialog extends StatefulWidget {
  final ItemList item;
  final void Function(ItemList) updateItem;
  const ItemDonationCreateDetailDialog(
      {super.key, required this.item, required this.updateItem});

  @override
  State<ItemDonationCreateDetailDialog> createState() =>
      _ItemDonationCreateDetailDialogState();
}

class _ItemDonationCreateDetailDialogState
    extends State<ItemDonationCreateDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txtQuantity = TextEditingController();
  final TextEditingController _txtLeftDate = TextEditingController();
  final TextEditingController _txtExpiredDate = TextEditingController();
  DateTime? _selectedDateExpired = DateTime.now().add(const Duration(days: 2));
  String _messageQuantity = '';
  String _messageLeftDate = '';
  bool _isRefresh = false;


  String? _validateExpiredDate(String? value) {
    
    return null;
  }

  String? _validateLeftDate(String? value) {
    int date = Utils.subDate(DateTime.now().toString(),DateTime.now().add(const Duration(days: 365 *5)).toString());
    if (value == null || value.isEmpty) {
      _messageLeftDate = 'Số ngày còn hạn của vật phẩm phải lớn hơn 2';
    }
    if (int.tryParse(value!) == null ){
      _messageLeftDate = 'Vui lòng nhập số nguyên (0,1,2...)';
    }
    if (int.tryParse(value)! > date + 1){
      _messageLeftDate = 'Hạn sử dụng tối đa 5 năm';
    }
    if (int.tryParse(value) == null || int.tryParse(value)! < 2 ) {
      _messageLeftDate = 'Số ngày còn hạn của vật phẩm phải lớn hơn bằng 2';
    }
    if (_messageLeftDate.isNotEmpty){
      setState(() {
      _isRefresh = !_isRefresh;
    });
    return '';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      _messageQuantity = 'Vui lòng nhập số nguyên (1-9999)';
    }
    if (int.tryParse(value!) == null || int.tryParse(value)! <= 0 || int.tryParse(value)! > 10000) {
       _messageQuantity = 'Vui lòng nhập số nguyên (1-9999)';
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

    _txtExpiredDate.text = widget.item.initialExpirationDate == null  ? '' : Utils.converDate(widget.item.initialExpirationDate.toString());
    _txtLeftDate.text =  widget.item.leftDate.toString();
    _txtQuantity.text = widget.item.quantity.toString();
    _selectedDateExpired = widget.item.initialExpirationDate;
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
          child: const Text('Tạo'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              widget.item.initialExpirationDate = _selectedDateExpired;
              widget.item.quantity = int.tryParse(_txtQuantity.text) ?? 0;
              widget.item.leftDate = int.tryParse(_txtLeftDate.text) ?? 2;
              widget.item.isValid = 1;
              widget.updateItem(widget.item);
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
            Text(widget.item.attributes
                .map((e) => e.attributeValue)
                .join(' - ')),
                const SizedBox(height: 10,),
            Row(
              children: [
                const Text('Số lượng: '),
                SizedBox(
                    width: 50,
                    height: 25,
                    child: TextFormField(
                      onChanged: (value){
                        setState(() {
                          _isRefresh = !_isRefresh;
                        });
                      },
                      validator: _validateQuantity,
                      controller: _txtQuantity,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        if (int.tryParse(value) != null && int.tryParse(value)! > 0 && int.tryParse(value)! < 10000) {
                              setState(() {
                              _messageQuantity='';
                              });
                        } else {
                          setState(() {
                             _messageQuantity = 'Vui lòng nhập số nguyên (1-9999)';
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
                Text(' ${widget.item.unit.name}'),
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
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Hạn sử dụng: '),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      validator: _validateExpiredDate,
                      controller: _txtExpiredDate,
                      keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 8.0),
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          helpText: 'Chọn ngày',
                          context: context,
                          initialDate: _selectedDateExpired ?? DateTime.now().add(const Duration(days: 2)),
                          firstDate: DateTime.now().add(const Duration(days: 2)),
                          lastDate: DateTime.now().add(const Duration(days: 365 *5)),
                        );
                        if (picked != null && picked != _selectedDateExpired) {
                          setState(() {
                            DateTime now = DateTime.now();
                            DateTime currentDateWithoutTime =
                                DateTime(now.year, now.month, now.day);
                            _selectedDateExpired = picked;
                            _txtExpiredDate.text =
                                Utils.converDate(picked.toString());
                            _txtLeftDate.text = picked
                                .difference(currentDateWithoutTime)
                                .inDays
                                .toString();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Hạn còn: '),
                SizedBox(
                    width: _txtLeftDate.text.length < 4 ? 50 : _txtLeftDate.text.length > 10 ? 140 : _txtLeftDate.text.length * 14,
                    height: 25,
                    child: TextFormField(
                      onChanged: (value){
                        setState(() {
                          _isRefresh = !_isRefresh;
                        });
                      },
                      validator: _validateLeftDate,
                      controller: _txtLeftDate,
                      onFieldSubmitted: (value) {
                        if (int.tryParse(value) != null){
                        if (int.tryParse(value)! <= Utils.subDate(DateTime.now().toString(), DateTime.now().add(const Duration(days: 365 *5)).toString())){
                        if (
                            int.tryParse(value)! >= 2) {
                              _messageLeftDate='';
                                _selectedDateExpired = DateTime.now().add(Duration(days: int.tryParse(value) ?? 0));

                          setState(() {
                            _txtExpiredDate.text = Utils.converDate(DateTime
                                    .now()
                                .add(Duration(days: int.tryParse(value) ?? 0))
                                .toString());
                          });
                        } else {
                          setState(() {
                            _messageLeftDate = 'Số ngày còn hạn của vật phẩm phải lớn hơn bằng 2';
                          });
                        }
                        } else {
                          setState(() {
                            _messageLeftDate = 'Hạn sử dụng tối đa 5 năm';
                          });
                        }}
                        else {
                          setState(() {
                            _messageLeftDate = 'Vui lòng nhập số nguyên (0,1,2...)';
                          });
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    )),
                const Text(' ngày'),
              ],
            ),
            Visibility(
              visible: _messageLeftDate.isNotEmpty,
              child: Text(
                _messageLeftDate,
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
