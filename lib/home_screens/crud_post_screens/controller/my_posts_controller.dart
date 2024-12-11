import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostDetailController extends GetxController {
  final pageController = PageController();
  final RxInt currentPage = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = false;
  }
  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}