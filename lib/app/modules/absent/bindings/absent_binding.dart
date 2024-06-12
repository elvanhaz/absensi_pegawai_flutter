import 'package:get/get.dart';

import '../controllers/absent_controller.dart';

class AbsentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsentController>(
      () => AbsentController(),
    );
  }
}
