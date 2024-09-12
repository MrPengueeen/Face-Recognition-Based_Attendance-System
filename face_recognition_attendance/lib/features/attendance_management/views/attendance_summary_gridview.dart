import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryGridviewWidget extends StatelessWidget {
  const AttendanceSummaryGridviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.9,
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      crossAxisCount: 6,
      children: [
        StudentAttendanceCard(
          name: 'Aonmoy Das',
          id: 19702037,
          attendance: true,
        ),
        StudentAttendanceCard(
          name: 'Aonmoy Das',
          id: 19702037,
          attendance: false,
        ),
      ],
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            id.toString(),
            style: TextStyle(color: UIConstants.colors.secondaryTextGrey),
          ),
          const SizedBox(
            height: 20,
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
