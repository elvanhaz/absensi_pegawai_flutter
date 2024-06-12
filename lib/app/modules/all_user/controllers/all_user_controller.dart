import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/app/modules/modelpegawai.dart';

class AllUserController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();
  late CollectionReference collectionReference;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<EmployeeModel> pegawai = RxList<EmployeeModel>([]);
  RxList<EmployeeModel> presence = RxList<EmployeeModel>([]);

  @override
  void onInit() {
    super.onInit();

    collectionReference = firestore.collection("pegawai");

    pegawai.bindStream(getAllEmployees());

    collectionReference =
        firestore.collection("pegawai").doc("admin").collection("presence");

    presence.bindStream(getAllEmployees());
  }

  Stream<List<EmployeeModel>> getAllEmployees() =>
      collectionReference.snapshots().map((query) =>
          query.docs.map((item) => EmployeeModel.fromMap(item)).toList());

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUser() async* {
    yield* firestore.collection('pegawai').snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    if (start == null) {
      return await firestore
          .collection("pegawai")
          .doc("uid")
          .collection('presence')
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("pegawai")
          .doc("uid")
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
}
