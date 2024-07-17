import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // Check the current location permission status
    permission = await Geolocator.checkPermission();

    // Request permission if it's denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // Handle the case where permission is still denied
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    // Handle the case where permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied. The app cannot function without them.");
      return; // We can't request permissions at this point
    }

    // If we have permission, fetch the current location
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            );
        _currentPosition = position;
        notifyListeners(); // Notify listeners that the location has changed
      } catch (e) {
        print("Failed to get the current location: $e");
      }
    }
  }

  bool isLocationAvailable() {
    return _currentPosition != null;
  }

  double calculateDistance(
      Position start, double targetLatitude, double targetLongitude) {
    // ignore: unnecessary_null_comparison
    if (start == null) {
      throw Exception("Current position is null");
    }

    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      targetLatitude,
      targetLongitude,
    );

    double distanceInKilometers =
        distanceInMeters / 1000; // Convert to kilometers
    return double.parse(distanceInKilometers.toStringAsFixed(2));
  }
}
