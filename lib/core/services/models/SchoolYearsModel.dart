import 'dart:convert';

SchoolYearsModel schoolYearsModelFromJson(String str) =>
    SchoolYearsModel.fromJson(json.decode(str));

String schoolYearsModelToJson(SchoolYearsModel data) =>
    json.encode(data.toJson());

class SchoolYearsModel {
  SchoolYearsModel({
    this.isPreviousYear,
    this.schoolId,
    this.isCurrentYear,
    this.schoolYear,
    this.isNextYear,
    this.schoolSessionId,
  });

  String isPreviousYear;
  dynamic schoolId;
  String isCurrentYear;
  String schoolYear;
  String isNextYear;
  dynamic schoolSessionId;

  factory SchoolYearsModel.fromJson(Map<String, dynamic> json) =>
      SchoolYearsModel(
        isPreviousYear: json["is_previous_year"],
        schoolId: json["school_id"],
        isCurrentYear: json["is_current_year"],
        schoolYear: json["school_year"],
        isNextYear: json["is_next_year"],
        schoolSessionId: json["school_session_id"],
      );

  Map<String, dynamic> toJson() => {
        "is_previous_year": isPreviousYear,
        "school_id": schoolId,
        "is_current_year": isCurrentYear,
        "school_year": schoolYear,
        "is_next_year": isNextYear,
        "school_session_id": schoolSessionId,
      };
}
