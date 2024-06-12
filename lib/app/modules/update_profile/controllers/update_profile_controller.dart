import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async {
    isLoading.value = true;
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
        };

        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split("").last;

          await storage.ref('$uid/profile.$ext').putFile(file);

          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({"profile": urlImage});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar("Berhasil", "Berhasil diupdate");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("pegawai").doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Berhasil", "Berhasil diupdate");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat menghapus profile");
    } finally {
      update();
    }
  }
}
