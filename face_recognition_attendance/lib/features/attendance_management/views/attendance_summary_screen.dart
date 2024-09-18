import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:face_recognition_attendance/features/attendance/controller/attendance_controller.dart';
import 'package:face_recognition_attendance/features/attendance/models/attendance_model.dart';
import 'package:face_recognition_attendance/features/attendance/models/course_model.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

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

  late AttendanceDataSource dataSource;

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
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
      dataSource = AttendanceDataSource(attendanceList, widget.course);
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
          : attendanceList.isEmpty
              ? Center(
                  child: Text(
                    'Oops!\nThere is no attendance record available for the selected course.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: UIConstants.colors.secondaryTextGrey,
                        fontSize: 20),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  // physics: const NeverScrollableScrollPhysics(),
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
                                widget.course.name! +
                                    ' - ${widget.course.code}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UIConstants.colors.primaryTextBlack,
                                    fontSize: 15),
                              ),
                              Text(
                                widget.course.teacherName!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UIConstants.colors.primaryTextBlack,
                                    fontSize: 12),
                              ),
                              Text(
                                'Session: ${widget.course.session}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UIConstants.colors.primaryTextBlack,
                                    fontSize: 12),
                              ),
                              Text(
                                'Semester: ${widget.course.semester}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: UIConstants.colors.primaryTextBlack,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String? outputFile =
                                  await FilePicker.platform.saveFile(
                                dialogTitle: 'Please select an output file:',
                                fileName:
                                    '${widget.course.code}_${widget.course.session}.xlsx',
                              );

                              if (outputFile != null) {
                                final xlsio.Workbook workbook =
                                    xlsio.Workbook();
                                final xlsio.Worksheet worksheet =
                                    workbook.worksheets[0];
                                key.currentState!
                                    .exportToExcelWorksheet(worksheet);
                                final List<int> bytes = workbook.saveAsStream();
                                await File(outputFile)
                                    .writeAsBytes(bytes, flush: true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            UIConstants.colors.primaryGreen,
                                        duration: const Duration(seconds: 4),
                                        content: Text(
                                          'The attendance summary has be exported successfully!',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: UIConstants
                                                  .colors.primaryWhite),
                                        )));
                                try {} catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              UIConstants.colors.primaryRed,
                                          duration: const Duration(seconds: 4),
                                          content: Text(
                                            error.toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: UIConstants
                                                    .colors.primaryWhite),
                                          )));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UIConstants.colors.primaryPurple,
                              minimumSize: Size(width * 0.2, 60),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: UIConstants.colors.primaryWhite,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Export as Excel Sheet',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: UIConstants.colors.primaryWhite),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: UIConstants.colors.primaryWhite,
                            borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        height: height - 60,
                        child: SfDataGrid(
                          key: key,
                          source: dataSource,
                          allowColumnsResizing: true,
                          frozenRowsCount: 0,
                          frozenColumnsCount: 2,
                          selectionMode: SelectionMode.single,
                          gridLinesVisibility: GridLinesVisibility.both,
                          showVerticalScrollbar: true,
                          showHorizontalScrollbar: true,
                          allowEditing: true,
                          headerRowHeight: 90,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          rowHeight: 70,
                          columns: <GridColumn>[
                            GridColumn(
                              minimumWidth: 120,
                              columnName: 'id',
                              label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'ID',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GridColumn(
                              minimumWidth: 200,
                              columnName: 'name',
                              label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GridColumn(
                              minimumWidth: 120,
                              columnName: 'total_number_of_classes',
                              width: 120,
                              label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Total Number of Classes',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            GridColumn(
                              minimumWidth: 120,
                              columnName: 'total_attended',
                              label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Total Attended',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GridColumn(
                              minimumWidth: 120,
                              columnName: 'percentage',
                              label: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Percentage',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            ...attendanceList.map((attendance) => GridColumn(
                                  minimumWidth: 120,
                                  columnName: DateFormat('dd MMMM, yyyy')
                                      .format(DateTime.parse(attendance.date!))
                                      .toString(),
                                  label: Container(
                                    padding: EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      DateFormat('dd MMMM, yyyy')
                                          .format(
                                              DateTime.parse(attendance.date!))
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class AttendanceDataSource extends DataGridSource {
  AttendanceDataSource(this.attendances, this.course) {
    _rows = course.students!.map<DataGridRow>(
      (e) {
        int totalClasses = attendances.length;
        int studentAttended = 0;
        List<Map<String, dynamic>> studentAttendance = [];

        attendances.forEach((attendance) {
          final presentStudents = attendance.students;
          if (presentStudents!.map((c) => c.studentId).contains(e.studentId)) {
            studentAttended = studentAttended + 1;
            studentAttendance.add({'present': 'P', 'date': attendance.date});
          } else {
            studentAttendance.add({'present': 'A', 'date': attendance.date});
          }
        });

        double studentPercentage = 0.0;

        if (studentAttended == 0 || attendances.isEmpty) {
          studentPercentage = 0.0;
        } else {
          studentPercentage = studentAttended / attendances.length * 100;
        }

        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'id', value: e.studentId),
          DataGridCell<String>(columnName: 'name', value: e.name),
          DataGridCell<String>(
            columnName: 'total_number_of_classes',
            value: attendances.length.toString(),
          ),
          DataGridCell<int>(
              columnName: 'total_attended', value: studentAttended),
          DataGridCell<String>(
              columnName: 'percentage',
              value: '${studentPercentage.toStringAsFixed(2)}%'),
          ...studentAttendance.map(
            (x) => DataGridCell<String>(
                columnName: DateFormat('dd MMMM, yyyy')
                    .format(DateTime.parse(
                      x['date'],
                    ))
                    .toString(),
                value: x['present']),
          ),
        ]);
      },
    ).toList();
  }

  List<DataGridRow> _rows = [];
  final List<AttendanceModel> attendances;
  final CourseModel course;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: Text(
          dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: dataGridCell.value == 'P'
                  ? UIConstants.colors.primaryGreen
                  : dataGridCell.value == 'A'
                      ? UIConstants.colors.primaryRed
                      : UIConstants.colors.primaryTextBlack),
        ),
      );
    }).toList());
  }
}
