import 'dart:typed_data';

import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProcessAttendanceScreen extends StatefulWidget {
  const ProcessAttendanceScreen(
      {super.key, required this.course, required this.capturedImage});

  final CourseModel course;
  final List<int> capturedImage;

  @override
  State<ProcessAttendanceScreen> createState() =>
      _ProcessAttendanceScreenState();
}

class _ProcessAttendanceScreenState extends State<ProcessAttendanceScreen> {
  bool dataLoaded = false;

  List<StudentModel> studentList = [];
  List<StudentModel> absentList = [];

  @override
  void initState() {
    super.initState();
    _processAttendance();
  }

  Future<void> _processAttendance() async {
    final controller = AttendanceController();

    try {
      studentList = await controller.processAttendanceFromImage(
          widget.course, widget.capturedImage);

      setState(() {
        dataLoaded = true;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: UIConstants.colors.primaryRed,
          duration: const Duration(seconds: 4),
          content: Text(
            error.toString(),
            style:
                TextStyle(fontSize: 20, color: UIConstants.colors.primaryWhite),
          )));
    }
  }

  void _showSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIConstants.colors.primaryWhite,
          surfaceTintColor: Colors.transparent,
          title: const Text('Submit Attendance'),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              color: UIConstants.colors.primaryWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Absent Students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: UIConstants.colors.secondaryTextGrey)),
                  SizedBox(height: 10),
                  ...absentList.map((e) => StudentCard(
                      studentName: e.name!,
                      studentID: e.studentId!,
                      face: [],
                      present: false))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit Attendance'),
              onPressed: () async {
                try {
                  final controller = AttendanceController();
                  final response = await controller.submitAttendance(
                      widget.course, studentList);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Attendance has been submitted successfully.")));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: UIConstants.colors.primaryRed,
                      duration: const Duration(seconds: 4),
                      content: Text(
                        error.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: UIConstants.colors.primaryWhite),
                      )));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: UIConstants.colors.primaryPurple,
      appBar: AppBar(
        backgroundColor: UIConstants.colors.primaryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            height: height,
            width: width * 0.6,
            decoration: BoxDecoration(
              color: UIConstants.colors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.name!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.primaryTextBlack,
                          fontSize: 15),
                    ),
                    Text(
                      'Computer Lab',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.secondaryTextGrey,
                          fontSize: 12),
                    ),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.secondaryTextGrey,
                          fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: height * 0.7 - 40,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.memory(
                    Uint8List.fromList(widget.capturedImage),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (dataLoaded)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        absentList.clear();
                        widget.course.students!.forEach((student) {
                          if (!studentList
                              .map((e) => e.studentId)
                              .contains(student.studentId)) {
                            absentList.add(student);
                          }
                        });
                        _showSubmissionDialog(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(width * 0.1, 40),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            color: UIConstants.colors.primaryWhite),
                      ),
                    ),
                  ),
                if (!dataLoaded)
                  Center(
                    child: SizedBox(
                      width: width * 0.3,
                      child: const LinearProgressIndicator(),
                    ),
                  ),
                if (!dataLoaded)
                  Center(
                    child: Text('Processing Attendance from the image...'),
                  ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            height: height,
            width: width * 0.4 - 80,
            decoration: BoxDecoration(
              color: UIConstants.colors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Present Students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: UIConstants.colors.secondaryTextGrey)),
                  SizedBox(height: 10),
                  ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      var e = studentList[index];

                      return StudentCard(
                          studentName: e.name!,
                          studentID: e.studentId!,
                          face: e.face!,
                          present: true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard(
      {super.key,
      required this.studentName,
      required this.studentID,
      required this.present,
      required this.face});

  final String studentName;
  final int studentID;
  final bool present;
  final List<int> face;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(width: 2),
            //   borderRadius: BorderRadius.circular(10),
            // ),

            title: Text(
              studentName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              studentID.toString(),
              style: TextStyle(color: UIConstants.colors.secondaryTextGrey),
            ),
            leading: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UIConstants.colors.primaryPurple),
                child: face.isEmpty
                    ? Icon(Icons.person)
                    : Image.memory(Uint8List.fromList(face))),
            trailing: Icon(present ? Icons.check_circle_outline : Icons.error,
                color: present ? Colors.green : Colors.red, size: 30),
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
