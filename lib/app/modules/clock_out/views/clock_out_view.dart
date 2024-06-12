// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../utils/app_color.dart';
import '../controllers/clock_in_controller.dart';
import '../controllers/clock_out_controller.dart';

class ClockOutView extends StatefulWidget {
  const ClockOutView({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<ClockOutView> {
  LatLng? currentLatLng;
  final pageC = Get.find<ClockOutController>();

  ClockOutController controller = Get.put(ClockOutController());

  late GoogleMapController mapController;
  Location location = new Location();
  var latitude;
  var longitude;
  late LocationData _locationData;

  get() async {
    _locationData = await location.getLocation();
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;
    setState(() {
      currentLatLng = new LatLng(latitude, longitude);
    });
  }

  String getSystemTime() {
    DateTime ntpTime = new DateTime.now();

    return new DateFormat("HH:mm").format(ntpTime);
  }

  // File? image;
  // Future pick(ImageSource source) async {
  //   try {
  //     final image =
  //         await ImagePicker().pickImage(source: source, imageQuality: 10);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print("failed to pick image : $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    setState(() {});
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        title: Text("${getSystemTime()}"),
      ),
      body: currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                initState();
              },
              child: Stack(
                children: [
                  Builder(builder: (context) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 460,
                      child: Container(
                        child: GoogleMap(
                          myLocationEnabled: true,
                          onCameraMove: (CameraPosition cameraPosition) {},
                          initialCameraPosition: CameraPosition(
                              target: currentLatLng!, zoom: 18.0),
                        ),
                      ),
                    );
                  }),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 390),
                    child: Icon(
                      Icons.photo_camera_outlined,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 60, right: 20, top: 390),
                    child: Text(" Foto : ",
                        style: TextStyle(
                          color: Color(0xFF6200EE),
                          fontSize: 17,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 90, bottom: 0),
                    child: Center(
                      child: Stack(
                        children: [
                          GetBuilder<ClockOutController>(
                            builder: (controller) {
                              return ClipOval(
                                child: Container(
                                    width: 98,
                                    height: 98,
                                    color: AppColor.primaryExtraSoft,
                                    child: controller.image != null
                                        ? Image.file(
                                            File(controller.image!.path),
                                            fit: BoxFit.cover,
                                          )
                                        : FlutterLogo(
                                            size: 160,
                                          )),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.pickImage(ImageSource.camera);
                                },
                                child: SvgPicture.asset('assets/camera.svg'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 250),
                    child: TextFormField(
                      cursorColor: Theme.of(context).cursorColor,
                      maxLength: 20,
                      controller: controller.catatan,
                      decoration: InputDecoration(
                        icon: Icon(Icons.menu),
                        labelText: 'Catatan',
                        labelStyle: TextStyle(
                          color: Color(0xFF6200EE),
                        ),
                        helperText:
                            'Bila tidak ada catatan isikan dengan strip (-)',
                        suffixIcon: Icon(
                          Icons.check_circle,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Obx(
          () => ElevatedButton(
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.changePage();
              }
            },
            child: Text(
              (controller.isLoading.isFalse) ? "Clock-Out" : 'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: AppColor.primarySoft,
              padding: EdgeInsets.symmetric(vertical: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      // Example
    );
  }
}
