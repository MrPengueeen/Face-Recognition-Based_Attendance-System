import 'package:face_recognition_attendance/features/attendance/views/camera_preview_screen.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.colors.primaryBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleTextField(
                hintText: 'Search for courses',
                labelText: 'Search',
                prefixIconData: Icons.search,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: UIConstants.colors.primaryWhite,
                textColor: Colors.black,
                accentColor: UIConstants.colors.primaryPurple),
            const SizedBox(
              height: 40,
            ),
            Text(
              'My Courses',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UIConstants.colors.secondaryTextGrey),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.count(
              childAspectRatio: 1.3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 0,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                CourseInformationCard(
                  courseName: 'Digital Communication',
                  courseCode: 'EEE-615',
                  numOfStudents: 56,
                  semester: '6th',
                  session: '2018-19',
                  startDate: DateTime(2023, 2, 23),
                  teacherName: 'Dr. Md. Fazlul Kader',
                ),
                CourseInformationCard(
                  courseName: 'C Programming and Numerical Analysis',
                  courseCode: 'EEE-113',
                  numOfStudents: 64,
                  semester: '1st',
                  session: '2022-23',
                  startDate: DateTime(2023, 2, 17),
                  teacherName: 'Dr. Md. Fazlul Kader',
                ),
                CourseInformationCard(
                  courseName: 'Computer Networks',
                  courseCode: 'EEE-517',
                  numOfStudents: 59,
                  semester: '5th',
                  session: '2019-20',
                  startDate: DateTime(2023, 1, 14),
                  teacherName: 'Dr. Md. Fazlul Kader',
                ),
                CourseInformationCard(
                  courseName:
                      'Laboratory on C Programming and Numerical Analysis',
                  courseCode: 'EEE-114',
                  numOfStudents: 64,
                  semester: '1st',
                  session: '2022-23',
                  startDate: DateTime(2023, 2, 25),
                  teacherName: 'Dr. Md. Fazlul Kader',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseInformationCard extends StatelessWidget {
  const CourseInformationCard(
      {super.key,
      required this.courseName,
      required this.numOfStudents,
      required this.courseCode,
      required this.startDate,
      required this.semester,
      required this.session,
      required this.teacherName});

  final String courseName;
  final int numOfStudents;
  final String courseCode;
  final DateTime startDate;
  final String semester;
  final String session;
  final String teacherName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          _showClassSelectionDialog(context);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: UIConstants.colors.primaryPurple, width: 20)),
            color: UIConstants.colors.primaryWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          width: 350,
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                DateFormat('MMMM dd, yyyy').format(startDate),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: UIConstants.colors.secondaryTextGrey),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: UIConstants.colors.secondaryTextGrey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: RichText(
                  text: TextSpan(
                    text: numOfStudents.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: ' Students',
                          style: TextStyle(
                              color: UIConstants.colors.secondaryTextGrey,
                              fontSize: 15)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Course Code',
                        style: TextStyle(
                            color: UIConstants.colors.secondaryTextGrey,
                            fontSize: 15),
                      ),
                      Text(
                        courseCode,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Semester',
                        style: TextStyle(
                            color: UIConstants.colors.secondaryTextGrey,
                            fontSize: 15),
                      ),
                      Text(
                        semester,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Session',
                        style: TextStyle(
                            color: UIConstants.colors.secondaryTextGrey,
                            fontSize: 15),
                      ),
                      Text(
                        session,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClassSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Select Clasroom'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MyAdvancedDropdown(
                  items: [
                    'Room 112',
                    'Room 113',
                    'Room 114',
                    'Electronics Lab-I',
                    'Room 212',
                    'Room 214',
                    'Computer Lab',
                  ],
                  labelText: 'Select a classroom',
                  icon: Icon(Icons.other_houses_outlined),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Start Attendance'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const CameraPreviewScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
