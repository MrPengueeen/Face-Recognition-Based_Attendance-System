import 'package:data_table_2/data_table_2.dart';
import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  const AttendanceSummaryScreen({super.key, required this.course});

  final CourseModel course;

  @override
  State<AttendanceSummaryScreen> createState() =>
      _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  bool isLoading = false;
  List<AttendanceModel> attendanceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAttendanceSummary();
  }

  Future _getAttendanceSummary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final controller = AttendanceController();
      attendanceList = await controller.getAttendanceSummary(widget.course);
      setState(() {
        isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: UIConstants.colors.background,
      appBar: AppBar(
        backgroundColor: UIConstants.colors.primaryPurple,
        iconTheme: IconThemeData(color: UIConstants.colors.primaryWhite),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
              width: 500,
              child: LinearProgressIndicator(),
            ))
          // : attendanceList.isEmpty
          //     ? Center(
          //         child: Text(
          //           'Oops!\nThere is no attendance record available for the selected course.',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //               color: UIConstants.colors.secondaryTextGrey,
          //               fontSize: 20),
          //         ),
          //       )
          : Placeholder(),
    );
  }
}

class DataTableColumn extends StatelessWidget {
  const DataTableColumn({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }
}

class DataTableRow extends StatelessWidget {
  const DataTableRow({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }
}
