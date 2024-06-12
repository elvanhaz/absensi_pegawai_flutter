// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:get/get.dart';
import 'package:login/app/utils/app_color.dart';
import 'package:ntp/ntp.dart';
import 'package:timer_builder/timer_builder.dart';
import '../../../routes/app_pages.dart';
import '../controllers/absensi_controller.dart';

class AbsensiView extends StatefulWidget {
  AbsensiView({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<AbsensiView> {
  AbsensiController controller = Get.put(AbsensiController());

  DateTime ntpTTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadNTPTime();
  }

  void _loadNTPTime() async {
    ntpTTime = await NTP.now();
  }

  String Date() {
    return DateFormat("EEEE, d MMMM yyyy", "id_ID").format(ntpTTime);
  }

  String getSystemTime() {
    DateTime ntpTime = new DateTime.now();

    return new DateFormat("HH:mm:ss").format(ntpTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.toNamed(Routes.HOME),
        ),
        title: Text(
          'Absensi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}";

              return ListView(children: [
                SizedBox(
                  height: 0,
                ),
                Container(
                  height: 900,
                  child: Stack(
                    children: [
                      Material(
                        elevation: 12,
                        color: AppColor.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Container(
                          height: 340,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  top: 0,
                                ),
                                child: Row(
                                  children: [],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0, right: 10),
                                child: TimerBuilder.periodic(
                                    Duration(seconds: 1), builder: (context) {
                                  return Text(
                                    "${getSystemTime()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  );
                                }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: TimerBuilder.periodic(
                                    Duration(seconds: 1), builder: (context) {
                                  return Text(
                                    "${Date()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 80, right: 20, left: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 1,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 140,
                                      top: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          user["name"] != null
                                              ? "${user['name']}"
                                              : "Belum ada nama",
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          user["job"] != null
                                              ? "${user['job']}"
                                              : "Belum ada jabatan",
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "09.00 - 15.00",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColor.primaryExtraSoft,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .contact_support_outlined),
                                                  Text(
                                                    'Foto selfie diperlukan untuk clock in/clock out',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 40, right: 40),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlatButton(
                                                height: 40,
                                                onPressed: () => Get.toNamed(
                                                  Routes.CLOCK_IN,
                                                  arguments: user,
                                                ),
                                                child: Text(
                                                  "Clock-In",
                                                ),
                                                textColor: Colors.white,
                                                color: Colors.redAccent,
                                              ),
                                              FlatButton(
                                                height: 40,
                                                onPressed: () => Get.toNamed(
                                                    Routes.CLOCK_OUT),
                                                child: Text("Clock-Out"),
                                                textColor: Colors.white,
                                                color: Colors.redAccent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 350),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Terakhir dilihat",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            TextButton(
                                onPressed: () =>
                                    Get.toNamed(Routes.ALL_PRESENSI),
                                child: Text("Lihat selengkapnya")),
                          ],
                        ),
                      ),
                      GetBuilder<AbsensiController>(
                        builder: (c) => FutureBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            future: controller.streamLastPresence(),
                            builder: (context, snapshotPresence) {
                              if (snapshotPresence.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshotPresence.data?.docs.length == 0 ||
                                  snapshotPresence.data == null) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                  ),
                                  margin: EdgeInsets.only(top: 500),
                                  height: 100,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Tidak ada log aktivitas apapun hari ini",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                margin: EdgeInsets.only(top: 410),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshotPresence.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data = snapshotPresence
                                        .data!.docs[index]
                                        .data();
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Material(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () => Get.toNamed(
                                            Routes.DETAIL_PRESENSI,
                                            arguments: data,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Material(
                                            elevation: 8,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Masuk",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date']))}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(data['masuk']?['date'] ==
                                                          null
                                                      ? "-"
                                                      : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Keluar",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(data['keluar']
                                                              ?['date'] ==
                                                          null
                                                      ? "-"
                                                      : "${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Lembur",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(data['keluar']
                                                              ?['lembur'] ==
                                                          null
                                                      ? "-"
                                                      : "${(data['keluar']!['lembur'])} AM"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ]);
            } else {
              return Center(
                child: Text("Tidak dapat memuat database user"),
              );
            }
          }),
    );
  }
}
