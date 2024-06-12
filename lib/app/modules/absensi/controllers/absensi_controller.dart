import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../routes/app_pages.dart';

class AbsensiController extends GetxController {
  RxBool isLoading = false.obs;
  RxString officeDistance = "-".obs;
  DateTime? start;
  DateTime end = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime ntpTime = DateTime.now();
  Timer? timer;
  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (Get.currentRoute == Routes.HOME) {
        getDistanceToOffice().then((value) {
          officeDistance.value = value;
        });
      }
    });
  }

  launchOfficeOnMap() {
    try {
      MapsLauncher.launchCoordinates(
        -6.556998,
        106.773174,
      );
    } catch (e) {
      Get.snackbar("Error", "Error : $e");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async {
    String uid = auth.currentUser!.uid;

    if (start == null) {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection('presence')
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .limit(3)
          .get();
    } else {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection('presence')
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date",
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .limit(3)
          .get();
      // return
    }
  }

  Future<String> getDistanceToOffice() async {
    Map<String, dynamic> determinePosition = await _determinePosition();
    if (!determinePosition["error"]) {
      Position position = determinePosition["position"];
      double distance = Geolocator.distanceBetween(
          -6.556998, 106.773174, position.latitude, position.longitude);
      if (distance > 1000) {
        return "${(distance / 1000).toStringAsFixed(2)}km";
      } else {
        return "${distance.toStringAsFixed(2)}m";
      }
    } else {
      return "-";
    }
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.rawSnackbar(
        title: 'GPS is off',
        message: 'you need to turn on gps',
        duration: Duration(seconds: 3),
      );
      return Future.error('Location services are disabled.');
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
        // return Future.error('Location permissions are denied');
        return {
          "message":
              "Tidak dapat mengakses karena anda menolak permintaan lokasi",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Location permissions are permanently denied, we cannot request permissions.",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser!.uid;
    ntpTime = await NTP.now();

    String todayID = DateFormat.yMd().format(ntpTime).replaceAll("/", "-");
    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection('presence')
        .doc(todayID)
        .snapshots();
  }

  void pickDAte(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
