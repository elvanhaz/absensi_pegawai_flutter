import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:login/app/controllers/page_index_controller.dart';
import 'package:login/app/utils/app_color.dart';
import 'package:login/constants.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final pageC = Get.put(PageIndexController(), permanent: true);
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp)
      .then((_) => runApp(StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter demo',
                theme: ThemeData(
                  fontFamily: "Cairo",
                  scaffoldBackgroundColor: AppColor.primaryExtraSoft,
                  textTheme: Theme.of(context)
                      .textTheme
                      .apply(bodyColor: kPrimaryLightColor),
                ),
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            return GetMaterialApp(
              title: "Application",
              initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
              getPages: AppPages.routes,
            );
          })));
}
