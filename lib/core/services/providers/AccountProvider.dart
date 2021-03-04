import 'dart:convert';

import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/ReportCardModel.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/SchoolYearsModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class AccountProvider with ChangeNotifier {
  AccountModel parents = AccountModel();
  List<StudentModel> students = List();
  Map<String, String> studentSubjects = Map();
  String studentName = '';
  String studentId = '';
  Map<String, School> schools;
  List schoolList = List();
  List schoolYearList = List();
  List programsList = List();
  var schoolId;

  var sessionId;

  var programId;
  AccountModel getAccount(DocumentSnapshot qs) {
    //accountModelFromJson(jsonEncode(qs.data()));
    // print(qs.data());
    try {
      this.parents = accountModelFromJson(jsonEncode(qs.data()));

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

  SchoolYearsModel getSchoolYear(DocumentSnapshot qs) {
    // print(qs.data());
    try {
      SchoolYearsModel schoolYear =
          schoolYearsModelFromJson(jsonEncode(qs.data()));
      return schoolYear;
    } catch (e) {
      print(e.toString());
    }
  }

  StudentModel getStudent(DocumentSnapshot qs) {
    // print(qs.data());
    if (this.parents.students.length == this.students.length) {
      this.students.clear();
    }
    try {
      StudentModel student = studentModelFromJson(jsonEncode(qs.data()));
      students.add(student);
      return student;
    } catch (e) {
      print(e.toString());
    }
  }

  ReportCardModel getReportCard(DocumentSnapshot qs, String subjectId) {
    // print(qs.data()[subjectId]);
    try {
      ReportCardModel r = ReportCardModel.fromJson(qs.data()[subjectId]);
      return r;
    } catch (e) {
      print('+++ ${e.toString()}');
      return null;
    }
  }

  Stream<StudentModel> studentStream({String stId}) {
    return DatabaseServices()
        .students
        .doc(stId)
        .snapshots()
        .map(getStudent); //user.snapshots().map(getuser);
  }

  Stream<AccountModel> userStream({String Id}) {
    //27_324
    return DatabaseServices()
        .account
        .doc(Id)
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

  Stream<SchoolYearsModel> schoolYearStream({String schoolYearId}) {
    return DatabaseServices()
        .schoolYears
        .doc(schoolYearId)
        .snapshots()
        .map(getSchoolYear); //user.snapshots().map(getuser);
  }

  Stream<ReportCardModel> reportCardStream({String subjectId, String docId}) {
    return DatabaseServices()
        .students
        .doc(this.studentId)
        .collection('ReportCard')
        .doc(docId)
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
    print('=========${temp}');
    if (temp.isNotEmpty)
      this.studentId = temp[0].studentId.toString();
    else
      this.studentId = '';
    notifyListeners();
  }

  void studentUpdate({int valueAt}) {
    this.schools = Map();
    this.schoolList.clear();
    this.schoolYearList.clear();
    this.programsList.clear();
    this.studentSubjects = Map();
    this.studentName = this.parents.students.values.elementAt(valueAt);
    this.studentId = this.parents.students.keys.elementAt(valueAt).toString();

    print('stdId check ${this.studentId}');
    this.getSchools();
    if (this.schools.isNotEmpty) {
      this.getSessions(schoolId: this.schools.keys.elementAt(0));
      this.getPrograms(
          schoolId: this.schools.keys.elementAt(0),
          sessionId:
              this.schools.values.elementAt(0).schoolYears.keys.elementAt(0));
      this.getsubjects(
          schoolId: this.schools.keys.elementAt(0),
          sessionId:
              this.schools.values.elementAt(0).schoolYears.keys.elementAt(0),
          programId: this
              .schools
              .values
              .elementAt(0)
              .schoolYears
              .values
              .elementAt(0)
              .programs
              .keys
              .elementAt(0));
      this.schoolId = this.schools.keys.elementAt(0);
      this.sessionId =
          this.schools.values.elementAt(0).schoolYears.keys.elementAt(0);
      this.programId = this
          .schools
          .values
          .elementAt(0)
          .schoolYears
          .values
          .elementAt(0)
          .programs
          .keys
          .elementAt(0);
    }
    notifyListeners();
  }

  getSchools({String stId, bool type = false}) async {
    this.schoolList.clear();
    this.schoolYearList.clear();
    this.programsList.clear();
    this.studentSubjects = Map();
    if (this.studentId == '') this.schools = Map();

    List<StudentModel> temp = List<StudentModel>.from(this
        .students
        .where((element) => element.studentId.toString() == this.studentId));

    if (temp.isNotEmpty) this.schools = temp[0].schools;
    this.schools.keys.forEach((element) {
      DatabaseServices().schools.doc(element).get().then((value) {
        //   print(value.data());
        this.schoolList.add(value.data());
        //if (type)
        notifyListeners();
      });
    });
    //   notifyListeners();
  }

  getSessions({String schoolId}) async {
    this.schoolYearList.clear();
    this.studentSubjects = Map();
    this.schools[schoolId].schoolYears.keys.forEach((element) {
      DatabaseServices().schoolYears.doc(element).get().then((value) {
        print(value.data());
        this.schoolYearList.add(value.data());
        notifyListeners();
      });
    });

    //notifyListeners();
  }

  getPrograms({String schoolId, String sessionId, String schoolYearId}) async {
    this.programsList.clear();
    this
        .schools[schoolId]
        .schoolYears[sessionId]
        .programs
        .keys
        .forEach((element) {
      print('${sessionId}_$element');
      DatabaseServices()
          .programs
          .doc('${sessionId}_$element')
          .get()
          .then((value) {
        print(value.data());
        this.programsList.add(value.data());
        notifyListeners();
      });
    });
  }

  getsubjects({String schoolId, String programId, String sessionId}) {
    print(
        '----${this.schools[schoolId].schoolYears[sessionId].programs[programId].subjects}');
    this.studentSubjects = this
        .schools[schoolId]
        .schoolYears[sessionId]
        .programs[programId]
        .subjects;

    notifyListeners();
  }
}
