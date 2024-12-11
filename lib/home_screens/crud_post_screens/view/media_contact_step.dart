import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class MediaContactStep extends StatelessWidget {
  final CreatePostController controller = Get.find<CreatePostController>();
  final Function() onImagePick;
  final Function() onSubmit;
  final Function() onPrevious;

  MediaContactStep({
    super.key,
    required this.onImagePick,
    required this.onSubmit,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: onImagePick,
            icon: Icon(Icons.add_photo_alternate),
            label: Text('Add Images'),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.selectedImages.isEmpty) {
              return Center(child: Text('No images selected'));
            }
      
            return Column(
              children: [
                Text(
                    '${controller.selectedImages.length}/${CreatePostController.maxImages} images'),
                SizedBox(height: 8),
                CarouselSlider.builder(
                  itemCount: controller.selectedImages.length,
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(controller.base64Images[index]),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.broken_image, size: 50),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: InkWell(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              suffixText: 'per month',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Price is required';
              if (double.tryParse(value!) == null) return 'Enter valid price';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.locationController,
            decoration: InputDecoration(
              labelText: 'Location',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Location is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixText: '+92 ',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Phone number is required';
              if (value!.length < 10) return 'Enter complete phone number';
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Enter valid phone number';
              }
              return null;
            },
            onChanged: (value) {
              // Remove any non-digits and limit to 10 digits
              final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits != value) {
                controller.phoneController.text =
                    digits.substring(0, min(digits.length, 10));
                controller.phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.phoneController.text.length),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}