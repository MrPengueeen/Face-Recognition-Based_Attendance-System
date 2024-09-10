import 'dart:math';

import 'package:face_recognition_attendance/features/dashboard/views/sidebar_screen.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ProcessAttendanceScreen extends StatefulWidget {
  const ProcessAttendanceScreen({super.key});

  @override
  State<ProcessAttendanceScreen> createState() =>
      _ProcessAttendanceScreenState();
}

class _ProcessAttendanceScreenState extends State<ProcessAttendanceScreen> {
  bool dataLoaded = false;

  List<Map<String, dynamic>> studentList = [];
  List<Map<String, dynamic>> absentList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    studentList.addAll(List.generate(
        35,
        (index) => {
              'name': 'Student ${Random().nextInt(60)}',
              'id': Random().nextInt(60) + 19702000
            }));

    absentList.addAll(List.generate(
        7,
        (index) => {
              'name': 'Student ${Random().nextInt(60)}',
              'id': Random().nextInt(60) + 19702000
            }));
    Future.delayed(Duration(seconds: 20), () {
      setState(() {
        dataLoaded = true;
      });
    });

    // Future.delayed(Duration(seconds: 5), () {
    //                       studentList.add({
    //                         'name': 'Student ${Random().nextInt(60)}',
    //                         'id': Random().nextInt(60) + 19702000
    //                       });
    //                       setState(() {});
    //                     });
  }

  void _showSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIConstants.colors.primaryWhite,
          surfaceTintColor: Colors.transparent,
          title: const Text('Submit Attendance'),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              color: UIConstants.colors.primaryWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Absent Students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: UIConstants.colors.secondaryTextGrey)),
                  SizedBox(height: 10),
                  ...absentList.map((e) => StudentCard(
                      studentName: e['name'],
                      studentID: e['id'],
                      present: false))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit Attendance'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Attendance has been submitted successfully.")));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const SidebarScreen()),
                    (Route<dynamic> route) => false);
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
      backgroundColor: UIConstants.colors.primaryPurple,
      appBar: AppBar(
        backgroundColor: UIConstants.colors.primaryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            height: height,
            width: width * 0.6,
            decoration: BoxDecoration(
              color: UIConstants.colors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laboratory on Computer Networks',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.primaryTextBlack,
                          fontSize: 15),
                    ),
                    Text(
                      'Computer Lab',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.secondaryTextGrey,
                          fontSize: 12),
                    ),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.secondaryTextGrey,
                          fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: height * 0.7 - 40,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/camera_preview.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (dataLoaded)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showSubmissionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(width * 0.1, 40),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            color: UIConstants.colors.primaryWhite),
                      ),
                    ),
                  ),
                if (!dataLoaded)
                  Center(
                    child: SizedBox(
                      width: width * 0.3,
                      child: const LinearProgressIndicator(),
                    ),
                  ),
                if (!dataLoaded)
                  Center(
                    child: Text('Processing Attendance from the image...'),
                  ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            height: height,
            width: width * 0.4 - 80,
            decoration: BoxDecoration(
              color: UIConstants.colors.primaryWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Present Students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: UIConstants.colors.secondaryTextGrey)),
                  SizedBox(height: 10),
                  ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      var e = studentList[index];

                      return StudentCard(
                          studentName: e['name'],
                          studentID: e['id'],
                          present: true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard(
      {super.key,
      required this.studentName,
      required this.studentID,
      required this.present});

  final String studentName;
  final int studentID;
  final bool present;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(width: 2),
            //   borderRadius: BorderRadius.circular(10),
            // ),

            title: Text(
              studentName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              studentID.toString(),
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
            trailing: Icon(present ? Icons.check_circle_outline : Icons.error,
                color: present ? Colors.green : Colors.red, size: 30),
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
