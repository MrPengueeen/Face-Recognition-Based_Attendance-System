import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_summary_gridview.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_summary_listview.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_summary_screen.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({super.key});

  @override
  State<AttendanceManagementScreen> createState() =>
      _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState
    extends State<AttendanceManagementScreen> {
  var selectedDate = DateTime.now();
  var day = '';
  bool isGridView = false;
  int viewModeIndex = 0;
  late CourseModel selectedCourse;
  bool isCoursesLoading = false;
  bool isAttendanceLoading = false;

  List<CourseModel> courses = [];
  List<AttendanceModel> attendance = [];

  int attendanceNumber = 0;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _updateDay();
    _getCoursesAndAttendance();
  }

  void _updateDay() {
    final now = DateTime.now();
    final today = now;
    final yesterday = now.subtract(const Duration(hours: 24));

    final dateToCheck = selectedDate;
    final aDate = dateToCheck;
    // print('ADate: $aDate');
    if ((aDate.year == today.year) &&
        (aDate.month == today.month) &&
        (aDate.day == today.day)) {
      day = 'Today, ';
      // print('Today: $today');
      // print('Yesterday: $yesterday');
    } else if ((aDate.year == yesterday.year) &&
        (aDate.month == yesterday.month) &&
        (aDate.day == yesterday.day)) {
      day = 'Yesterday, ';
      // print('Today: $today');
      // print('Yesterday: $yesterday');
    } else {
      day = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateDay();
        _getAttendance();
      });
    }
  }

  Future _getCoursesAndAttendance() async {
    setState(() {
      isCoursesLoading = true;
      attendanceNumber = 0;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final teacherId = prefs.getInt('user_id');
      final controller = AttendanceController();

      courses = await controller.getCoursesByTeacher(teacherId!);
      if (courses.isNotEmpty) {
        selectedCourse = courses[0];
        attendance =
            await controller.getAttendanceByDate(selectedCourse, selectedDate);
      }
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: UIConstants.colors.primaryRed,
            duration: const Duration(seconds: 4),
            content: Text(
              'No courses found. Please add a course to your account.',
              style: TextStyle(
                  fontSize: 20, color: UIConstants.colors.primaryWhite),
            )));
      }

      isCoursesLoading = false;

      setState(() {});
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

  Future _getAttendance() async {
    setState(() {
      isAttendanceLoading = true;
      attendanceNumber = 0;
    });
    final controller = AttendanceController();
    try {
      attendance =
          await controller.getAttendanceByDate(selectedCourse, selectedDate);
      setState(() {
        isAttendanceLoading = false;
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
      setState(() {
        isAttendanceLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: UIConstants.colors.background,
      body: isCoursesLoading
          ? const Center(
              child: SizedBox(width: 300, child: LinearProgressIndicator()),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance Management',
                    style: TextStyle(
                        fontSize: 19,
                        color: UIConstants.colors.primaryTextBlack,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: MyAdvancedDropdown(
                          onChanged: (value) {
                            selectedCourse = courses
                                .firstWhere((element) => element.code == value);
                            _getAttendance();
                          },
                          items: courses.map((e) => e.code!).toList(),
                          labelText: 'Select course',
                          icon: const Icon(Icons.book_online),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCourse == null) {
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AttendanceSummaryScreen(
                                        course: selectedCourse,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UIConstants.colors.primaryPurple,
                            minimumSize: Size(width * 0.1, 60),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            'Get Attendance Summary',
                            style: TextStyle(
                                fontSize: 15,
                                color: UIConstants.colors.primaryWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (attendance.isNotEmpty)
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (attendanceNumber == 0) {
                                  return;
                                }
                                setState(() {
                                  attendanceNumber = attendanceNumber - 1;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: UIConstants.colors.primaryPurple,
                              ),
                            ),
                            Text(
                                'Attendance ${attendanceNumber + 1}/${attendance.length}'),
                            IconButton(
                              onPressed: () {
                                if (attendanceNumber + 1 == attendance.length) {
                                  return;
                                }
                                setState(() {
                                  attendanceNumber = attendanceNumber + 1;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: UIConstants.colors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: DateWidget(
                                  dateTime: selectedDate,
                                  day: day,
                                  incrementDate: () {
                                    var now = DateTime.now();
                                    if (selectedDate.year == now.year &&
                                        selectedDate.month == now.month &&
                                        selectedDate.day == now.day) return;
                                    setState(() {
                                      selectedDate = selectedDate
                                          .add(const Duration(hours: 24));
                                      _updateDay();
                                      _getAttendance();
                                    });
                                  },
                                  decrementDate: () {
                                    setState(() {
                                      selectedDate = selectedDate
                                          .subtract(const Duration(hours: 24));
                                      _updateDay();
                                      _getAttendance();
                                    });
                                  },
                                  onClick: () {
                                    _selectDate(context);
                                  }),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Flexible(
                              child: ToggleSwitch(
                                onToggle: (index) {
                                  if (index == 0) {
                                    setState(() {
                                      viewModeIndex = index!;
                                      isGridView = false;
                                    });
                                  } else {
                                    setState(() {
                                      viewModeIndex = index!;
                                      isGridView = true;
                                    });
                                  }
                                },
                                borderColor: [UIConstants.colors.background],
                                activeBgColor: [
                                  UIConstants.colors.primaryPurple,
                                  UIConstants.colors.primaryPurple,
                                ],
                                minWidth: 50.0,
                                minHeight: 30.0,
                                initialLabelIndex: viewModeIndex,
                                animate: true,
                                cornerRadius: 10.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.white,
                                inactiveFgColor:
                                    UIConstants.colors.primaryPurple,
                                totalSwitches: 2,
                                icons: const [
                                  Icons.list,
                                  Icons.grid_on_rounded,
                                ],
                                iconSize: 40.0,
                                borderWidth: 0.0,
                                activeBgColors: [
                                  [
                                    UIConstants.colors.primaryPurple,
                                  ],
                                  [UIConstants.colors.primaryPurple]
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isAttendanceLoading)
                    const Center(
                      child: SizedBox(
                        width: 500,
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  if (attendance.isEmpty && !isAttendanceLoading)
                    Center(
                      child: Text(
                        'Oops!\nThere is no attendance record available for the selected date.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: UIConstants.colors.secondaryTextGrey,
                            fontSize: 20),
                      ),
                    ),
                  if (isGridView && attendance.isNotEmpty)
                    AttendanceSummaryGridviewWidget(
                      attendance: attendance[attendanceNumber],
                      course: selectedCourse,
                    ),
                  if (!isGridView && attendance.isNotEmpty)
                    AttendanceSummaryListViewWidget(
                      attendance: attendance[attendanceNumber],
                      course: selectedCourse,
                    ),
                ],
              ),
            ),
    );
  }
}
