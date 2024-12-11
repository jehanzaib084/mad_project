import 'dart:convert';
import 'dart:math';

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MediaContactStep extends StatelessWidget {
  final CreatePostController controller = Get.find<CreatePostController>();
  final pageController = PageController();
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
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: controller.selectedImages.length,
                        onPageChanged: (index) {
                          controller.currentImageIndex.value = index;
                        },
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              // Image Container
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      base64Decode(
                                          controller.base64Images[index]),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.broken_image,
                                            size: 50);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // Close Button
                              Positioned(
                                top: 12,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.removeImage(index);
                                    if (controller.selectedImages.isEmpty)
                                      return;
                                    if (index ==
                                        controller.selectedImages.length) {
                                      pageController.jumpToPage(index - 1);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // Page indicator
                      Positioned(
                        bottom: 8,
                        child: Obx(() => SmoothPageIndicator(
                              controller: pageController,
                              count: controller.selectedImages.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Theme.of(context).primaryColor,
                                dotColor: Colors.grey.shade400,
                              ),
                            )),
                      ),
                    ],
                  ),
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
                controller.phoneController.selection =
                    TextSelection.fromPosition(
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
