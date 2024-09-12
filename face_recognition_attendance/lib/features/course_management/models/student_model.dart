class StudentModel {
  int? studentId;
  String? name;
  String? session;
  int? id;

  StudentModel({this.studentId, this.name, this.session, this.id});

  StudentModel.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    name = json['name'];
    session = json['session'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['name'] = this.name;
    data['session'] = this.session;
    data['id'] = this.id;
    return data;
  }
}
