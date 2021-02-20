import 'dart:convert';

import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/ReportCardModel.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class AccountProvider with ChangeNotifier {
  AccountModel parents = AccountModel();
  List<StudentModel> students = List();
  Map<String, String> studentSubjects = Map();
  String studentName = '';
  String studentId = '';

  AccountModel getAccount(DocumentSnapshot qs) {
    try {
      this.parents = accountModelFromJson(jsonEncode(qs.data()));
      this.parents.students.keys.forEach((element) {
        DatabaseServices().students.doc(element).get().then((value) {
          students.add(studentModelFromJson(jsonEncode(value.data())));
        });
      });
      return this.parents;
    } catch (e) {
      print(e.toString());
    }
  }

  SchoolModel getSchool(DocumentSnapshot qs) {
    // print(qs.data());
    try {
      SchoolModel school = schoolModelFromJson(jsonEncode(qs.data()));
      return school;
    } catch (e) {
      print(e.toString());
    }
  }

  ReportCardModel getReportCard(DocumentSnapshot qs, String subjectId) {
    // print(qs.data()[subjectId]);
    try {
      // Map<String, ReportCardModel> reportCard =
      //     reportCardModelFromJson(jsonEncode(qs.data()));
      ReportCardModel r = ReportCardModel.fromJson(qs.data()[subjectId]);
      // print(r);
      // //  print(reportCard[subjectId]);
      // // ReportCardModel r = reportCard[subjectId];
      return r;
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<AccountModel> get userStream {
    return DatabaseServices()
        .account
        .doc('27_324')
        .snapshots()
        .map(getAccount); //user.snapshots().map(getuser);
  }

  Stream<SchoolModel> schoolStream({String schoolId}) {
    return DatabaseServices()
        .schools
        .doc(schoolId)
        .snapshots()
        .map(getSchool); //user.snapshots().map(getuser);
  }

  Stream<ReportCardModel> reportCardStream({String subjectId}) {
    return DatabaseServices()
        .students
        .doc(this.studentId)
        .collection('ReportCard')
        .doc('37_123')
        .snapshots()
        .map((event) => getReportCard(event, subjectId));
    //user.snapshots().map(getuser);
  }

  void studentIdUpdate({String valueAt}) {
    List<String> name = valueAt.split(' ');
    name.remove('');
    List<StudentModel> temp = List<StudentModel>.from(this.students.where(
        (element) =>
            element.firstName.trim() == name[0] &&
            element.lastName.trim() == name[1]));
    this.studentId = temp[0].studentId.toString();
    notifyListeners();
  }

  void studentUpdate({int valueAt}) {
    this.studentName = this.parents.students.values.elementAt(valueAt);
    this.studentId = this.parents.students.keys.elementAt(valueAt).toString();

    //this.parents.students.values.elementAt(valueAt).split(' ').last;
    notifyListeners();
  }

  int getStudentSubjects({String stdId}) {
    List<StudentModel> temp = List<StudentModel>.from(this
        .students
        .where((element) => element.studentId.toString() == studentId));
    this.studentSubjects = temp[0]
        .schools
        .values
        .elementAt(0)
        .schoolYears
        .values
        .elementAt(0)
        .programs
        .values
        .elementAt(0)
        .subjects;
    //notifyListeners();
    int len = 0;
    len = this.studentSubjects.length;
    // this.studentSubjects.schools.forEach((key, value) {
    //   value.schoolYears.forEach((key, value) {
    //     value.programs.forEach((key, value) {
    //       value.subjects.forEach((key, value1) {
    //         len += value1.length;
    //       });
    //     });
    //   });
    // });
    print(len);
    return len;
  }
}
