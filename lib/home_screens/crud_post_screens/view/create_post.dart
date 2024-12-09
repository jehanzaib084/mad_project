// create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class CreatePostScreen extends StatelessWidget {
  final CreatePostController controller = Get.put(CreatePostController());

  CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        title: Text('Create Listing', style: TextStyle(color: Colors.black87)),
        
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 44),
        child: Column(
          children: [
            // Progress Steps
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: List.generate(4, (index) => _buildStep(index)),
              ),
            ),
            
            // Step Content
            Expanded(
              child: Obx(() {
                switch (controller.currentPage.value) {
                  case 0:
                    return _BasicInfoStep();
                  case 1:
                    return _FacilitiesStep();
                  case 2:
                    return _LocationStep();
                  case 3:
                    return _ImagesStep();
                  default:
                    return _BasicInfoStep();
                }
              }),
            ),
            
            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => controller.currentPage.value > 0
                      ? ElevatedButton(
                          onPressed: controller.previousPage,
                          child: Text('Previous', style: TextStyle(color: Colors.white),),
                        )
                      : SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.currentPage.value == 3) {
                        final success = await controller.createPost();
                        if (success) {
                          Get.back();
                          Get.snackbar('Success', 'Post created successfully!');
                        } else {
                          Get.snackbar('Error', 'Failed to create post');
                        }
                      } else {
                        controller.nextPage();
                      }
                    },
                    child: Obx(() => Text(
                        controller.currentPage.value == 3 ? 'Submit' : 'Next', style: TextStyle(color: Colors.white),),
                        ),
                  ),
                  
                ],
                
              ),
              
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int index) {
    return Obx(() => Expanded(
      child: Container(
        height: 4,
        margin: EdgeInsets.symmetric(horizontal: 4),
        color: controller.currentPage.value >= index 
            ? Colors.blue 
            : Colors.grey[300],
      ),
    ));
  }
}

class _BasicInfoStep extends StatelessWidget {
  final controller = Get.find<CreatePostController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Property Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.house),
              ),
              onChanged: (value) => controller.propertyName.value = value,
              validator: (value) => 
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Property Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: ['Hostel', 'Apartment', 'Room']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) => controller.propertyType.value = value ?? '',
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Monthly Rent',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.price.value = value,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender Preference',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              items: ['boys', 'girls']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.capitalize ?? type),
                      ))
                  .toList(),
              onChanged: (value) => controller.gender.value = value ?? 'boys',
              value: controller.gender.value,
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilitiesStep extends StatelessWidget {
  final controller = Get.find<CreatePostController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Facilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Obx(() => SwitchListTile(
              title: Text('WiFi Available'),
              subtitle: Text('High-speed internet connection'),
              value: controller.hasWifi.value,
              onChanged: (value) => controller.hasWifi.value = value,
            )),
            Divider(),
            Obx(() => SwitchListTile(
              title: Text('Meals Included'),
              subtitle: Text('Food service available'),
              value: controller.mealsIncluded.value,
              onChanged: (value) => controller.mealsIncluded.value = value,
            )),
            Divider(),
            ListTile(
              title: Text('Students per Room'),
              trailing: Obx(() => DropdownButton<int>(
                value: controller.studentsPerRoom.value,
                items: [1, 2, 3, 4]
                    .map((num) => DropdownMenuItem(
                          value: num,
                          child: Text('$num Person${num > 1 ? 's' : ''}'),
                        ))
                    .toList(),
                onChanged: (value) => 
                    controller.studentsPerRoom.value = value ?? 1,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationStep extends StatelessWidget {
  final controller = Get.find<CreatePostController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Complete Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 3,
              onChanged: (value) => controller.location.value = value,
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Map integration coming soon'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagesStep extends StatelessWidget {
  final controller = Get.find<CreatePostController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: controller.pickAndConvertImage,
                icon: Icon(Icons.add_photo_alternate, color: Colors.white,),
                label: Text('Add Images', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.images.isEmpty
                  ? Center(
                      child: Text(
                        'No images added yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.memory(
                              base64Decode(
                                  controller.images[index].split(',')[1]),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => 
                                    controller.images.removeAt(index),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}