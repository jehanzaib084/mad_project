import 'package:flutter/material.dart';

class BasicInfoStep extends StatelessWidget {
  final TextEditingController propertyNameController;
  final TextEditingController propertyTypeController;
  final TextEditingController descriptionController;
  final Function() onNext;

  const BasicInfoStep({
    super.key,
    required this.propertyNameController,
    required this.propertyTypeController,
    required this.descriptionController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        TextFormField(
          controller: propertyNameController,
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
          controller: propertyTypeController,
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
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Description is required';
            return null;
          },
        ),
      ],
    );
  }
}