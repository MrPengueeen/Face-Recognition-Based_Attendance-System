import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/features/attendance/views/process_attendance_screen.dart';
import 'package:face_recognition_attendance/services/constants/app_constants.dart';
import 'package:face_recognition_attendance/ui_contants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key, required this.course});

  final CourseModel course;

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  bool captured = false;
  Uint8List? capturedFrame = Uint8List(0);
  late CaptureMjpegPreprocessor _capturePreProcessor;

  late final player = Player();

  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (player.platform is NativePlayer) {
        await (player.platform as dynamic).setProperty(
          'force-seekable',
          'yes',
        );
      }
    });

    player.stream.log.listen((event) {
      print("log $event");
    });
    //  Future.microtask(() async {

    //   if (player.platform is NativePlayer) {
    //     await (player.platform as dynamic).setProperty(
    //       'force-seekable',
    //       'yes',
    //     );
    //   }

    player.open(
      Media(AppConstants.CAMERA_URL),
    );
    // _capturePreProcessor = CaptureMjpegPreprocessor(onFrameCaptured: (frame) {
    //   setState(() {
    //     capturedFrame = frame!;
    //   });
    // });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

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
                        widget.course.name!,
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
                child: capturedFrame!.isNotEmpty
                    ? Image.memory(
                        capturedFrame!,
                        fit: BoxFit.fitWidth,
                      )
                    : Video(
                        controller: controller,
                        controls: NoVideoControls,
                      ),

                // Mjpeg(
                //     isLive: !captured,
                //     preprocessor: captured ? _capturePreProcessor : null,
                //     error: (context, error, stack) {
                //       print(error);
                //       print(stack);
                //       return Text(error.toString(),
                //           style: TextStyle(color: Colors.red));
                //     },
                //     stream:
                //         "rtsp://aonmoy:admin_admin!@192.168.0.105:554/Streaming/Channels/101/", //'http://192.168.1.37:8081',
                //   ),
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
                            capturedFrame = Uint8List(0);
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
                                builder: (ctx) => ProcessAttendanceScreen(
                                      course: widget.course,
                                      capturedImage: capturedFrame!,
                                    )),
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
                    onPressed: () async {
                      capturedFrame = await player.screenshot();
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef FrameCallback = void Function(List<int>? val);
const String BOUNDARY_PART =
    '\r\n\r\n--myboundary\r\nContent-Type: image/jpeg\r\nContent-Length: ';
const String BOUNDARY_DELTA_TIME = '\r\nDelta-time: 110';
const String BOUNDARY_END = '\r\n\r\n';

class CaptureMjpegPreprocessor extends MjpegPreprocessor {
  final FrameCallback onFrameCaptured;

  CaptureMjpegPreprocessor({required this.onFrameCaptured});
  Future<File> get _localFile async {
    final path = await getApplicationDocumentsDirectory();
    print(path);
    return File('${path.path}/image.mjpg');
  }

  Future<File> saveFrame(List<int> frame) async {
    final file = await _localFile;

    // Write the file
    List<int> head = utf8.encode(
        "${BOUNDARY_PART}${frame.length}${BOUNDARY_DELTA_TIME}${BOUNDARY_END}");
    file.writeAsBytes(head, mode: FileMode.append);

    return file.writeAsBytes(frame, mode: FileMode.append, flush: true);
  }

  @override
  List<int>? process(List<int> frame) {
    // _writeToFile(frame)
    // print(frame);

    onFrameCaptured(frame);
    // saveFrame(frame);
    return frame;
  }
}
