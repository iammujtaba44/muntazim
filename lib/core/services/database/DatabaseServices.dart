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

  void getSchoolYear() {
    schoolYears.doc('37').get().then((value) {
      print(value.data());
    });
  }

  void test() {
    account.doc('38_1897').get().then((value) {
      AccountModel aa = accountModelFromJson(jsonEncode(value.data()));

      print(aa.students);
    });
  }
  // Map<String, ReportCardModel> getSchool(DocumentSnapshot qs) {
  //   print(qs.data());
  //   try {
  //     Map<String, ReportCardModel> school =
  //         reportCardModelFromJson(jsonEncode(qs.data()));
  //     return school;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Stream<Map<String, ReportCardModel>> getReportcard() {
    // return students
    //     .doc('398')
    //     .collection('ReportCard')
    //     .doc('37_123')
    //     .snapshots()
    //     .where((event) => event.data()['53'] == '53')
    //     .map(getSchool);
    //     .get()
    //     .then((value) {
    //   // print(value.data());
    //   Map<String, ReportCardModel> reportCardModel =
    //       reportCardModelFromJson(jsonEncode(value.data()));
    //
    //   print(reportCardModel.values
    //       .elementAt(0)
    //       .duration[1]
    //       .attributes
    //       .assignment[0]
    //       .totalMarks);
    //   // Duration duration =
    //   //     Duration.fromJson(reportCardModel.values.elementAt(0).duration[0]);
    //   // print(duration.attributes);
    // });
  }

  // Stream<SchoolModel> schoolStream({String stId}) {
  //   return DatabaseServices()
  //       .students
  //       .doc(stId)
  //       .snapshots()
  //       .map(getSchool); //user.snapshots().map(getuser);
  // }
  //
  // SchoolModel getSchool(DocumentSnapshot qs) {
  //   // print(qs.data());
  //   SchoolModel school;
  //   try {
  //     StudentModel student = studentModelFromJson(jsonEncode(qs.data()));
  //
  //     schools.doc(student.schools.keys.elementAt(0)).get().then((value) {
  //       school = schoolModelFromJson(jsonEncode(value.data()));
  //       //print(school.schoolName);
  //       print(school.schoolName);
  //       return school;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // SchoolModel getSchool1(String docId) {
  //   schools.doc(docId).get().then((value) {
  //     return
  //   });
  // }

  // void getStudents() {
  //   students.doc('398').get().then((value) {
  //     // print(value.data());
  //     StudentModel account = studentModelFromJson(jsonEncode(value.data()));

  // Map<dynamic, dynamic> schoolYear =
  //     account.schools.values.elementAt(0)['school_years'];
  // print(schoolYear[]);
  // account.schools.forEach((key, value) {
  // getSchool(key);
  // value.schoolYears.forEach((key, value) {
  //   value.programs.forEach((key, value) {
  //     print(value.subjects.values);
  //   });
  // });
  // });
  // print(account.schools.values
  //     .elementAt(0)
  //     .schoolYears
  //     .values
  //     .elementAt(0)
  //     .programs
  //     .values
  //     .elementAt(0)
  //     .subjects);
  // });

  //getSchool();
  //}

// void getAccountdata() {
//   account.doc('27_75').get().then((value) {
//     print(value.data());
//
//     AccountModel account = accountModelFromJson(jsonEncode(value.data()));
//     print(account.students.keys.elementAt(0));
//   });
// }

// AccountModel getAccount(DocumentSnapshot qs) {
//   return accountModelFromJson(jsonEncode(qs.data()));
// }

// Future<AccountModel> get parent async {
//   try {
//     DocumentSnapshot ds = await account.doc('27_75').get();
//     return accountModelFromJson(jsonEncode(ds.data()));
//   } catch (e) {
//     print(e.toString());
//   }
// }
//
// Stream<AccountModel> get userStream {
//   return account
//       .doc('27_75')
//       .snapshots()
//       .map(getAccount); //user.snapshots().map(getuser);
// }
}
