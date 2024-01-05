import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/donated_request_list.dart';
import 'package:food_donation_delivery_app/screens/donation/create_donation_screen.dart';
import 'package:food_donation_delivery_app/services/donated_request_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/donated_request_card.dart';
import 'package:food_donation_delivery_app/widgets/donation_request/shimmer_donation_request_card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _txtDateFrom = TextEditingController();
  final TextEditingController _txtDateTo = TextEditingController();
  List<DonatedRequestList> _donatedRequests = List.empty(growable: true);
  String _txtMessage = '';
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  int _page = 1;
  bool _isLoading = true;

  void _getData(){
    setState(() {
       _isLoading = true;
    });
    DonatedRequestService.fetchDonatedRequestList().then((value) {
        _donatedRequests = value;
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _runFilter(){
    setState(() {
      _isLoading = true;
    });
    DonatedRequestService.fetchDonatedRequestList(
      startDate: _selectedDateFrom == null ? '' : _selectedDateFrom.toString(),
      endDate: _selectedDateTo == null ? '' : _selectedDateTo.toString()
    ).then((value) {
        _donatedRequests = value;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      DonatedRequestService.fetchDonatedRequestList(
        page: _page,
        startDate: _selectedDateFrom == null ? '' : _selectedDateFrom.toString(),
      endDate: _selectedDateTo == null ? '' : _selectedDateTo.toString(),
      ).then((data) {
        setState(() {
          _donatedRequests.addAll(data);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách quyên góp',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateDonationScreen(),
                          )).then((value) {
                            if (value == true){
                              _getData();
                            }
                          });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: TextFormField(
                                // validator: _validateDateRange,
                                controller: _txtDateFrom,
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(
                                  label: Text("Từ ngày"),
                                  suffixIcon: Icon(Icons.date_range),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                                ),
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    
                                    initialDate:
                                        _selectedDateFrom ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null &&
                                      picked != _selectedDateFrom) {
                                    setState(() {
                                      _selectedDateFrom = picked;
                                      _txtDateFrom.text =
                                          Utils.converDate(picked.toString());
                                    });

                                    if (_txtDateFrom.text != '' &&
                                        _txtDateTo.text != '') {
                                      if (_selectedDateTo!
                                          .isBefore(_selectedDateFrom!)) {
                                        setState(() {
                                          _txtMessage = 'Ngày bắt đầu không thể sau ngày kết thúc';
                                        });
                                      }else{
                                        _txtMessage = '';
                                        _runFilter();
                                      }
                                    }else {
                                      _runFilter();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: TextFormField(
                                // validator: _validateDateRange,
                                controller: _txtDateTo,
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(
                                  label: Text("Đến ngày"),
                                  suffixIcon: Icon(Icons.date_range),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                                ),
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDateTo ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null &&
                                      picked != _selectedDateTo) {
                                    setState(() {
                                      _selectedDateTo = picked;
                                      _txtDateTo.text =
                                          Utils.converDate(picked.toString());
                                    });

                                    if (_txtDateFrom.text != '' &&
                                        _txtDateTo.text != '') {
                                      if (_selectedDateTo!
                                          .isBefore(_selectedDateFrom!)) {
                                        setState(() {
                                          _txtMessage = 'Ngày kết thúc không thể trước ngày bắt đầu';
                                        });
                                      } else{
                                        _txtMessage = '';
                                        _runFilter();
                                      }
                                    } else {
                                      _runFilter();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              const SizedBox(
                height: 5,
              ),
              _txtMessage.isEmpty ? const SizedBox() :
              Text(_txtMessage,
              style: const TextStyle(
                color: Colors.red
              ),
              ),
              const SizedBox(
                height: 5,
              ),
              (_donatedRequests.isEmpty && !_isLoading)
                  ? const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Icon(
                            Icons.search,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text(
                            'Không có yêu cầu quyên góp',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ListView.builder(
                          itemCount: _isLoading ? 6 : _donatedRequests.length,
                          itemBuilder: (context, index) {
                            return _isLoading ? const ShimmerDonationRequestCard()
                             : DonatedRequestCard(
                              donatedRequest: _donatedRequests[index],
                              reload: _getData,
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

