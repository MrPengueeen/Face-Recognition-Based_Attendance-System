import 'dart:typed_data';

import 'package:face_recognition_attendance/features/admin/controllers/admin_controller.dart';
import 'package:face_recognition_attendance/features/attendance/views/camera_preview_screen.dart';
import 'package:face_recognition_attendance/features/attendance/views/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class AddNewStudentWidget extends StatefulWidget {
  const AddNewStudentWidget({super.key, required this.sessionList});

  final List<String> sessionList;

  @override
  State<AddNewStudentWidget> createState() => _AddNewStudentWidgetState();
}

class _AddNewStudentWidgetState extends State<AddNewStudentWidget> {
  bool captured = false;
  List<int> capturedFrame = [];
  late CaptureMjpegPreprocessor _capturePreProcessor;

  final _nameCont = TextEditingController();
  final _idCont = TextEditingController();
  late String selectedSession;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _capturePreProcessor = CaptureMjpegPreprocessor(onFrameCaptured: (frame) {
      setState(() {
        capturedFrame = frame!;
      });
    });
    selectedSession = widget.sessionList.first;
  }

  Future _onSubmitButtonPressed() async {
    try {
      final controller = AdminController();
      setState(() {
        isLoading = true;
      });
      await controller.addNewStudent(_nameCont.text, int.parse(_idCont.text),
          selectedSession, capturedFrame);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: UIConstants.colors.primaryRed,
          duration: const Duration(seconds: 4),
          content: Text(
            'Student has been added successfully',
            style:
                TextStyle(fontSize: 20, color: UIConstants.colors.primaryWhite),
          )));
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
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
    return SingleChildScrollView(
      child: Container(
        height: height * 0.7,
        width: width * 0.7,
        child: Row(
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SimpleTextField(
                      hintText: 'Name',
                      labelText: 'Name',
                      prefixIconData: Icons.search,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: UIConstants.colors.primaryWhite,
                      textColor: Colors.black,
                      accentColor: UIConstants.colors.primaryPurple,
                      textEditingController: _nameCont,
                      onChanged: (value) {
                        // searchQuery = value;

                        // _searchInList(searchQuery, _sessionCont.text);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTextField(
                      hintText: 'Student ID',
                      labelText: 'Student ID',
                      prefixIconData: Icons.search,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: UIConstants.colors.primaryWhite,
                      textColor: Colors.black,
                      accentColor: UIConstants.colors.primaryPurple,
                      textEditingController: _idCont,
                      onChanged: (value) {
                        // searchQuery = value;

                        // _searchInList(searchQuery, _sessionCont.text);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyAdvancedDropdown(
                      onChanged: (value) {
                        selectedSession = value;
                      },
                      items: widget.sessionList,
                      labelText: 'Select Session',
                      icon: const Icon(Icons.book_outlined),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const VerticalDivider(
              width: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: height * 0.6,
                    width: height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: UIConstants.colors.primaryTextBlack,
                    ),
                    child: capturedFrame.isNotEmpty
                        ? Image.memory(
                            Uint8List.fromList(capturedFrame),
                            fit: BoxFit.fitWidth,
                          )
                        : Mjpeg(
                            fit: BoxFit.fill,
                            isLive: !captured,
                            preprocessor:
                                captured ? _capturePreProcessor : null,
                            error: (context, error, stack) {
                              print(error);
                              print(stack);
                              return Text(error.toString(),
                                  style: TextStyle(color: Colors.red));
                            },
                            stream:
                                'http://192.168.0.105:8080/video', //'http://192.168.1.37:8081',
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isLoading)
                    const Center(
                      child: SizedBox(
                        width: 400,
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  if (captured && !isLoading)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                captured = false;
                                capturedFrame.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UIConstants.colors.primaryRed,
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
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (int.tryParse(_idCont.text) == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              UIConstants.colors.primaryRed,
                                          duration: const Duration(seconds: 4),
                                          content: Text(
                                            'Invalid student ID',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: UIConstants
                                                    .colors.primaryWhite),
                                          )));
                                  return;
                                } else {
                                  _onSubmitButtonPressed();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UIConstants.colors.primaryGreen,
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
                  if (!captured && !isLoading)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            captured = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIConstants.colors.primaryRed,
                          minimumSize: Size(width * 0.1, 50),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Capture',
                          style: TextStyle(
                              fontSize: 15,
                              color: UIConstants.colors.primaryWhite),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
