import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/attendance/views/camera_preview_screen.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<CourseModel>? courseList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  Future<void> _getCourses() async {
    final controller = AttendanceController();
    final prefs = await SharedPreferences.getInstance();
    final teacherId = prefs.getInt('user_id');
    isLoading = true;
    try {
      courseList = await controller.getCoursesByTeacher(teacherId!);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error.toString());
      setState(() {
        isLoading = false;
      });
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
            isLoading
                ? LinearProgressIndicator()
                : GridView.count(
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 0,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: [
                      ...courseList!.map(
                        (course) => CourseInformationCard(
                          course: course,
                        ),
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
  const CourseInformationCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          _showClassSelectionDialog(context, course);
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
                course.name!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                DateFormat('MMMM dd, yyyy').format(course.createdAt!),
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
                    text: course.students!.length.toString(),
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
                        course.code!,
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
                        course.semester!,
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
                        course.session!,
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

  void _showClassSelectionDialog(BuildContext context, CourseModel course) {
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
                      builder: (ctx) => CameraPreviewScreen(
                            course: course,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
