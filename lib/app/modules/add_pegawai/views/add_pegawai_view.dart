import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';
import '../../../utils/app_color.dart';
import '../../update_profile/views/update_profile_view.dart';
import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  AddPegawaiView({Key? key}) : super(key: key);
  AddPegawaiController bookcontroller = AddPegawaiController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pegawai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: BackButton(color: Colors.white),
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
          CustomInput(
            controller: controller.nipC,
            label: 'NIP',
            hint: '1000000001',
          ),
          CustomInput(
            controller: controller.nameC,
            label: 'Nama Lengkap',
            hint: 'Dian Maghrib',
          ),
          CustomInput(
            controller: controller.emailC,
            label: 'Email',
            hint: 'Emailkamu@email.com',
          ),
          CustomInput(
            controller: controller.jobC,
            label: 'Pekerjaan',
            hint: 'Karyawan',
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 0, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Divisi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
                child: Obx(() => DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    value: controller.itemCurrent.value,
                    items: controller.items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (item) {
                      controller.itemCurrent.value = item!;
                      print(item);
                    })),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.addPegawai();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse)
                      ? 'Tambah Pegawai'
                      : 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
