import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: UIConstants.colors.primaryWhite,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: height,
                width: width * 0.25,
                color: UIConstants.colors.primaryPurple,
              ),
            ),
            Positioned(
              right: width * 0.125,
              top: height * 0.2,
              child: Container(
                height: height * 0.6,
                width: width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      // offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Image.asset('assets/images/classroom_artwork.jpeg',
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              left: width * 0.1,
              child: SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/cu_logo.png',
                            height: 100, width: 100),
                        Image.asset(
                          'assets/images/eee_logo.png',
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                    // Image.asset('assets/images/app_logo.png',
                    //     height: 500, width: 500),
                    Text(
                      'InstaAttend',
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: UIConstants.colors.primaryTextBlack),
                    ),
                    Text(
                      'A face recognition-based attendance tracking & management system',
                      style: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: UIConstants.colors.secondaryTextGrey),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: width * 0.2,
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
