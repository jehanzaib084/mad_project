import 'package:get/get.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class MasterNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final AuthController _authController = Get.find<AuthController>();

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _authController.dispose();
  }
}