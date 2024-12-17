import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/map_controller.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';

class MapView extends StatelessWidget {
  final MapController1 mapController = Get.put(MapController1());
  final PostController postController = Get.find();

  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              postController.currentCity.value = mapController.currentCityName.value;
              Get.back(result: true);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (!mapController.isLocationFetched.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  mapController.currentLocation.value.latitude,
                  mapController.currentLocation.value.longitude,
                ),
                zoom: mapController.zoom.value,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: (CameraPosition position) {
                mapController.updateLocation(
                  position.target.latitude,
                  position.target.longitude,
                );
              },
              onCameraIdle: () {
                mapController.updateCityNameDebounced();
              },
            ),
            // Centered marker
            Center(
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 36,
              ),
            ),
            // Location text display
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Obx(() => Text(
                  mapController.currentCityName.value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ],
        );
      }),
    );
  }
}