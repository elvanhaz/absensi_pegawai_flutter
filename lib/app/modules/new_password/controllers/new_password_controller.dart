import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  RxBool newPassObs = true.obs;
  RxBool newPassCObs = true.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);
          isLoading.value = true;
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi kesalahan", "Password terlalu lemah");
            isLoading.value = false;
          }
        } catch (e) {
          Get.snackbar(
              "Terjadi kesalahan", "Tidak dapat membuat password baru");
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "Password harus diubah");
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Password baru wajib diisi");
      isLoading.value = false;
    }
  }
}
