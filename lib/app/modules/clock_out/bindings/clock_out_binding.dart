import 'package:get/get.dart';

import '../controllers/clock_out_controller.dart';

class ClockOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClockOutController>(
      () => ClockOutController(),
    );
  }
}
