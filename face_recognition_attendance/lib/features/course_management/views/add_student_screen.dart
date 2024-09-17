import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/course_management/controllers/course_management_controller.dart';
import 'package:face_recognition_attendance/features/course_management/models/student_model.dart';
import 'package:face_recognition_attendance/features/course_management/views/course_details_screen.dart';
import 'package:face_recognition_attendance/features/dashboard/views/sidebar_screen.dart';

import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';

class AddStudentToCourseScreen extends StatefulWidget {
  const AddStudentToCourseScreen({super.key, required this.course});

  final CourseModel course;

  @override
  State<AddStudentToCourseScreen> createState() =>
      _AddStudentToCourseScreenState();
}

class _AddStudentToCourseScreenState extends State<AddStudentToCourseScreen> {
  List<StudentModel> students = [];
  List<StudentModel> visibleStudents = [];
  List<StudentModel> selectedStudents = [];
  final _sessionCont = TextEditingController();
  String searchQuery = '';

  List<String> sessionList = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _generateSession();
    _getStudentList();
  }

  _searchInList(String searchQuery, String session) {
    if (searchQuery.isEmpty) {
      visibleStudents = students.where((student) {
        return (student.session! == session);
      }).toList();
    } else {
      visibleStudents = students.where((student) {
        return ((student.studentId
                    .toString()
                    .contains(searchQuery.toLowerCase())) ||
                (student.name!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))) &&
            (student.session! == session);
      }).toList();
    }

    setState(() {});
  }

  _generateSession() {
    final endYear = DateTime.now().year + 1;
    final startYear = endYear - 7;
    for (int i = startYear; i <= endYear; i++) {
      sessionList.add('$i-${(i + 1) % 100}');
    }

    _sessionCont.text = sessionList.first;
    searchQuery = '';
  }

  _getStudentList() async {
    try {
      setState(() {
        isLoading = true;
      });

      final controller = CourseManagementController();
      students = await controller.getStudents();
      visibleStudents = students.toList();
      _searchInList(searchQuery, _sessionCont.text);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: UIConstants.colors.primaryRed,
          duration: const Duration(seconds: 4),
          content: Text(
            error.toString(),
            style:
                TextStyle(fontSize: 20, color: UIConstants.colors.primaryWhite),
          ),
        ),
      );
    }
  }

  _showAddStudentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Add students to the course?'),
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
              child: const Text('Add'),
              onPressed: () async {
                try {
                  final controller = CourseManagementController();
                  await controller.addStudentsToCourse(
                      widget.course, selectedStudents);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => SidebarScreen(),
                      ),
                      (Route<dynamic> route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: UIConstants.colors.primaryGreen,
                      duration: const Duration(seconds: 4),
                      content: Text(
                        'The selected students have been added.',
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: UIConstants.colors.primaryWhite,
        ),
        backgroundColor: UIConstants.colors.primaryPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: SimpleTextField(
                    hintText: 'Search for students',
                    labelText: 'Search',
                    prefixIconData: Icons.search,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: UIConstants.colors.primaryWhite,
                    textColor: Colors.black,
                    accentColor: UIConstants.colors.primaryPurple,
                    onChanged: (value) {
                      searchQuery = value;

                      _searchInList(searchQuery, _sessionCont.text);
                    },
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Flexible(
                  child: MyAdvancedDropdown(
                    onChanged: (value) {
                      _sessionCont.text = value;
                      _searchInList(searchQuery, _sessionCont.text);
                    },
                    items: sessionList,
                    labelText: 'Select Session',
                    icon: const Icon(Icons.book_outlined),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
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
                          _showAddStudentsDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIConstants.colors.primaryPurple,
                          minimumSize: const Size(200, 60),
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
                              'Add selected (${selectedStudents.length}) students',
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
            const SizedBox(
              height: 20,
            ),
            GridView.count(
              childAspectRatio: 2.6,
              shrinkWrap: true,
              crossAxisCount: 6,
              children: visibleStudents
                  .map(
                    (e) => AddStudentSelectionCard(
                      student: e,
                      course: widget.course,
                      isSelected: selectedStudents
                          .map((selectedStudent) => selectedStudent.studentId)
                          .contains(e.studentId),
                      onChanged: (value) {
                        if (value) {
                          selectedStudents.add(e);

                          setState(() {});
                        } else {
                          selectedStudents.removeAt(selectedStudents.indexWhere(
                              (element) => element.studentId == e.studentId));

                          setState(() {});
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentSelectionCard extends StatelessWidget {
  const AddStudentSelectionCard(
      {super.key,
      required this.student,
      required this.isSelected,
      required this.onChanged,
      required this.course});
  final StudentModel student;
  final bool isSelected;
  final StudentSelectionCallback onChanged;
  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 350,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
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
          course.students!.map((e) => e.studentId).contains(student.studentId)
              ? Text(
                  'Added',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: UIConstants.colors.primaryRed),
                )
              : Checkbox(
                  checkColor: UIConstants.colors.primaryGreen,
                  fillColor:
                      WidgetStatePropertyAll(UIConstants.colors.primaryWhite),
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
