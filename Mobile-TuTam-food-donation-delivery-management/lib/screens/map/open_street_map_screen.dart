import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class OpenStreetMapScreen extends StatefulWidget {
  final Function (String address, double latitude, double longitude) onTap;
  const OpenStreetMapScreen({super.key, required this.onTap});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Địa chỉ'),
        ),
        body: OpenStreetMapSearchAndPick(
        center: const LatLong(10.8417020166042, 106.80991190198087),
        buttonColor: Colors.blue,
        buttonText: 'Chọn địa chỉ ở đây',
        locationPinText : '',
        hintText : 'Tìm kiếm địa chỉ',
        onPicked: (pickedData) {
          widget.onTap(pickedData.addressName, pickedData.latLong.latitude, pickedData.latLong.longitude);
          // print(pickedData.latLong.latitude);
          // print(pickedData.latLong.longitude);
          // print(pickedData.address);
          Navigator.of(context).pop();
        }),
      ),
    );
  }
}