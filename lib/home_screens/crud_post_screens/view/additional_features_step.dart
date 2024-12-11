import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class AdditionalFeaturesStep extends StatelessWidget {
  final CreatePostController controller = Get.find<CreatePostController>();
  final Function() onNext;
  final Function() onPrevious;

  AdditionalFeaturesStep({
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
          title: Text('WiFi Available'),
          value: controller.features['hasWifi']?.value ?? false,
          onChanged: (bool value) {
            controller.features['hasWifi']?.value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Meals Included'),
          value: controller.features['mealsIncluded']?.value ?? false,
          onChanged: (bool value) {
            controller.features['mealsIncluded']?.value = value;
          },
        )),
        TextFormField(
          controller: TextEditingController(text: controller.features['studentsPerRoom']?.value.toString() ?? '1'),
          decoration: InputDecoration(
            labelText: 'Students Per Room',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.features['studentsPerRoom']?.value = int.tryParse(value) ?? 1;
          },
          validator: (value) {
            if (int.tryParse(value ?? '') == null || int.parse(value!) < 1) {
              return 'Enter a valid number of students per room';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: controller.features['gender']?.value ?? 'boys',
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          items: ['boys', 'girls'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            controller.features['gender']?.value = newValue!;
          },
        ),
      ],
    );
  }
}