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
  List subjectList = List();
  List schoolsWithIds = List();
  Map<String, dynamic> monthFilterdWithSubject = Map();
  Map<String, dynamic> monthData = Map();
  var schoolId;
  dynamic attendancePercentage;
  var sessionId;
  var programId;
  var subjectId;
  var monthId;
  List monthsList = List();
  List announcementList = List();
  List assignmentList = List();
  List gradedAssignmentList = List();
  List dueAssignmentList = List();
  List submittedAssignmentList = List();
  List gradedAssignmentDetails = List();
  List dueAssignmentDetails = List();
  List submittedAssignmentDetails = List();
  List subjectsIcons = List();
  int detailStatus = 0;
  int detailIndex = 0;
  int _indexedStudent = 0;

  set indexedStudent(int indexedStudent) {
    this._indexedStudent = indexedStudent;
    notifyListeners();
  }
  get indexedStudent => _indexedStudent;

  void changeDetailStatus({status, index})
  {
    detailIndex = index;
    detailStatus = status;
    notifyListeners();
  }

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
      if (qs.data() != null) {
        if (qs.data()['is_current_year'] == "Y") {
          SchoolYearsModel schoolYear =
              schoolYearsModelFromJson(jsonEncode(qs.data()));
          return schoolYear;
        } else
          return null;
      } else
        return null;
    } catch (e) {
      print(e.toString());
    }
  }

  StudentModel getStudent(DocumentSnapshot qs) {
    //   print(qs.data());
    // if (this.parents.students.length == this.students.length) {
    //   this.students.clear();
    // }
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
    int containedIndex = this.parents.students.values.toList().indexOf(valueAt);
    String stdId = this.parents.students.keys.elementAt(containedIndex);
    this.indexedStudent = containedIndex;
     this.studentId = stdId;
    this.studentName = valueAt;
    // List<String> name = valueAt.split(' ');
    // name.remove('');
    //
    // List<StudentModel> temp = List<StudentModel>.from(this.students.where(
    //     (element) =>
    //         element.firstName.trim() == name[0] &&
    //         element.lastName.trim() == name[1]));
    // print('=========${temp}');
    // if (temp.isNotEmpty)
    //   {
    //     this.studentId = temp[0].studentId.toString();
    //     print("Old method std Id ==> ${temp[0].studentId}");
    //   }
    // else
    //   this.studentId = '';

    notifyListeners();
  }

  void studentUpdate(
      {int valueAt, bool attendance = false, bool isUpdateView = false, bool assignment = false}) {
    //clear all list here
    this.schools = Map();
    this.schoolList.clear();
    this.schoolYearList.clear();
    this.programsList.clear();
    this.monthsList.clear();
    this.studentSubjects = Map();
    this.monthFilterdWithSubject = Map();

    //get selected student id
    if (!isUpdateView) {
      this.studentName = this.parents.students.values.elementAt(valueAt);
      this.studentId = this.parents.students.keys.elementAt(valueAt).toString();
      this.indexedStudent = valueAt;
    }
    // get all data for transcript and attendance to show already populated
    this.getSchools();
    if (this.schools.isNotEmpty) {
      this.getSessions(schoolId: this.schools.keys.elementAt(0));
      this.getPrograms(
          schoolId: this.schools.keys.elementAt(0),
          sessionId:
              this.schools.values.elementAt(0).schoolYears.keys.elementAt(0));
      this.getsubjects(
          schoolId1: this.schools.keys.elementAt(0),
          sessionId1:
              this.schools.values.elementAt(0).schoolYears.keys.elementAt(0),
          programId1: this
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
      if (attendance) {
        this.subjectId = this.studentSubjects.values.elementAt(0);
        this.getMonths(
            subjectId: this.subjectId,
            programId1: this.programId,
            schoolId1: this.schoolId,
            sessionId1: this.sessionId);
      }
     if(assignment){
       this.subjectId = this.studentSubjects.values.elementAt(0);
       this.getAssignments(
           subjectId: this.subjectId,
           programId1: this.programId,
           schoolId1: this.schoolId,
           sessionId1: this.sessionId);
     }
      notifyListeners();
    }
    notifyListeners();
  }

  getSchoolsWithIds() {
    this.schoolsWithIds.add(jsonEncode(this.parents.schools));
    //notifyListeners();
  }

  getSchools({String stId, bool type = false}) async {
    this.schoolList.clear();
    this.schoolYearList.clear();
    this.programsList.clear();
    this.monthsList.clear();
    this.studentSubjects = Map();
    if (this.studentId == '') this.schools = Map();

    List<StudentModel> temp = List<StudentModel>.from(this
        .students
        .where((element) => element.studentId.toString() == this.studentId));
    print(
        "********GET SCHOOLS -> ${temp[0].schools.values.elementAt(0).schoolYears.values.elementAt(0).attendancePercentage}");
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
    this.programsList.clear();
    this.studentSubjects = Map();
    this.schools[schoolId].schoolYears.keys.forEach((element) {
      DatabaseServices().schoolYears.doc(element).get().then((value) {
        print(value.data());
        if (value.data() != null) {
          this.schoolYearList.add(value.data());
        }
        notifyListeners();
      });
    });

    //notifyListeners();
  }

  getPrograms({String schoolId, String sessionId, String schoolYearId}) async {
    this.programsList.clear();

    this.attendancePercentage =
        this.schools[schoolId].schoolYears[sessionId].attendancePercentage;
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
        print("*****(GET PROGRAMS --> Data)****");
        print(value.data());
        if (value.data() != null) this.programsList.add(value.data());

        notifyListeners();
      });
    });
  }

  getsubjects({String schoolId1, String programId1, String sessionId1}) {
    print('$schoolId1    $programId1     $sessionId1');
    this.subjectList.clear();
    this.subjectsIcons.clear();
    print(
        '----${this.schools[schoolId1].schoolYears[sessionId1].programs[programId1].subjects}');
    this.studentSubjects = this
                .schools[schoolId1]
                .schoolYears[sessionId1]
                .programs[programId1]
                .subjects ==
            null
        ? Map()
        : this
            .schools[schoolId1]
            .schoolYears[sessionId1]
            .programs[programId1]
            .subjects;

    print("*********GET SUBJECTS METHOD");
    print("*********(${this.studentSubjects})");

    if (this.studentSubjects.isNotEmpty) {
      this.studentSubjects.forEach((key, value) {
        DatabaseServices()
            .subjects
            .doc('${sessionId1}_${programId1}_$key')
            .get()
            .then((subjectIcon) {
          this.subjectsIcons.add(subjectIcon.data()['subject_icon']);
          notifyListeners();
          print(
              "***SUbject Icon data--> (${subjectIcon.data()['subject_icon']})");
        });
      });
    }

    notifyListeners();
  }

  getMonths(
      {String schoolId1,
      String programId1,
      String sessionId1,
      String subjectId}) {
    monthsList.clear();
    String sbId = '';
    this.studentSubjects.forEach((key, value) {
      if (value.contains(subjectId)) {
        sbId = key;
      }
    });
    // print('$schoolId1    $programId1     $sessionId1      $sbId');
    DatabaseServices()
        .students
        .doc(studentId)
        .collection('Attendance')
        .doc('${sessionId1}_$programId1')
        .get()
        .then((value) {
      Map<String, dynamic> attandance = value.data() == null
          ? Map()
          : attendanceModelFromJson(jsonEncode(value.data()));
      print("****GET MONTHS -> $attandance");
      if (attandance.isNotEmpty) {
        this.monthFilterdWithSubject = attandance[sbId];
        notifyListeners();
        this.monthId = this.monthFilterdWithSubject.keys.elementAt(0);
        monthsList.addAll(this.monthFilterdWithSubject.keys);
        monthsList.sort();
        //  getMonthData(monthId: this.monthId);

        // this.monthData = this.monthFilterdWithSubject[monthsList[0]];
        // print(this.monthData);
        //  print(value1[monthsList[0]]);
      }
      notifyListeners();
    });
  }

  getMonthData({String monthId}) {
    this.monthData = this.monthFilterdWithSubject[monthId];
    notifyListeners();
  }

  getSchoolYearForAnnouncement(
      {String selectedSchoolId, bool primary = false, BuildContext context}) {
    this.announcementList.clear();
    Provider.of<UserProvider>(context, listen: false).readAs();
    var user = Provider.of<UserProvider>(context, listen: false);
    DatabaseServices()
        .schoolYears
        .where("school_id", isEqualTo: int.tryParse(selectedSchoolId))
        .where("is_current_year", isEqualTo: "Y")
        .get()
        .then((value) {
      QueryDocumentSnapshot temp = value.docs[0];

      DatabaseServices()
          .announcements
          .where("masjid_id", isEqualTo: user.parentData.masjidId)
          .where("school_id", isEqualTo: int.tryParse(selectedSchoolId))
          .where("school_year",
              isEqualTo: temp.data()['school_session_id'].toString())
          .get()
          .then((announcements) {
        print(announcements.docs[0].data());
        print("User id --> ${selectedSchoolId}");
        print("User id --> ${temp.data()['school_session_id'].toString()}");

        announcements.docs.forEach((element) {
          if (element.data()['is_parent'] == "N") {
            try {
              Map<String, dynamic> tempAnnouncements =
                  element.data()['recipients_detail'];
              print(element.data());
              if (tempAnnouncements.keys
                  .contains(user.parentData.parentId.toString())) {
                print(element.data());
                announcementList.add(element.data());
              }
              // if (!primary) notifyListeners();
            } catch (e) {
              print("error4 --> ${e.toString()}");
            }
          }
        });
      }).catchError((onError1) {
        print("error1 --> ${onError1}");
      });
    }).catchError((onError) {
      print("error2 --> ${onError}");
    });

    if (!primary) notifyListeners();
  }

  getAssignments(
      {String schoolId1,
        String programId1,
        String sessionId1,
        String subjectId}) {
    assignmentList.clear();
    dueAssignmentList.clear();
      gradedAssignmentList.clear();
      submittedAssignmentList.clear();
    dueAssignmentDetails.clear();
    gradedAssignmentDetails.clear();
    submittedAssignmentDetails.clear();

    String sbId = '';
    this.studentSubjects.forEach((key, value) {
      if (value.contains(subjectId)) {
        sbId = key;
      }
    });
    print("********* GET ASSIGNMENTS *******");
    print('School id -> $schoolId1 || Program id -> $programId1 || Session id -> $sessionId1 || Subject id -> $sbId || Student id -> $studentId');
    DatabaseServices()
        .students
        .doc(studentId)
        .collection('Assignment').where('school_id', isEqualTo: int.tryParse(schoolId1))
    .where('school_year', isEqualTo: int.tryParse(sessionId1))
    .where('program_id', isEqualTo: int.tryParse(programId1))
    .where('subject_id', isEqualTo: int.tryParse(sbId))
        .get()
        .then((assignData) {
          print("Assignment data -->> ${assignData.docs.length}");
          if(assignData.docs != null && assignData.docs.isNotEmpty)
            {
              assignData.docs.forEach((element) {
                print("Assign data -->> ${element.data()}");
                if(element.data()['status'] == 'PENDING')
                {
                  DatabaseServices().assignments.doc(element.data()['assignment_id'].toString()).get().then((details) {
                    print("-------DETAILS--------");
                    print("${details.data()}");
                    dueAssignmentDetails.add(details.data());
                    dueAssignmentList.add(element.data());

                  });

                }
                if(element.data()['status'] == 'GRADED')
                  {
                    DatabaseServices().assignments.doc(element.data()['assignment_id'].toString()).get().then((details) {
                      print("-------DETAILS--------");
                      print("${details.data()}");
                      gradedAssignmentDetails.add(details.data());
                      gradedAssignmentList.add(element.data());
                    });

                  }
                if(element.data()['status'] == 'WDUEDATE' || element.data()['status'] == 'ADUEDATE')
                {
                  DatabaseServices().assignments.doc(element.data()['assignment_id'].toString()).get().then((details) {
                    print("-------DETAILS--------");
                    print("${details.data()}");
                    submittedAssignmentDetails.add(details.data());
                    submittedAssignmentList.add(element.data());
                  });

                }


                assignmentList.add(element.data());
                // DatabaseServices().assignments.doc(element.data()['assignment_id'].toString()).get().then((assignSubData){
                //   print("Assign SUB Data --> ${assignSubData.data()}");
                // } );

              });
            //  notifyListeners();
            }
      notifyListeners();
    });
  }
}
