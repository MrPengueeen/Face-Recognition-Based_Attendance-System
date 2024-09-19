import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/course_management/controllers/course_management_controller.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/features/course_management/views/add_student_screen.dart';
import 'package:face_recognition_attendance/features/dashboard/views/sidebar_screen.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key, required this.course});

  final CourseModel course;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIConstants.colors.primaryPurple,
        iconTheme: IconThemeData(color: UIConstants.colors.primaryWhite),
      ),
      backgroundColor: UIConstants.colors.background,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Details',
              style: TextStyle(
                  color: UIConstants.colors.secondaryTextGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: height * 0.45,
              decoration: BoxDecoration(
                color: UIConstants.colors.primaryWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset(
                        'assets/images/course_image.jpg',
                        width: width * 0.4,
                        fit: BoxFit.fill,
                      ),
                    ),
                    CourseDetailsCard(course: widget.course),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StudentListSelectionWidget(course: widget.course),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsCard extends StatelessWidget {
  const CourseDetailsCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: 650,
        height: 290,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              course.name!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: UIConstants.colors.secondaryTextGrey),
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
                ),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Teacher',
                        style: TextStyle(
                            color: UIConstants.colors.secondaryTextGrey,
                            fontSize: 15),
                      ),
                      Text(
                        course.teacherName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // _showAddNewStudentDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIConstants.colors.primaryPurple,
                      minimumSize: Size(200, 60),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_document,
                          color: UIConstants.colors.primaryWhite,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Edit Course Information',
                          style: TextStyle(
                              fontSize: 15,
                              color: UIConstants.colors.primaryWhite),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => AddStudentToCourseScreen(
                            course: course,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIConstants.colors.primaryPurple,
                      minimumSize: Size(200, 60),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: UIConstants.colors.primaryWhite,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Add Students',
                          style: TextStyle(
                              fontSize: 15,
                              color: UIConstants.colors.primaryWhite),
                        ),
                      ],
                    ),
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

class StudentListSelectionWidget extends StatefulWidget {
  const StudentListSelectionWidget({super.key, required this.course});
  final CourseModel course;

  @override
  State<StudentListSelectionWidget> createState() =>
      _StudentListSelectionWidgetState();
}

class _StudentListSelectionWidgetState
    extends State<StudentListSelectionWidget> {
  List<StudentModel> selectedStudents = [];

  _showDeleteStudentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Remove students from course?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ...selectedStudents.map(
                  (student) => StudentSelectionCard(
                    student: student,
                    isSelected: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  final controller = CourseManagementController();
                  await controller.removeStudentsFromCourse(
                      widget.course, selectedStudents);
                  final prefs = await SharedPreferences.getInstance();
                  var name = prefs.getString('name');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => SidebarScreen(
                          name: name!,
                        ),
                      ),
                      (Route<dynamic> route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: UIConstants.colors.primaryGreen,
                      duration: const Duration(seconds: 4),
                      content: Text(
                        'The selected students have been removed.',
                        style: TextStyle(
                            fontSize: 20,
                            color: UIConstants.colors.primaryWhite),
                      ),
                    ),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: UIConstants.colors.primaryRed,
                      duration: const Duration(seconds: 4),
                      content: Text(
                        error.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: UIConstants.colors.primaryWhite),
                      ),
                    ),
                  );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Students',
              style: TextStyle(
                  color: UIConstants.colors.secondaryTextGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            if (selectedStudents.isNotEmpty)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteStudentsDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIConstants.colors.primaryPurple,
                      minimumSize: Size(200, 60),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: UIConstants.colors.primaryWhite,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Delete selected (${selectedStudents.length}) students',
                          style: TextStyle(
                              fontSize: 15,
                              color: UIConstants.colors.primaryWhite),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        GridView.count(
          childAspectRatio: 2.6,
          shrinkWrap: true,
          crossAxisCount: 6,
          children: widget.course.students!
              .map(
                (e) => StudentSelectionCard(
                  student: e,
                  isSelected: selectedStudents
                      .map((selectedStudent) => selectedStudent.studentId)
                      .contains(e.studentId),
                  onChanged: (value) {
                    if (value) {
                      selectedStudents.add(e);
                      print(selectedStudents);
                      setState(() {});
                    } else {
                      selectedStudents.removeAt(selectedStudents.indexWhere(
                          (element) => element.studentId == e.studentId));
                      print(selectedStudents);
                      setState(() {});
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

typedef StudentSelectionCallback = void Function(bool value);

class StudentSelectionCard extends StatelessWidget {
  const StudentSelectionCard(
      {super.key,
      required this.student,
      required this.isSelected,
      required this.onChanged});
  final StudentModel student;
  final bool isSelected;
  final StudentSelectionCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 350,
      alignment: Alignment.center,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: UIConstants.colors.primaryWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    student.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Text(
                    student.studentId.toString(),
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            checkColor: UIConstants.colors.primaryGreen,
            fillColor: WidgetStatePropertyAll(UIConstants.colors.primaryWhite),
            shape: const CircleBorder(
              eccentricity: 1.0,
            ),
            value: isSelected,
            onChanged: (value) {
              onChanged(value!);
            },
          )
        ],
      ),
    );
  }
}
