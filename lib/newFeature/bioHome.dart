import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class locationDetector extends StatefulWidget {
  const locationDetector({super.key});

  @override
  State<locationDetector> createState() => _locationDetectorState();
}

class _locationDetectorState extends State<locationDetector> {
  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<String?> _getCityFromLocation() async {
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return place.locality; // This is the city name
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("location")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  final city = await _getCityFromLocation();
                  if (city == null) {
                    print("null");
                  } else {
                    print(city.toString());
                  }
                },
                child: const Text("check Location")),
          )
        ],
      ),
    );
  }
}
