import 'package:api_to_sqlite/src/models/student_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class StudentApiProvider {
  Future<List<Students?>> getAllStudents() async {
    var url = "https://demo7930416.mockable.io/notes";
    Response response = await Dio().get(url);

    return (response.data as List).map((student) {
      // ignore: avoid_print
      DBProvider.db.createStudent(Students.fromJson(student));
    }).toList();
  }
}
