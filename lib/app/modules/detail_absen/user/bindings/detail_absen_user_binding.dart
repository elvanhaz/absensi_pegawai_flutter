import 'package:get/get.dart';

import '../controllers/detail_absen_user_controller.dart';

class DetailAbsenUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAbsenUserController>(
      () => DetailAbsenUserController(),
    );
  }
}
