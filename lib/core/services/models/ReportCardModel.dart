import 'dart:convert';

Map<String, ReportCardModel> reportCardModelFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) =>
        MapEntry<String, ReportCardModel>(k, ReportCardModel.fromJson(v)));

String reportCardModelToJson(Map<String, ReportCardModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

Map<String, dynamic> attendanceModelFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<String, dynamic>(k, v));

class ReportCardModel {
  ReportCardModel({this.duration, this.subjectPercentage});

  List<DurationSubject> duration;
  dynamic subjectPercentage;
  // List<dynamic> duration;
  factory ReportCardModel.fromJson(Map<String, dynamic> json) =>
      ReportCardModel(
        subjectPercentage: json["subjects_percentage"] == null
            ? "00.00"
            : json["subjects_percentage"],
        duration: List<DurationSubject>.from(
            json["duration"].map((x) => DurationSubject.fromJson(x))),
        // duration: List<dynamic>.from(json["duration"])
      );

  Map<String, dynamic> toJson() => {
        "duration": List<dynamic>.from(duration.map((x) => x.toJson())),
      };
}

class DurationSubject {
  DurationSubject({
    this.grading,
    this.attributes,
    this.durationTitle,
  });

  Grading grading;
  Attributes attributes;
  dynamic durationTitle;

  factory DurationSubject.fromJson(Map<String, dynamic> json) =>
      DurationSubject(
        grading: Grading.fromJson(json["grading"]),
        attributes: json["attributes"].isEmpty
            ? null
            : Attributes.fromJson(json["attributes"]),
        durationTitle: json["duration_title"],
      );

  Map<String, dynamic> toJson() => {
        "grading": grading.toJson(),
        "attributes": attributes == null ? null : attributes.toJson(),
        "duration_title": durationTitle,
      };
}

class Attributes {
  Attributes({
    this.assignment,
    this.attendance,
  });

  List<Assignment> assignment;
  List<Assignment> attendance;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        assignment: json["assignment"] == null
            ? null
            : List<Assignment>.from(
                json["assignment"].map((x) => Assignment.fromJson(x))),
        attendance: json["attendance"] == null
            ? null
            : List<Assignment>.from(
                json["attendance"].map((x) => Assignment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assignment": List<dynamic>.from(assignment.map((x) => x.toJson())),
        "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
      };
}

class Assignment {
  Assignment({
    this.totalMarks,
    this.weight,
    this.assignmentTitle,
    this.obtainedMarks,
  });

  dynamic totalMarks;
  dynamic weight;
  dynamic assignmentTitle;
  dynamic obtainedMarks;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        totalMarks: json["total_marks"],
        weight: json["weight"],
        assignmentTitle:
            json["assignment_title"] == null ? null : json["assignment_title"],
        obtainedMarks: json["obtained_marks"],
      );

  Map<String, dynamic> toJson() => {
        "total_marks": totalMarks,
        "weight": weight,
        "assignment_title": assignmentTitle == null ? null : assignmentTitle,
        "obtained_marks": obtainedMarks,
      };
}

class Grading {
  Grading({
    this.percentageGrade,
  });

  PercentageGrade percentageGrade;

  factory Grading.fromJson(Map<String, dynamic> json) => Grading(
        percentageGrade: PercentageGrade.fromJson(json["percentage_grade"]),
      );

  Map<String, dynamic> toJson() => {
        "percentage_grade": percentageGrade.toJson(),
      };
}

class PercentageGrade {
  PercentageGrade({
    this.percentage,
    this.grade,
  });

  dynamic percentage;
  dynamic grade;

  factory PercentageGrade.fromJson(Map<String, dynamic> json) =>
      PercentageGrade(
        percentage: json["percentage"],
        grade: json["grade"],
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "grade": grade,
      };
}
