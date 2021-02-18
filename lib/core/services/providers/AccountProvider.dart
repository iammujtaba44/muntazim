import 'dart:convert';

import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class AccountProvider with ChangeNotifier {
  AccountModel parents = AccountModel();
  List<StudentModel> students = List();
  String student = '';

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
    try {
      SchoolModel school = schoolModelFromJson(jsonEncode(qs.data()));
      return school;
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

  void studentUpdate({int valueAt}) {
    this.student = this.parents.students.values.elementAt(valueAt);
    //this.parents.students.values.elementAt(valueAt).split(' ').last;
    notifyListeners();
  }
}
