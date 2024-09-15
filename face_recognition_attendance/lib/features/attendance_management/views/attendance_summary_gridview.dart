import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/ui_contants.dart';

import 'package:flutter/material.dart';

class AttendanceSummaryGridviewWidget extends StatefulWidget {
  const AttendanceSummaryGridviewWidget(
      {super.key, required this.attendance, required this.course});

  final AttendanceModel attendance;
  final CourseModel course;

  @override
  State<AttendanceSummaryGridviewWidget> createState() =>
      _AttendanceSummaryGridviewWidgetState();
}

class _AttendanceSummaryGridviewWidgetState
    extends State<AttendanceSummaryGridviewWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.8,
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      crossAxisCount: 6,
      children: widget.course.students!
          .map(
            (e) => StudentAttendanceCard(
              name: e.name!,
              id: e.studentId!,
              attendance: widget.attendance.students!
                  .map((student) => student.studentId)
                  .contains(e.studentId),
            ),
          )
          .toList(),
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  const StudentAttendanceCard(
      {super.key,
      required this.name,
      required this.id,
      required this.attendance});

  final String name;
  final int id;
  final bool attendance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UIConstants.colors.primaryWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
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
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            id.toString(),
            style: TextStyle(color: UIConstants.colors.secondaryTextGrey),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ],
      ),
    );
  }
}
