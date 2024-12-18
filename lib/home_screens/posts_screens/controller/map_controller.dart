import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mad_project/utils/logging.dart';

class MapController1 extends GetxController {
  final Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  final Rx<LatLng> deviceLocation = LatLng(0, 0).obs;
  final RxString currentCityName = 'Loading...'.obs;
  final RxDouble zoom = 15.0.obs;
  final RxBool isLocationFetched = false.obs;
  
  Timer? _debounceTimer;
  final Map<String, String> _cityCache = {};

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      final location = LatLng(position.latitude, position.longitude);
      currentLocation.value = location;
      deviceLocation.value = location;
      
      updateCityName(position.latitude, position.longitude);
      isLocationFetched.value = true;
    } catch (e) {
      logger.i('Could not get current location: $e');
    }
  }

  void updateLocation(double latitude, double longitude) {
    currentLocation.value = LatLng(latitude, longitude);
  }

  void updateCityNameDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      updateCityName(
        currentLocation.value.latitude,
        currentLocation.value.longitude,
      );
    });
  }

  void updateCityName(double latitude, double longitude) async {
    // Check cache first
    String locationKey = '${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}';
    if (_cityCache.containsKey(locationKey)) {
      currentCityName.value = _cityCache[locationKey]!;
      return;
    }

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        String cityName = placemarks.first.locality ?? 'Unknown Location';
        currentCityName.value = cityName;
        // Cache the result
        _cityCache[locationKey] = cityName;
      }
    } catch (e) {
      currentCityName.value = 'Location Error';
    }
  }
}