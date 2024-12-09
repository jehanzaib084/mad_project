import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FacilitiesStep extends StatelessWidget {
  final RxMap facilities;
  final Function() onNext;
  final Function() onPrevious;

  const FacilitiesStep({
    super.key,
    required this.facilities,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(() => SwitchListTile(
          title: Text('Garage'),
          value: facilities['garage'].value,
          onChanged: (bool value) {
            facilities['garage'].value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Light'),
          value: facilities['light'].value,
          onChanged: (bool value) {
            facilities['light'].value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Water'),
          value: facilities['water'].value,
          onChanged: (bool value) {
            facilities['water'].value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Kitchen'),
          value: facilities['kitchen'].value,
          onChanged: (bool value) {
            facilities['kitchen'].value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Gyser'),
          value: facilities['gyser'].value,
          onChanged: (bool value) {
            facilities['gyser'].value = value;
          },
        )),
      ],
    );
  }
}