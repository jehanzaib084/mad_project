import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/additional_features_step.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/basic_info_step.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/facilities_step.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/media_contact_step.dart';

class CreatePostScreen extends StatelessWidget {
  final controller = Get.put(CreatePostController());

  CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Post'),
      ),
      body: Stack(
        children: [
          Obx(() => Stepper(
            currentStep: controller.currentStep.value,
            onStepCancel: controller.previousStep,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => controller.showCancelConfirmation(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                    Row(
                      children: [
                        if (controller.currentStep.value > 0)
                          OutlinedButton.icon(
                            onPressed: controller.previousStep,
                            icon: Icon(Icons.arrow_upward, size: 16),
                            label: Text('Previous'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              textStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        SizedBox(width: 8),
                        if (controller.currentStep.value < 3)
                          OutlinedButton.icon(
                            onPressed: () => controller.validateAndProceed(controller.currentStep.value),
                            icon: Icon(Icons.arrow_downward, size: 16),
                            label: Text('Next'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              textStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        if (controller.currentStep.value == 3)
                          OutlinedButton.icon(
                            onPressed: controller.submitForm,
                            icon: Icon(Icons.check, size: 16),
                            label: Text('Submit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              textStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text('Basic Information'),
                content: BasicInfoStep(
                  propertyNameController: controller.propertyNameController,
                  propertyTypeController: controller.propertyTypeController,
                  descriptionController: controller.descriptionController,
                  onNext: () => controller.validateAndProceed(0),
                ),
                isActive: controller.currentStep.value >= 0,
              ),
              Step(
                title: Text('Facilities'),
                content: FacilitiesStep(
                  facilities: controller.facilities,
                  onNext: () => controller.validateAndProceed(1),
                  onPrevious: controller.previousStep,
                ),
                isActive: controller.currentStep.value >= 1,
              ),
              Step(
                title: Text('Additional Features'),
                content: AdditionalFeaturesStep(
                  features: controller.features,
                  onNext: () => controller.validateAndProceed(2),
                  onPrevious: controller.previousStep,
                ),
                isActive: controller.currentStep.value >= 2,
              ),
              Step(
                title: Text('Media & Contact'),
                content: MediaContactStep(
                  priceController: controller.priceController,
                  locationController: controller.locationController,
                  phoneController: controller.phoneController,
                  images: controller.images,
                  onImagePick: controller.pickImages,
                  onSubmit: controller.submitForm,
                  onPrevious: controller.previousStep,
                ),
                isActive: controller.currentStep.value >= 3,
              ),
            ],
          )),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}