import 'dart:convert';
import 'dart:io';

import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/ReportCardModel.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/authModel/AccountModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class DatabaseServices extends ResponseState {
  final CollectionReference account =
      FirebaseFirestore.instance.collection('Accounts');
  final CollectionReference students =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference schools =
      FirebaseFirestore.instance.collection('Schools');
  final CollectionReference schoolYears =
      FirebaseFirestore.instance.collection('SchoolYears');
  final CollectionReference programs =
      FirebaseFirestore.instance.collection('Programs');
  final CollectionReference announcements =
      FirebaseFirestore.instance.collection('Announcements');
  final CollectionReference subjects =
      FirebaseFirestore.instance.collection('Subjects');
  void test() {
    students
        .doc('21514')
        .collection('Attendance')
        .doc('209_1110')
        .get()
        .then((value) {
      //print(value.data());

      Map<String, dynamic> attandance =
          attendanceModelFromJson(jsonEncode(value.data()));

      Map<String, dynamic> value1 = attandance['394'];
      print(value1.length);
      Map<String, dynamic> status = value1['03-2021']['daily_status'];
      //print(value1);
      print(status.keys.elementAt(0));

      DateTime date = DateTime.tryParse(status.keys.elementAt(0));
      print(date);
    });
  }
}
