import 'dart:convert';

List<Students> employeeFromJson(String str) =>
    List<Students>.from(json.decode(str).map((x) => Students.fromJson(x)));

String employeeToJson(List<Students> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Students {
  int? id;
  String? email;
  String? firstName;
  String? lastName;

  Students({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory Students.fromJson(Map<String, dynamic> json) => Students(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
      };
}
