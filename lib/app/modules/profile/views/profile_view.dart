import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login/app/controllers/page_index_controller.dart';

import 'package:get/get.dart';
import 'package:login/app/routes/app_pages.dart';

import '../../../utils/app_color.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.hasData) {
              Map<String, dynamic> user = snap.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}";
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                          child: Image.network(
                            user["profile"] != null
                                ? user["profile"] != ""
                                    ? user["profile"]
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${user['name'].toString().toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${user['job']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.secondarySoft),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MenuTile(
                    onTap: () =>
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                    title: 'Update Profile',
                    icon: SvgPicture.asset(
                      'assets/profile-1.svg',
                    ),
                  ),
                  MenuTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    title: 'Ganti Password',
                    icon: SvgPicture.asset(
                      'assets/password.svg',
                    ),
                  ),
                  if (user["role"] == "admin")
                    MenuTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      title: 'Tambah Pegawai',
                      icon: SvgPicture.asset(
                        'assets/people.svg',
                      ),
                    ),
                  if (user["role"] == "admin")
                    MenuTile(
                      onTap: () => Get.toNamed(Routes.ALL_USER),
                      title: 'Data User',
                      icon: SvgPicture.asset(
                        'assets/people.svg',
                      ),
                    ),
                  MenuTile(
                    onTap: () => Get.toNamed(Routes.ABSENT),
                    title: 'Data Absen',
                    icon: SvgPicture.asset(
                      'assets/data.svg',
                    ),
                  ),
                  MenuTile(
                    isDanger: true,
                    title: 'Keluar',
                    icon: SvgPicture.asset(
                      'assets/logout.svg',
                    ),
                    onTap: () => controller.logout(),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("Tidak dapat memuat data user"),
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
          initialActiveIndex: pageC.pageIndex.value, //optional, default as 0
          onTap: (int i) => pageC.changePage(i)),
    );
  }
}

class MenuTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;
  final bool isDanger;
  MenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColor.secondaryExtraSoft,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              margin: EdgeInsets.only(right: 24),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primaryExtraSoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      (isDanger == false) ? AppColor.secondary : AppColor.error,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 24),
              child: SvgPicture.asset(
                'assets/arrow-right.svg',
                color:
                    (isDanger == false) ? AppColor.secondary : AppColor.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
