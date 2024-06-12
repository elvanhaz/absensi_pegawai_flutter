import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';

String? filePath;

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
DateTime? start;
DateTime end = DateTime.now();

class AbsentController extends GetxController {
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    update();
    if (start == null) {
      return await firestore
          .collectionGroup('presence')
          .where("date", isLessThan: end.toIso8601String())
          .get();
    } else {
      return await firestore
          .collectionGroup('presence')
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date",
              isLessThan: end.add(const Duration(days: 1)).toIso8601String())
          .get();
      // return
    }
  }

  void pickDAte(DateTime pickStart, DateTime pickEnd) async {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
