import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryListViewWidget extends StatefulWidget {
  AttendanceSummaryListViewWidget({
    super.key,
    required this.attendance,
    required this.course,
  });

  final AttendanceModel attendance;
  final CourseModel course;

  @override
  State<AttendanceSummaryListViewWidget> createState() =>
      _AttendanceSummaryListViewWidgetState();
}

class _AttendanceSummaryListViewWidgetState
    extends State<AttendanceSummaryListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.course.students!.length,
      itemBuilder: (context, index) {
        var e = widget.course.students![index];

        return StudentAttendanceTile(
          name: e.name!,
          id: e.studentId!,
          attendance: widget.attendance.students!
              .map((student) => student.studentId)
              .contains(e.studentId),
        );
      },
    );
  }
}

class StudentAttendanceTile extends StatelessWidget {
  const StudentAttendanceTile({
    super.key,
    required this.name,
    required this.id,
    required this.attendance,
  });

  final String name;
  final int id;
  final bool attendance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            tileColor: UIConstants.colors.primaryWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              id.toString(),
              style: TextStyle(color: UIConstants.colors.secondaryTextGrey),
            ),
            leading: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: UIConstants.colors.primaryPurple),
              child: Icon(
                Icons.person_2_sharp,
                color: UIConstants.colors.primaryWhite,
              ),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attendance
                          ? UIConstants.colors.primaryGreen
                          : UIConstants.colors.backgroundGrey),
                  child: Text(
                    'P',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: attendance
                            ? UIConstants.colors.primaryWhite
                            : UIConstants.colors.primaryTextBlack),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !attendance
                          ? UIConstants.colors.primaryRed
                          : UIConstants.colors.backgroundGrey),
                  child: Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: !attendance
                            ? UIConstants.colors.primaryWhite
                            : UIConstants.colors.primaryTextBlack),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
