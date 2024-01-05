import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/services/item_service.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/item_donation_create_search_card.dart';

class SearchItemDonationDialog extends StatefulWidget {
  final Function(ItemList) onTap;
  final List<ItemList>? list;

  const SearchItemDonationDialog({super.key, required this.onTap, this.list});

  @override
  State<SearchItemDonationDialog> createState() =>
      _SearchItemDonationDialogState();
}

class _SearchItemDonationDialogState extends State<SearchItemDonationDialog> {
  List<ItemList> _itemsList = List.empty(growable: true);
  final TextEditingController _txtSearch = TextEditingController();
  final _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    if (widget.list == null) {
      ItemService.fetchItemsList().then((value) {
        setState(() {
          _itemsList = value;
        });
      });
    } else {
      _itemsList = widget.list!;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      if (widget.list == null) {
        ItemService.fetchItemsList(searchKeyWord: _txtSearch.text, page: _page)
            .then((value) {
          setState(() {
            _itemsList.addAll(value);
          });
        });
      }
    }
  }

  void _runFilter() {
    if (widget.list == null) {
      _page = 1;
      ItemService.fetchItemsList(searchKeyWord: _txtSearch.text).then((value) {
        setState(() {
          _itemsList = value;
        });
      });
    } else {
      setState(() {
        _itemsList = widget.list!
            .where((element) => element.name.contains(_txtSearch.text))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _txtSearch,
              onSubmitted: (value) {
                _runFilter();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(width: 0.8),
                ),
                labelText: 'Tìm kiếm',
                prefixIcon: IconButton(
                  onPressed: () {
                    _runFilter();
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _itemsList.isEmpty
                ? const SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Icon(
                          Icons.search,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          'Không tìm thấy vật phẩm',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: _itemsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                widget.onTap(_itemsList[index]);
                                Navigator.of(context).pop();
                              },
                              child: ItemDonationCreateSearchCard(
                                item: _itemsList[index],
                              ));
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
