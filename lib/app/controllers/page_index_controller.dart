import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:login/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ntp/ntp.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime ntpTime = DateTime.now();

  void changePage(int index) async {
    pageIndex.value = index;
    switch (index) {
      case 1:
        Get.offAllNamed(Routes.ABSENSI);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
        break;
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
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

    if (snapPresence.docs.length == 0) {
      await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText: "Lakukan clock in sekarang ?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set({
                    "date": ntpTime.toIso8601String(),
                    "masuk": {
                      "date": ntpTime.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "Kamu telah melakukan clock-in");
                },
                child: Text("YES")),
          ]);
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();
      if (todayDoc.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?['keluar'] != null) {
          Get.snackbar("Peringatan", "Kamu telah absen masuk & keluar");
        } else {
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText: "Lakukan clock out sekarang ?",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await colPresence.doc(todayDocID).update({
                        "keluar": {
                          "date": ntpTime.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        }
                      });
                      Get.back();
                      Get.snackbar(
                          "Berhasil", "Kamu telah melakukan clock-out");
                    },
                    child: Text("YES")),
              ]);
        }
      } else {
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText: "Lakukan clock-out sekarang",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: Text("CANCEL"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).set({
                      "date": ntpTime.toIso8601String(),
                      "masuk": {
                        "date": ntpTime.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "Kamu telah melakukan clock-in");
                  },
                  child: Text("YES")),
            ]);
      }
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
