import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class BasicInfoStep extends StatelessWidget {
  final CreatePostController controller = Get.find<CreatePostController>();
  final Function() onNext;

  BasicInfoStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        TextFormField(
          controller: controller.propertyNameController,
          decoration: InputDecoration(
            labelText: 'Property Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Property name is required';
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: controller.propertyTypeController,
          decoration: InputDecoration(
            labelText: 'Property Type',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Property type is required';
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: controller.descriptionController,
          maxLines: null, // Allow the field to expand
          minLines: 1, // Start with one line
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Description is required';
            if (value!.split(' ').length > 100) {
              return 'Description cannot exceed 100 words';
            }
            return null;
          },
          onChanged: (value) {
            if (value.split(' ').length > 100) {
              controller.descriptionController.text =
                  value.split(' ').take(100).join(' ');
              controller.descriptionController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                    offset: controller.descriptionController.text.length),
              );
            }
          },
        ),
      ],
    );
  }
}
