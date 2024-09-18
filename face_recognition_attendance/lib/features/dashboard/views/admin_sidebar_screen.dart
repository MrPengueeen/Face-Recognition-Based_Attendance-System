import 'package:face_recognition_attendance/features/admin/views/student_management_screen.dart';
import 'package:face_recognition_attendance/features/attendance/views/attendance_screen.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_management_screen.dart';
import 'package:face_recognition_attendance/features/course_management/views/course_management_screen.dart';

import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';

import 'package:sidebarx/sidebarx.dart';

class AdminSidebarScreen extends StatefulWidget {
  const AdminSidebarScreen({super.key});

  @override
  State<AdminSidebarScreen> createState() => _AdminSidebarScreenState();
}

class _AdminSidebarScreenState extends State<AdminSidebarScreen> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller.setExtended(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: _key,
      backgroundColor: UIConstants.colors.primaryWhite,
      body: Row(
        children: [
          SidebarX(
            controller: _controller,
            footerBuilder: (ctx, child) {
              return ListTile(
                trailing: const Icon(Icons.logout),
                title: (_controller.extended) ? const Text('Professor') : null,
                onTap: () {
                  Navigator.pop(context);
                },
              );
            },
            theme: SidebarXTheme(
              decoration: BoxDecoration(
                  color: UIConstants.colors.primaryWhite,
                  // border: Border.all(
                  //   color: UIConstants.colors.primaryPurple,
                  //   width: 2,
                  // ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              iconTheme: IconThemeData(
                color: UIConstants.colors.backgroundPurple,
              ),
              hoverIconTheme: theme.iconTheme.copyWith(color: Colors.red),
              hoverColor: Colors.red,
              selectedItemTextPadding: const EdgeInsets.only(left: 30),
              itemTextPadding: const EdgeInsets.only(left: 30),
              selectedTextStyle: const TextStyle(color: Colors.white),
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 20,
              ),
              selectedItemDecoration: BoxDecoration(
                color: UIConstants.colors.backgroundPurple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            extendedTheme: const SidebarXTheme(width: 250),
            footerDivider:
                Divider(color: Colors.black.withOpacity(0.8), height: 1),
            headerBuilder: (context, extended) {
              return SizedBox(
                height: 100,
                child: Image.asset('assets/images/app_logo.png'),
              );
            },
            items: const [
              SidebarXItem(
                icon: Icons.checklist,
                label: 'Teachers Management',
              ),
              SidebarXItem(
                icon: Icons.assignment_sharp,
                label: 'Student Management',
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  switch (_controller.selectedIndex) {
                    case 0:
                      // if (_controller.extended) {
                      //   Future.delayed(Duration(milliseconds: 100), () {
                      //     _controller.setExtended(false);
                      //   });
                      // }
                      return const Center(
                        child: Text('Teacher Management'),
                      );
                    case 1:
                      // if (_controller.extended) {
                      //   Future.delayed(Duration(milliseconds: 100), () {
                      //     _controller.setExtended(false);
                      //   });
                      // }
                      return const Center(
                        child: StudentManagementScreen(),
                      );

                    default:
                      return const Center(
                        child: Text(
                          'Teacher Management',
                          style: TextStyle(fontSize: 40),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
