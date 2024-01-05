import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/charity_unit.dart';
import 'package:food_donation_delivery_app/services/branch_service.dart';
import 'package:food_donation_delivery_app/services/charity_unit_service.dart';
import 'package:food_donation_delivery_app/widgets/branch/branch_list_widget.dart';
import 'package:food_donation_delivery_app/widgets/charity/charity_list_widget.dart';
import 'package:food_donation_delivery_app/widgets/shortcut_information_widget.dart';

class SearchBranchUnitScreen extends StatefulWidget {
  final int selectedOption;

  const SearchBranchUnitScreen({super.key, this.selectedOption = 1});

  @override
  State<SearchBranchUnitScreen> createState() => _SearchBranchUnitScreenState();
}

class _SearchBranchUnitScreenState extends State<SearchBranchUnitScreen> {
  int _selectBranch = 1;
  final _txtSearch = TextEditingController();
  List<Branch> _listBranches = List.empty(growable: true);
  List<CharityUnit> _listCharity = List.empty(growable: true);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectBranch = widget.selectedOption;
    getData();
  }

  void getData() async {
    CharityUnitService.fetchCharityUnitsList(pageSize: 100).then((value) {
      setState(() {
        _listCharity = value;
        _isLoading = false;
      });
    });
    BranchService.fetchBranchesList(pageSize: 100).then((value) {
      setState(() {
        _listBranches = value;
        _isLoading = false;
      });
    });
  }

  void _runFilter() {
    setState(() {
      _isLoading = true;
    });
    CharityUnitService.fetchCharityUnitsList(pageSize: 100, name: _txtSearch.text)
        .then((value) {
      setState(() {
        _listCharity = value;
        _isLoading = false;
      });
    });
    BranchService.fetchBranchesList(pageSize: 100, name: _txtSearch.text)
        .then((value) {
      setState(() {
        _listBranches = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _txtSearch,
                // onChanged: (value) {
                //   _runFilter();
                // },
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  ShortcutInformationWidget(
                    text: 'Chi nhánh Từ Tâm',
                    icon: Icons.store,
                    color: _selectBranch == 1
                        ? AppTheme.primarySecond
                        : Colors.black87,
                    onPress: () {
                      setState(() {
                        _selectBranch = 1;
                      });
                    },
                  ),
                  ShortcutInformationWidget(
                    text: 'Tổ chức liên kết',
                    icon: Icons.location_city,
                    color: _selectBranch == 2
                        ? AppTheme.primarySecond
                        : Colors.black87,
                    onPress: () {
                      setState(() {
                        _selectBranch = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectBranch == 1 
              ? BranchListWidget(listBranches: _listBranches, isLoading: _isLoading,) 
              : CharityListWidget(listCharities: _listCharity, isLoading: _isLoading,)
            ),
          ],
        ),
      ),
    );
  }
}


