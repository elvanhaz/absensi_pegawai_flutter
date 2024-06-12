import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingPegawai = false.obs;
  final selected = "some book type".obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime ntpTime = DateTime.now();

  var items = <String>['admin', 'redaksi', 'sdm', 'keuangan', 'pemasaran'].obs;
  var itemCurrent = 'admin'.obs;
  addItem(String item) => items.add(item);

  // It is mandatory initialize with one value from listType

  void setSelected(String value) {
    selected.value = value;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // It is mandatory initialize with one value from listType

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;
        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );
        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "job": jobC.text,
            "email": emailC.text,
            "uid": uid,
            "role": itemCurrent.value,
            "created_at": ntpTime.toIso8601String(),
          });
          await pegawaiCredential.user!.sendEmailVerification();
          await auth.signOut();
          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passAdminC.text);
          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
          isLoading.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan", "Terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "Pegawai sudah ada");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password Salah");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        isLoadingPegawai.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahlkan pegawai");
      }
    } else {
      isLoading.value = false;

      Get.snackbar("Terjadi Kesalahan", "Password wajib diisi");
    }
  }

  Future<void> addPegawai() async {
    ntpTime = await NTP.now();

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
    if (nameC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi admin",
        middleText: "",
        content: Column(
          children: [
            Text("Masukan password untuk validasi admin "),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            )
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text("CANCEL")),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingPegawai.isFalse) {
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child:
                  Text(isLoadingPegawai.isFalse ? "Add Pegawai" : "Loading..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "Form tidak boleh kosong");
    }
  }
}
