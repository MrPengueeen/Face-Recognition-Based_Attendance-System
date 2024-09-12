import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_summary_gridview.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_summary_listview.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateDay();
  }

  void _updateDay() {
    final now = DateTime.now();
    final today = now;
    final yesterday = now.subtract(Duration(hours: 24));

    final dateToCheck = selectedDate;
    final aDate = dateToCheck;
    print(dateToCheck);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: UIConstants.colors.background,
      body: SingleChildScrollView(
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
                    items: [
                      'EEE-615',
                      'EEE-113',
                      'EEE-517',
                      'EEE-114',
                    ],
                    labelText: 'Select course',
                    icon: Icon(Icons.book_online),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {},
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
                          fontSize: 15, color: UIConstants.colors.primaryWhite),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
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
                          selectedDate = selectedDate.add(Duration(hours: 24));
                          _updateDay();
                        });
                      },
                      decrementDate: () {
                        setState(() {
                          selectedDate =
                              selectedDate.subtract(Duration(hours: 24));
                          _updateDay();
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
                    inactiveFgColor: UIConstants.colors.primaryPurple,
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
            const SizedBox(
              height: 20,
            ),
            if (isGridView) AttendanceSummaryGridviewWidget(),
            if (!isGridView) AttendanceSummaryListViewWidget(),
          ],
        ),
      ),
    );
  }
}
