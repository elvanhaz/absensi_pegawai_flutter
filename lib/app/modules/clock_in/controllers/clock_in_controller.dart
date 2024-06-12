import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:login/app/utils/custom.dart';
import 'package:ntp/ntp.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

import '../../../routes/app_pages.dart';

class ClockInController extends GetxController {
  RxBool isLoading = false.obs;
  RxString officeDistance = "-".obs;
  RxInt pageIndex = 0.obs;
  TextEditingController catatan = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  DateTime ntpTime = DateTime.now();
  Timer? timer;
  XFile? image;
  String? urlImage;

  void pickImage(ImageSource source) async {
    image = await ImagePicker().pickImage(source: source, imageQuality: 10);

    update();
  }

  Future<void> changePage() async {
    isLoading.value = true;
    Map<String, dynamic> dataResponese = await determinePosition();
    if (dataResponese["error"] != true) {
      Position position = dataResponese["position"];
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality} ";

      await updatePosition(position, address);
      double distance = Geolocator.distanceBetween(
          -6.556998, 106.773174, position.latitude, position.longitude);

      await presensi(position, address, distance);

      imageCache.clear();
      update();

      // Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir");
    } else {
      Get.snackbar("Terjadi Kesalahan", dataResponese["message"]);
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

  Future<void> presensi(
      Position position, String address, double distance) async {
    final Map<String, dynamic> user = Get.arguments;
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    ntpTime = await NTP.now();
    String todayDocID = DateFormat.yMd().format(ntpTime).replaceAll("/", "-");
    String status = " Diluar Area";
    if (distance <= 200) {
      status = " Didalam Area";
    }
    if (catatan.text.isNotEmpty) {
      if (image != null) {
        if (snapPresence.docs.length == 0) {
          await CustomAlertDialog.showPresenceAlert(
            title: "Validasi Absen",
            message: "Kamu perlu konfirmasi sebelum absen",
            onCancel: () => Get.back(),
            onConfirm: () async {
              File file = File(image!.path);
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('$uid')
                  .child(ntpTime.toIso8601String() + '.jpg(CLOCK-IN)');
              await ref.putFile(file);
              urlImage = await ref.getDownloadURL();
              urlImage = await ref.getDownloadURL();
              await colPresence.doc(todayDocID).set({
                "date": ntpTime.toIso8601String(),
                "masuk": {
                  "nama": "${user['name']}",
                  "date": ntpTime.toIso8601String(),
                  "lat": position.latitude,
                  "long": position.longitude,
                  "address": address,
                  "status": status,
                  "distance": distance,
                  'imageUrl': urlImage,
                  "catatan": catatan.text,
                }
              });
              isLoading.value = true;

              update();
              image = null;

              Get.offAllNamed(Routes.HOME);

              Get.snackbar("Berhasil", "Kamu telah melakukan clock-in");
            },
          );
          //sudah pernah absen
        } else {
          DocumentSnapshot<Map<String, dynamic>> todayDoc =
              await colPresence.doc(todayDocID).get();

          if (todayDoc.exists == true) {
            Map<String, dynamic>? dataPresenceToday = todayDoc.data();
            if (dataPresenceToday?['masuk'] != null) {
              isLoading.value = false;
              update();
              image = null;
              Get.offAllNamed(Routes.HOME);
              Get.snackbar("Peringatan", "Kamu sudah melakukan absen");
            }
          } else {
            await CustomAlertDialog.showPresenceAlert(
              title: "Validasi Absen",
              message: "Kamu perlu konfirmasi sebelum absen",
              onCancel: () => Get.back(),
              onConfirm: () async {
                File file = File(image!.path);
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('$uid')
                    .child(ntpTime.toIso8601String() + '.jpg(CLOCK-IN)');
                await ref.putFile(file);
                urlImage = await ref.getDownloadURL();
                await colPresence.doc(todayDocID).set({
                  "date": ntpTime.toIso8601String(),
                  "masuk": {
                    "nama": "${user['name']}",
                    "date": ntpTime.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                    'imageUrl': urlImage,
                    "catatan": catatan.text,
                  }
                });
                isLoading.value = true;
                update();
                image = null;
                Get.offAllNamed(Routes.HOME);

                Get.snackbar("Berhasil", "Kamu telah melakukan clock-in");
              },
            );
          }
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Peringatan", "Gambar harus diisi");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Peringatan", "Catatan harus diisi");
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "Tidak dapat mengambil lokasi",
        "error": true,
      };

      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izinkan lokasi anda",
          "error": true,
        };

        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Settingan lokasi ditolak",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "position": position,
      "message": "Berhasil mendapatkan lokasi",
      "error": false,
    };
  }
}
