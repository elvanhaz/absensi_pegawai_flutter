import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../controllers/update_profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user['nip'];
    controller.nameC.text = user['name'];
    controller.emailC.text = user['email'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(
            'assets/arrow-left.svg',
            color: Colors.white,
          ),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user['uid']);
                }
              },
              child: Text(
                (controller.isLoading.isFalse) ? 'Done' : 'Loading...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondaryExtraSoft,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          // section 1 - Profile Picture
          Center(
            child: Stack(
              children: [
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    if (controller.image != null) {
                      return ClipOval(
                        child: Container(
                          width: 98,
                          height: 98,
                          color: AppColor.primaryExtraSoft,
                          child: Image.file(
                            File(controller.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return ClipOval(
                        child: Container(
                          width: 98,
                          height: 98,
                          color: AppColor.primaryExtraSoft,
                          child: Image.network(
                            (user["profile"] == null || user['profile'] == "")
                                ? "https://ui-avatars.com/api/?name=${user['name']}/"
                                : user['profile'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
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
                        controller.pickImage();
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
          //section 2 - user data
          CustomInput(
            controller: controller.nameC,
            label: "Nama Panjang",
            hint: "Your Full Name",
            margin: EdgeInsets.only(bottom: 16, top: 42),
          ),
          CustomInput(
            controller: controller.nipC,
            label: "ID Pegawai",
            hint: "100000000000",
            disabled: true,
          ),
          CustomInput(
            controller: controller.emailC,
            label: "Email",
            hint: "youremail@email.com",
            disabled: true,
          ),
        ],
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  final bool disabled;
  final EdgeInsetsGeometry margin;
  final bool obsecureText;
  final Widget? suffixIcon;

  CustomInput({
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.obsecureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      child: Material(
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            top: 4,
          ),
          margin: margin,
          decoration: BoxDecoration(
            color: (disabled == false)
                ? Colors.transparent
                : AppColor.primaryExtraSoft,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
          ),
          child: TextField(
            readOnly: disabled,
            obscureText: obsecureText,
            style: TextStyle(fontSize: 14, fontFamily: 'poppins'),
            maxLines: 1,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixIcon ?? SizedBox(),
              label: Text(
                label,
                style: TextStyle(
                  color: AppColor.secondarySoft,
                  fontSize: 14,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500,
                color: AppColor.secondarySoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
