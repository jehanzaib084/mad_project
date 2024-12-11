import 'package:get/get.dart';

class MasterNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void goToCreatePost() {
    selectedIndex.value = 2;
  }
}