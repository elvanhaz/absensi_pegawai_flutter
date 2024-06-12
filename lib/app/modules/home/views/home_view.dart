import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:login/app/controllers/page_index_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_color.dart';
import '../controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
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

              return ListView(
                children: [
                  SizedBox(
                    height: 0,
                  ),
                  Material(
                    elevation: 14,
                    color: AppColor.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 60, top: 0),
                        child: Row(
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                width: 75,
                                height: 75,
                                color: Colors.grey[200],

                                child: Image.network(
                                  user['profile'] != null
                                      ? user['profile']
                                      : defaultImage,
                                  fit: BoxFit.cover,
                                ),
                                // child: ImageCache,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Aplikasi Absensi Online",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        user["name"] != null
                                            ? "${user['name']}"
                                            : "Belum ada nama",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        user["job"] != null
                                            ? "${user['job']}"
                                            : "Belum ada pekerjaan",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  SizedBox(height: 20),
                  Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple[200],
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.primary,
                      ),
                      child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller.streamTodayPresence(),
                          builder: (context, snapToday) {
                            if (snapToday.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            Map<String, dynamic>? dataToday =
                                snapToday.data?.data();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Masuk",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                        dataToday?['keluar'] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday?['masuk']['date']))}",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: [
                                    Text("Keluar",
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                        dataToday?['keluar'] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday?['keluar']['date']))}",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 12,
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 84,
                              decoration: BoxDecoration(
                                color: AppColor.primaryExtraSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'Jarak dari kantor',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      '${controller.officeDistance.value}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.launchOfficeOnMap,
                            child: Material(
                              elevation: 12,
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 84,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryExtraSoft,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/icon.png'),
                                    fit: BoxFit.cover,
                                    opacity: 0.3,
                                  ),
                                ),
                                child: Text(
                                  'Buka Map',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 35 / 300,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 32),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      image: DecorationImage(
                        image: AssetImage('assets/21.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[100],
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Absen Hari Ini",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                            onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                            child: Text("Lihat selengkapnya")),
                      ],
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamTodayPresence(),
                      builder: (context, snapToday) {
                        if (snapToday.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<String, dynamic>? dataToday =
                            snapToday.data?.data();

                        return Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              Map<String, dynamic>? data =
                                  snapToday.data?.data();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  elevation: 18,
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                      Routes.DETAIL_PRESENSI,
                                      arguments: data,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                data?['date'] == null
                                                    ? "-"
                                                    : "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data?['date']))}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(data?['masuk']?['date'] == null
                                              ? "-"
                                              : "${DateFormat.jms().format(DateTime.parse(data?['masuk']!['date']))}"),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Keluar",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(data?['keluar']?['date'] == null
                                              ? "-"
                                              : "${DateFormat.jms().format(DateTime.parse(data?['keluar']!['date']))}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      })
                ],
              );
            } else {
              return Center(
                child: Text("Tidak dapat memuat database user"),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.reactCircle,
          backgroundColor: AppColor.primary,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Absen'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          //optional, default as 0
          onTap: (int i) => pageC.changePage(i)),
    );
  }
}
