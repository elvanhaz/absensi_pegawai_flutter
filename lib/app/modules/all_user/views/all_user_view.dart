import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:login/app/modules/all_presensi/controllers/all_presensi_controller.dart';

import '../controllers/all_user_controller.dart';

class AllUserView extends GetView<AllUserController> {
  const AllUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141A31),
      appBar: AppBar(
        title: Text('Data Absen dan User'),
        centerTitle: true,
        backgroundColor: Color(0xff141A31),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snap) {
            return Container(
              padding: EdgeInsets.only(top: 15),
              child: ListView.builder(
                  itemCount: controller.pegawai.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snap.data!.docs[index].data();
                    String defaultImage =
                        "https://ui-avatars.com/api/?name=${data['name']}";

                    return Card(
                        color: Color(0xff081029),
                        child: InkWell(
                            onTap: () => Get.toNamed(
                                  Routes.DETAIL_ABSEN_USER,
                                  arguments: data,
                                ),
                            child: ListTile(
                              title: Text(
                                "${data['name']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              subtitle: Text(
                                "${data['email']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              leading: ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: Image.network(
                                    data["profile"] != null
                                        ? data["profile"] != ""
                                            ? data["profile"]
                                            : defaultImage
                                        : defaultImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.greenAccent,
                                  size: 30,
                                ),
                                onPressed: () => Get.toNamed(
                                  Routes.DETAIL_ABSEN_USER,
                                  arguments: data,
                                ),
                              ),
                            )));
                  }),
            );
          }),
    );
  }
}
