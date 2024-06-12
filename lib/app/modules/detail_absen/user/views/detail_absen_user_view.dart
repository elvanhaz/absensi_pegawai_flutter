import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/detail_absen_user_controller.dart';

class DetailAbsenUserView extends StatefulWidget {
  DetailAbsenUserView({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

DetailAbsenUserController controller = Get.put(DetailAbsenUserController());

class _MainScreenState extends State<DetailAbsenUserView> {
  final Map<String, dynamic> data = Get.arguments;

  @override
  void initState() {
    super.initState();
    itemList = [
      <String>["date", "Masuk", "Keluar"]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141A31),
      appBar: AppBar(
        title: Text(
          "${data['name']}",
        ),
        centerTitle: true,
        backgroundColor: Color(0xff141A31),
      ),
      body: GetBuilder<DetailAbsenUserController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getPresence(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snap.data?.docs.length == 0 || snap.data == null) {
                return Container(
                  height: 150,
                  child: Center(
                    child: Text("Belum ada data"),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snap.data!.docs[index].data();
                  itemList.add(<String>[
                    "${data['date']}",
                    "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date'])).toString()}",
                    "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date'])).toString()}",
                  ]);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      color: Color(0xff081029),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Masuk",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(data['date']))}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data['masuk']?['date'] == null
                                    ? "-"
                                    : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Keluar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                data['keluar']?['date'] == null
                                    ? "-"
                                    : "${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.dialog(Dialog(
                child: Container(
                    padding: EdgeInsets.all(20),
                    height: 400,
                    child: SfDateRangePicker(
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      selectionMode: DateRangePickerSelectionMode.range,
                      showActionButtons: true,
                      onCancel: () => Get.back(),
                      onSubmit: (obj) {
                        if (obj != null) {
                          if ((obj as PickerDateRange).endDate != null) {
                            controller.pickDAte(obj.startDate!, obj.endDate!);
                          }
                        }
                      },
                    )),
              ));
            },
            child: Icon(Icons.format_list_bulleted_rounded),
          ),
          FloatingActionButton(
            child: Icon(Icons.star),
            onPressed: () => getCsv(),
            heroTag: null,
          )
        ],
      ),
    );
  }
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
  print('data: ');
  print(itemList.toString());
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);
  String csv = const ListToCsvConverter().convert(itemList);
  Directory generalDownloadDir = Directory('/storage/emulated/0/Documents');
  final File file =
      await (File('${generalDownloadDir.path}/item_export_$formattedDate.csv')
          .create());
  await file.writeAsString(csv);
}
