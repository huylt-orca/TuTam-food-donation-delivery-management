import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/activity_filter.dart';
import 'package:food_donation_delivery_app/models/activity_type.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/province.dart';
import 'package:food_donation_delivery_app/services/branch_service.dart';
import 'package:food_donation_delivery_app/services/utils_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class ActivityFilterScreen extends StatefulWidget {
  final ActivityFilter activityFilter;
  final void Function(ActivityFilter) filter;

  const ActivityFilterScreen(
      {super.key, required this.activityFilter, required this.filter});

  @override
  State<ActivityFilterScreen> createState() => _ActivityFilterScreenState();
}

class _ActivityFilterScreenState extends State<ActivityFilterScreen> {
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtDateFrom = TextEditingController();
  final TextEditingController _txtDateTo = TextEditingController();
  final TextEditingController _txtSearchBranch = TextEditingController();
  final TextEditingController _txtSearchProvince = TextEditingController();
  final TextEditingController _txtSearchDistrict = TextEditingController();
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  String _txtMessage = '';
  int _selectedStatus = -1;
  final List<String> _listStatus = [
    'Tất cả',
    'Sắp mở',
    'Hoạt động',
    'Đã kết thúc'
  ];
  bool _isRefresh = true;

  List<ActivityType> _listActivityType = List.empty(growable: true);

  List<Branch> _listBranch = List.empty(growable: true);
  Branch? _selectedBranch;

  List<Province> _listProvinces = List.empty(growable: true);
  Province? _selectedProvince;

  List<Province> _listDistricts = List.empty(growable: true);
  Province? _selectedDistrict;

  final _formKey = GlobalKey<FormState>();

