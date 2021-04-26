import 'dart:convert';

StudentModel studentModelFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  StudentModel({
    this.age,
    this.customFields,
    this.dob,
    this.donorId,
    this.emergencyContact,
    this.firstName,
    this.gender,
    this.lastName,
    this.medicalNeeds,
    this.photo,
    this.previousSchool,
    this.schools,
    this.status,
    this.studentId,
  });

  dynamic age;
  dynamic customFields;
  String dob;
  dynamic donorId;
  dynamic emergencyContact;
  String firstName;
  String gender;
  String lastName;
  String medicalNeeds;
  String photo;
  String previousSchool;
  // Map<dynamic, dynamic> schools;
  Map<String, School> schools;
  dynamic status;
  dynamic studentId;
  // json["schools"]
  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        age: json["age"],
        customFields: json["custom_fields"],
        dob: json["dob"],
        donorId: json["donor_id"],
        emergencyContact: json["emergency_contact"],
        firstName: json["first_name"],
        gender: json["gender"],
        lastName: json["last_name"],
        medicalNeeds: json["medical_needs"],
        photo: json["photo"],
        previousSchool: json["previous_school"],
        schools: Map.from(json["schools"])
            .map((k, v) => MapEntry<String, School>(k, School.fromJson(v))),
        status: json["status"],
        studentId: json["student_id"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "custom_fields": customFields,
        "dob": dob,
        "donor_id": donorId,
        "emergency_contact": emergencyContact,
        "first_name": firstName,
        "gender": gender,
        "last_name": lastName,
        "medical_needs": medicalNeeds,
        "photo": photo,
        "previous_school": previousSchool,
        "schools": schools,
        "status": status,
        "student_id": studentId,
      };
}
// class Schools {
//   Schools({
//     this.schools,
//   });
//
//   Map<String, School> schools;
//
//   factory Schools.fromJson(Map<String, dynamic> json) => Schools(
//     schools: Map.from(json["schools"]).map((k, v) => MapEntry<String, School>(k, School.fromJson(v))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "schools": Map.from(schools).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//   };
// }

class School {
  School({
    this.schoolYears,
  });

  Map<String, SchoolYear> schoolYears;

  factory School.fromJson(Map<String, dynamic> json) => School(
        schoolYears: json["school_years"] == null
            ? null
            : Map.from(json["school_years"]).map((k, v) =>
                MapEntry<String, SchoolYear>(k, SchoolYear.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "school_years": schoolYears == null
            ? null
            : Map.from(schoolYears)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class SchoolYear {
  SchoolYear({this.programs, this.attendancePercentage});

  Map<String, Program> programs;
  dynamic attendancePercentage;

  factory SchoolYear.fromJson(Map<String, dynamic> json) {
    // print("--++_--+${json['attendance_percentage']}");
    return SchoolYear(
      attendancePercentage: json['attendance_percentage'],
      programs: json["programs"] == null
          ? null
          : Map.from(json["programs"])
              .map((k, v) => MapEntry<String, Program>(k, Program.fromJson(v))),
    );
  }

  Map<String, dynamic> toJson() => {
        "programs": programs == null
            ? null
            : Map.from(programs)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Program {
  Program({
    this.subjects,
  });

  Map<String, String> subjects;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        subjects: json["subjects"] == null
            ? null
            : Map.from(json["subjects"])
                .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "subjects": subjects == null
            ? null
            : Map.from(subjects).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
