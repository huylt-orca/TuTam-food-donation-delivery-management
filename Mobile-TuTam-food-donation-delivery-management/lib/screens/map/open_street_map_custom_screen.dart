import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/map/custom_map_search.dart';
import 'package:food_donation_delivery_app/services/branch_service.dart';
import 'package:food_donation_delivery_app/widgets/shimmer_widget.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapCustomScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<List<double>> locationBranches;
  final Function (String address, double latitude, double longitude) onTap;
  const OpenStreetMapCustomScreen({
    super.key, 
  required this.onTap,
  required this.latitude,
  required this.longitude,
  required this.locationBranches
  });

  @override
  State<OpenStreetMapCustomScreen> createState() => _OpenStreetMapCustomScreenState();
}

class _OpenStreetMapCustomScreenState extends State<OpenStreetMapCustomScreen> {
  List<LatLng> _listBranch = List.empty(growable: true);

  void _getData(){
    if (widget.locationBranches.isNotEmpty){
    _listBranch = widget.locationBranches.map((e) => LatLng(e[0], e[1])).toList();
    } else {
    BranchService.fetchBranchesList(pageSize: 20)
    .then((value){
      setState(() {
        _listBranch = value.map((e) => LatLng(e.location[0], e.location[1])).toList();
      });
    } );
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Địa chỉ'),
        ),
        body: 
        _listBranch.isEmpty ? ShimmerWidget.rectangular(height: MediaQuery.of(context).size.height) :
        CustomMapSearch(
          branchesLocation: _listBranch,
        center:  LatLong(widget.latitude, widget.longitude),
        buttonColor: Colors.blue,
        buttonText: 'Chọn địa chỉ ở đây',
        locationPinText : '',
        hintText : 'Tìm kiếm địa chỉ',
        onPicked: (pickedData) async {
        DialogHelper.showLoading(context);
         await widget.onTap(pickedData.addressName, pickedData.latLong.latitude, pickedData.latLong.longitude);
        DialogHelper.hideLoading(context);

          // print(pickedData.latLong.latitude);
          // print(pickedData.latLong.longitude);
          // print(pickedData.address);
          Navigator.of(context).pop();
        }),
      ),
    );
  }
}