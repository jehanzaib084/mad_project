import 'package:get/get.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class CreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePostController(), fenix: true);
  }
}