import 'package:face_recognition_attendance/features/attendance/views/process_attendance_screen.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  bool captured = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIConstants.colors.primaryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          color: Colors.black,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laboratory on Computer Networks',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: UIConstants.colors.primaryWhite,
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(
                        //         builder: (context) => SidebarScreen()),
                        //     (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UIConstants.colors.secondaryTextGrey,
                        minimumSize: Size(50, 50),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Camera Preview',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: UIConstants.colors.primaryWhite),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                height: height * 0.7,
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
              if (captured)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            captured = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIConstants.colors.secondaryTextGrey,
                          minimumSize: Size(width * 0.1, 50),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Capture Again',
                          style: TextStyle(
                              fontSize: 15,
                              color: UIConstants.colors.primaryWhite),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    const ProcessAttendanceScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(width * 0.1, 50),
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
                    ],
                  ),
                ),
              if (!captured)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        captured = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIConstants.colors.secondaryTextGrey,
                      minimumSize: Size(width * 0.1, 50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Capture',
                      style: TextStyle(
                          fontSize: 15, color: UIConstants.colors.primaryWhite),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