  String? _validateDateRange(String? value) {
    if (_txtDateFrom.text != '' && _txtDateTo.text != '') {
      if (_selectedDateTo!.isBefore(_selectedDateFrom!)) {
        setState(() {
          _txtMessage = 'Ngày bắt đầu không thể sau ngày kết thúc';
        });
        return '';
      }
    }
    setState(() {
      _txtMessage = '';
    });
    return null;
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedStatus = value!;
    });
  }

  void _handleCheckBoxValueChanged(int index, bool value) {
    setState(() {
      _listActivityType[index].isTrue = value;
    });
  }

  void _clearData() {
    setState(() {
      _txtName.clear();
      _txtDateFrom.clear();
      _txtDateTo.clear();
      _txtSearchBranch.clear();
      _txtSearchDistrict.clear();
      _txtSearchProvince.clear();
      _selectedStatus = -1;
      _selectedDateFrom = null;
      _selectedDateTo = null;

      for (var element in _listActivityType) {
        element.isTrue = false;
      }
      _selectedProvince = null;
      _selectedDistrict = null;
      _selectedBranch = null;

      _txtMessage = '';
    });
  }

  void getDataFrom() async {
    _txtName.text = widget.activityFilter.name ?? '';

    if (widget.activityFilter.startDate != null) {
      _selectedDateFrom = widget.activityFilter.startDate;
      _txtDateFrom.text =
          Utils.converDate(widget.activityFilter.startDate.toString());
    }

    if (widget.activityFilter.endDate != null) {
      _selectedDateTo = widget.activityFilter.endDate;
      _txtDateTo.text =
          Utils.converDate(widget.activityFilter.endDate.toString());
    }

    _selectedStatus = widget.activityFilter.status;

    _listActivityType = widget.activityFilter.activityType ?? ActivityType.list;



    await UtilsService.fetchProvinceList().then((value) {
      setState(() {
        _listProvinces = value;
      });
    });

    await BranchService.fetchBranchesList(pageSize: 100).then((value) {
      setState(() {
        _listBranch = value;
      });
    });

    //     _selectedBranch = widget.activityFilter.branch;

    // _selectedProvince = widget.activityFilter.province;
    // _selectedDistrict = widget.activityFilter.district;

  }

  @override
  void initState() {
    super.initState();
    getDataFrom();
    

    // _listProvinces = Province.listProvince;
    // _listBranch = Branch.list;
    // _listActivityType = ActivityType.list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Bộ lọc'),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tên hoạt động'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _txtName,
                        decoration: const InputDecoration(
                          label: Text("Tên hoạt động"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Thời gian'),
                      Visibility(
                        visible: _txtMessage != '',
                        child: Text(
                          _txtMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: TextFormField(
                                validator: _validateDateRange,
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
                                        Fluttertoast.showToast(
                                          msg:
                                              'Ngày bắt đầu không thể sau ngày kết thúc',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          fontSize: 16.0,
                                        );
                                      }
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
                                validator: _validateDateRange,
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
                                        Fluttertoast.showToast(
                                          msg:
                                              'Ngày kết thúc không thể trước ngày bắt đầu',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          fontSize: 16.0,
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Trạng thái'),
                      const SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _listStatus.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            title: Text(_listStatus[index]),
                            value: index - 1,
                            groupValue: _selectedStatus,
                            onChanged: _handleRadioValueChange,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Loại hoạt động'),
                      const SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _listActivityType.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(_listActivityType[index].name),
                            value: _listActivityType[index].isTrue,
                            onChanged: (bool? value) {
                              _handleCheckBoxValueChanged(
                                  index, value ?? false);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Chi nhánh thực hiện'),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Branch>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    'Chọn chi nhánh',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: _listBranch
                                .map((Branch item) => DropdownMenuItem<Branch>(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: _selectedBranch,
                            onChanged: (Branch? value) {
                              setState(() {
                                _selectedBranch = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 200,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0)),
                                color: Colors.white,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: _txtSearchBranch,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: _txtSearchBranch,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Tìm kiếm',
                                      hintStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Khu vực thực hiện'),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Province>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    'Chọn tỉnh/ thành phố',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: _listProvinces
                                .map((Province item) =>
                                    DropdownMenuItem<Province>(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: _selectedProvince,
                            onChanged: (Province? value) {
                              UtilsService.fetchDistrictList(value!.code)
                                  .then((value) {
                                setState(() {
                                  _listDistricts = value;
                                });
                              });
                              setState(() {
                                _selectedProvince = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 200,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                                color: Colors.white,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchMatchFn: (item, searchValue) {
                                return item.value!.name
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase());
                              },
                              searchController: _txtSearchProvince,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: _txtSearchProvince,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Tìm kiếm',
                                    hintStyle: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _selectedProvince != null,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Province>(
                              isExpanded: true,
                              hint: const Row(
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Chọn quận/ huyện',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: _listDistricts
                                  .map((Province item) =>
                                      DropdownMenuItem<Province>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: _selectedDistrict,
                              onChanged: (Province? value) {
                                setState(() {
                                  _selectedDistrict = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                                elevation: 2,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0)),
                                  color: Colors.white,
                                ),
                                offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchMatchFn: (item, searchValue) {
                                  return item.value!.name
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                                searchController: _txtSearchDistrict,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: _txtSearchDistrict,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Tìm kiếm',
                                        hintStyle: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _clearData();
                            },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.primarySecond, width: 1.0),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.white),
                            child: const Text(
                              "Thiết lập lại",
                              style: TextStyle(
                                color: AppTheme.primarySecond,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ActivityFilter newFilter = ActivityFilter(
                                    name: _txtName.text,
                                    startDate: _selectedDateFrom,
                                    endDate: _selectedDateTo,
                                    status: _selectedStatus,
                                    activityType: _listActivityType,
                                    branch: _selectedBranch,
                                    province: _selectedProvince,
                                    district: _selectedDistrict);

                                widget.filter(newFilter);

                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                                backgroundColor: AppTheme.primarySecond),
                            child: const Text(
                              "Áp dụng",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
