import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? docId;
  String? name;
  String? email;

  EmployeeModel({this.docId, this.name, this.email});

  EmployeeModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    name = data["name"];
    email = data["email"];
  }
}
