import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class FacilitiesStep extends StatelessWidget {
  final CreatePostController controller = Get.find<CreatePostController>();
  final Function() onNext;
  final Function() onPrevious;

  FacilitiesStep({
    super.key,
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
          value: controller.facilities['garage']?.value ?? false,
          onChanged: (bool value) {
            controller.facilities['garage']?.value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Light'),
          value: controller.facilities['light']?.value ?? false,
          onChanged: (bool value) {
            controller.facilities['light']?.value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Water'),
          value: controller.facilities['water']?.value ?? false,
          onChanged: (bool value) {
            controller.facilities['water']?.value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Kitchen'),
          value: controller.facilities['kitchen']?.value ?? false,
          onChanged: (bool value) {
            controller.facilities['kitchen']?.value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Gyser'),
          value: controller.facilities['gyser']?.value ?? false,
          onChanged: (bool value) {
            controller.facilities['gyser']?.value = value;
          },
        )),
      ],
    );
  }
}