import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteDetailMapScreen extends StatefulWidget {
  final List<List<double>> listLocation;
  const RouteDetailMapScreen({
    super.key,
    required this.listLocation
    });

  @override
  State<RouteDetailMapScreen> createState() => _RouteDetailMapScreenState();
}

class _RouteDetailMapScreenState extends State<RouteDetailMapScreen> {

  List<Marker> _markers(){
    List<Marker> markers = List.empty(growable: true);
    for(var i = 0; i < widget.listLocation.length - 1; i++){
      Marker marker = Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(widget.listLocation[i][0], widget.listLocation[i][1]), 
        builder: (ctx) => Stack(
              clipBehavior: Clip.none,
          children: [
             const Positioned(
              top: -10,
               child:  Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30,),
             ),
            Positioned(
              left: 7,
              right: 7,
              top: -6,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text('${i+1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),)))),
          ],
        ),
      );
      markers.add(marker);
    }

    Marker marker = Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(widget.listLocation.last[0], widget.listLocation.last[1]), 
        builder: (ctx) => const Stack(
              clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      );
      markers.add(marker);

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.listLocation.last[0], widget.listLocation.last[1]),
          zoom: 13.0, 
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers(),
          ),
        ],
      ),
    );
  }
}