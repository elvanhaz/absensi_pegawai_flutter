import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:login/app/modules/dialogscreen.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class LoginController extends GetxController {
  final pageC = Get.find<PageIndexController>();
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await auth.signInWithCredential(credential);

      final User? user = authResult.user;
      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      switch (pageIndex) {
        default:
          pageIndex;
          Get.offAllNamed(Routes.HOME);
      } // navigate to your wanted page
      return;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              switch (pageIndex) {
                default:
                  pageIndex;

                  Get.offAllNamed(Routes.HOME);
              } // navigate
            }
          } else {
            Get.defaultDialog(
                title: "Belum Verification",
                middleText:
                    "Kamu belum melakukan verifikasi akun ini, Lakukan verifikasi diemail kamu.",
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        isLoading.value = false;
                        Get.back();
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await userCredential.user!.sendEmailVerification();
                          Get.back();
                          Get.snackbar(
                              "Berhasil", "Kami telah berhasil mengirim email");
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar("Terjadi Kesalahan",
                              "Tidak mnegirim email. Hubungi admin");
                        }
                      },
                      child: Text("KIRIM ULANG"))
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak ditemukan");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib diisi!");
    }
  }
}
