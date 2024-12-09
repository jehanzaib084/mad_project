import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdditionalFeaturesStep extends StatelessWidget {
  final RxMap features;
  final Function() onNext;
  final Function() onPrevious;

  const AdditionalFeaturesStep({
    super.key,
    required this.features,
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
          value: features['hasWifi'].value,
          onChanged: (bool value) {
            features['hasWifi'].value = value;
          },
        )),
        Obx(() => SwitchListTile(
          title: Text('Meals Included'),
          value: features['mealsIncluded'].value,
          onChanged: (bool value) {
            features['mealsIncluded'].value = value;
          },
        )),
        TextFormField(
          controller: TextEditingController(text: features['studentsPerRoom'].value.toString()),
          decoration: InputDecoration(
            labelText: 'Students Per Room',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            features['studentsPerRoom'].value = int.tryParse(value) ?? 1;
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
          value: features['gender'].value,
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
            features['gender'].value = newValue!;
          },
        ),
      ],
    );
  }
}