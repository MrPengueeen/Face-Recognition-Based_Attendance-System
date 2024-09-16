import 'package:face_recognition_attendance/features/attendance/views/attendance_screen.dart';
import 'package:face_recognition_attendance/features/attendance_management/views/attendance_management_screen.dart';
import 'package:face_recognition_attendance/features/course_management/views/course_management_screen.dart';

import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/material.dart';

import 'package:sidebarx/sidebarx.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
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
                label: 'Attendance',
              ),
              SidebarXItem(
                icon: Icons.assignment_sharp,
                label: 'Attendance Management',
              ),
              SidebarXItem(
                icon: Icons.people,
                label: 'Course Management',
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
                        child: AttendanceScreen(),
                      );
                    case 1:
                      // if (_controller.extended) {
                      //   Future.delayed(Duration(milliseconds: 100), () {
                      //     _controller.setExtended(false);
                      //   });
                      // }
                      return const Center(
                        child: AttendanceManagementScreen(),
                      );
                    case 2:
                      // if (_controller.extended) {
                      //   Future.delayed(Duration(milliseconds: 100), () {
                      //     _controller.setExtended(false);
                      //   });
                      // }
                      return const Center(
                        child: CourseManagementScreen(),
                      );

                    default:
                      return const Center(
                        child: Text(
                          'Attendance',
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


// class SidebarScreen extends StatefulWidget {
//   @override
//   _SidebarScreenState createState() => _SidebarScreenState();
// }

// class _SidebarScreenState extends State<SidebarScreen> {
//   late List<CollapsibleItem> _items;
//   late String _headline;
//   AssetImage _avatarImg = AssetImage('assets/images/app_logo.png');

//   @override
//   void initState() {
//     super.initState();
//     _items = _generateItems;
//     _headline = _items.firstWhere((item) => item.isSelected).text;
//   }

//   List<CollapsibleItem> get _generateItems {
//     return [
//       CollapsibleItem(
//         text: 'Attendance',
//         icon: Icons.checklist,
//         isSelected: true,
//         onPressed: () => setState(() => _headline = 'Attendance'),
//         onHold: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content:
//                 const Text("Conduct an attendance of any registered course"))),
//       ),
//       CollapsibleItem(
//         text: 'Attendance Management',
//         icon: Icons.summarize_rounded,
//         onPressed: () => setState(() => _headline = 'Attendance Management'),
//         onHold: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: const Text("Manage and summarize attendance reports"))),
//       ),
//       CollapsibleItem(
//         text: 'Course Management',
//         icon: Icons.people_alt_rounded,
//         onPressed: () => setState(() => _headline = 'Course Management'),
//         onHold: () => ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: const Text("Manage and customize courses"))),
//       ),
//       CollapsibleItem(
//         text: 'Logout',
//         icon: Icons.logout,
//         onPressed: () => setState(() => _headline = 'Logout'),
//         onHold: () => ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: const Text("Logout"))),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         body: 
//       ),
//     );
//   }

//   Widget _body(Size size, BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       color: Colors.blueGrey[50],
//       child: Center(
//         child: Transform.rotate(
//           angle: math.pi / 2,
//           child: Transform.translate(
//             offset: Offset(-size.height * 0.3, -size.width * 0.23),
//             child: Text(
//               _headline,
//               style: Theme.of(context).textTheme.displayLarge,
//               overflow: TextOverflow.visible,
//               softWrap: false,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// CollapsibleSidebar(
//           badgeBackgroundColor: UIConstants.colors.primaryWhite,
          
//           maxWidth: 400,
//           isCollapsed: MediaQuery.of(context).size.width <= 800,
//           items: _items,
//           collapseOnBodyTap: false,
//           avatarImg: _avatarImg,
//           title: 'Professor Heisenberg',
//           body: _body(size, context),
//           backgroundColor: Colors.black,
//           selectedTextColor: Colors.limeAccent,
//           textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
//           titleStyle: TextStyle(
//               fontSize: 20,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold),
//           toggleTitleStyle:
//               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           sidebarBoxShadow: [
//             BoxShadow(
//               color: Colors.indigo,
//               blurRadius: 20,
//               spreadRadius: 0.01,
//               offset: Offset(3, 3),
//             ),
//             BoxShadow(
//               color: Colors.green,
//               blurRadius: 50,
//               spreadRadius: 0.01,
//               offset: Offset(3, 3),
//             ),
//           ],
//         ),

// 