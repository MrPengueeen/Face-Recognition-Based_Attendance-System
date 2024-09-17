import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/course_management/controllers/course_management_controller.dart';
import 'package:face_recognition_attendance/features/course_management/views/course_details_screen.dart';
import 'package:face_recognition_attendance/services/util-functions/utiils.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  List<CourseModel> courseList = [];

  bool isLoading = false;

  final _nameCont = TextEditingController();
  final _codeCont = TextEditingController();
  final _semesterCont = TextEditingController();
  final _sessionCont = TextEditingController();

  List<String> sessionList = [];
  List<String> semesterList = [];

  final _fomrKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCourses();
    _generateSemesterAndSession();
  }

  _generateSemesterAndSession() {
    semesterList = List.generate(8, (index) => Utils.ordinal(index + 1));

    final endYear = DateTime.now().year + 1;
    final startYear = endYear - 6;
    for (int i = startYear; i <= endYear; i++) {
      sessionList.add('$i-${(i + 1) % 100}');
    }

    _semesterCont.text = semesterList.first;
    _sessionCont.text = sessionList.first;
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

  void _showAddNewCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIConstants.colors.primaryWhite,
          surfaceTintColor: Colors.transparent,
          title: const Text('Add new course'),
          content: SingleChildScrollView(
            child: Form(
              key: _fomrKey,
              child: Container(
                width: 400,
                color: UIConstants.colors.primaryWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SimpleTextField(
                      hintText: 'Course Name',
                      labelText: 'Course Name',
                      prefixIconData: Icons.book_outlined,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      textColor: Colors.black,
                      accentColor: UIConstants.colors.primaryPurple,
                      textEditingController: _nameCont,
                      validator: (value) {
                        if (value.isEmpty) return false;
                        return true;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTextField(
                      hintText: 'Course Code',
                      labelText: 'Course Code',
                      prefixIconData: Icons.book_outlined,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      textColor: Colors.black,
                      accentColor: UIConstants.colors.primaryPurple,
                      textEditingController: _codeCont,
                      validator: (value) {
                        if (value.isEmpty) return false;
                        return true;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyAdvancedDropdown(
                      onChanged: (value) {
                        _semesterCont.text = value;
                      },
                      items: semesterList,
                      labelText: 'Select Semester',
                      icon: const Icon(Icons.book_outlined),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyAdvancedDropdown(
                      onChanged: (value) {
                        _sessionCont.text = value;
                      },
                      items: sessionList,
                      labelText: 'Select Session',
                      icon: const Icon(Icons.book_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add Course'),
              onPressed: () async {
                try {
                  if (_fomrKey.currentState!.validate()) {
                    final controller = CourseManagementController();
                    final prefs = await SharedPreferences.getInstance();

                    int teacherId = prefs.getInt('user_id')!;
                    await controller.addCourse(teacherId, _nameCont.text,
                        _codeCont.text, _sessionCont.text, _semesterCont.text);
                    Navigator.of(context).pop();
                    _getCourses();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: UIConstants.colors.primaryGreen,
                        duration: const Duration(seconds: 4),
                        content: Text(
                          'The course has been added successfully!',
                          style: TextStyle(
                              fontSize: 20,
                              color: UIConstants.colors.primaryWhite),
                        )));
                  }
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
            isLoading
                ? const Center(
                    child: SizedBox(
                      width: 500,
                      child: LinearProgressIndicator(),
                    ),
                  )
                : courseList.isEmpty
                    ? Center(
                        child: Text(
                          'Oops!\n No courses found. Please add a new course.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: UIConstants.colors.secondaryTextGrey,
                              fontSize: 20),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Courses',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: UIConstants.colors.secondaryTextGrey),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showAddNewCourseDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UIConstants.colors.primaryPurple,
                              minimumSize: Size(width * 0.1, 60),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: UIConstants.colors.primaryWhite,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Add New Course',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: UIConstants.colors.primaryWhite),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            const SizedBox(
              height: 30,
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
                        (course) => CourseCard(
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

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => CourseDetailsScreen(
                      course: course,
                    )),
          );
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
}
