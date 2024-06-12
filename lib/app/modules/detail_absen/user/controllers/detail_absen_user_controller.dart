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
var itemList = [
  <String>["date", "Masuk", "Keluar"]
];

class DetailAbsenUserController extends GetxController {
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    final Map<String, dynamic> data = Get.arguments;

    if (start == null) {
      return await firestore
          .collection("pegawai")
          .doc("${data['uid']}")
          .collection('presence')
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("pegawai")
          .doc("${data['uid']}")
          .collection('presence')
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date",
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
      // return
    }
  }

  void pickDAte(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

  getCsv() async {
    final Map<String, dynamic> data = Get.arguments;

    itemList.add(<String>[
      "${data['uid']}",
      "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date'])).toString()}",
      "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date'])).toString()}",
    ]);
    print('data: ');
    print(itemList.toString());
    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(itemList);
    f.writeAsString(csv);
  }
}
