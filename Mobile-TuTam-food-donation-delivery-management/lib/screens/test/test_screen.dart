import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final String destination =
      "1600 Amphitheatre Parkway, Mountain View, CA"; // Địa chỉ đích
  final String origin = "1 Infinite Loop, Cupertino, CA"; // Địa chỉ xuất phát
  String locationMessage = 'Current Location of the User';
  late String lat;
  late String long;

  void openGoogleMaps() async {
    // final String encodedOrigin = Uri.encodeComponent(origin);
    // final String encodedDestination = Uri.encodeComponent(destination);

    // final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$encodedOrigin&destination=$encodedDestination";

    const String googleMapsUrl = "https://www.google.com/maps";
    await canLaunchUrlString(googleMapsUrl)
        ? await launchUrlString(googleMapsUrl)
        : throw 'Coul';
    // if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    //   await launchUrl(Uri.parse(googleMapsUrl));
    // } else {
    //   throw 'Could not open Google Maps';
    // }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanetly denied, we cannot request');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });

    setState(() {
      locationMessage = 'Latitude: $lat, Longitude: $long';
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

        String url = 'https://www.google.com/maps/dir/10.8089942,106.7919344/10.8048373,106.792122/10.8020195,106.7920838';
    await canLaunchUrlString(url)
      ? await launchUrlString(url)
      : throw 'Could not launch $googleURL';
    // final encodedLatitude = Uri.encodeComponent(lat.toString());
    // final encodedLongitude = Uri.encodeComponent(long.toString());
    // final url =
    //     'https://www.google.com/maps/search/?api=1&query=$encodedLatitude,$encodedLongitude';
    // final String url = 'https://www.youtube.com';
    // await canLaunchUrlString(url) ? print('open yes') : print('can not');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: openGoogleMaps,
                child: Text('Chỉ đường đến $destination từ $origin'),
              ),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationMessage = 'Latitude: $lat, Longitude: $long';
                    });
                    _liveLocation();
                  });
                },
                child: Text(locationMessage),
              ),
              ElevatedButton(
                onPressed: () {
                  _openMap(lat, long);
                },
                child: const Text('Redirect GG Map'),
              ),
              ElevatedButton(
                onPressed: () {
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>
                //       RouteDetailMapScreen(),
                //   ),
                // );
                },
                child: const Text('Open GG Map'),
              ),
              ElevatedButton(
                onPressed: () {
                },
                child: const Text('Open OSM plugin'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
