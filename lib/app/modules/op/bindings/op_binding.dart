import 'package:get/get.dart';

import '../controllers/op_controller.dart';

class OpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpController>(
      () => OpController(),
    );
  }
}
