import 'package:face_recognition_attendance/features/authentication/controller/authentication_controller.dart';
import 'package:face_recognition_attendance/features/authentication/utils/shared_widgets.dart';
import 'package:face_recognition_attendance/features/dashboard/views/admin_sidebar_screen.dart';
import 'package:face_recognition_attendance/features/dashboard/views/sidebar_screen.dart';
import 'package:face_recognition_attendance/ui_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: UIConstants.colors.backgroundPurple,
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: height * 0.8,
          width: width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: UIConstants.colors.primaryWhite,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/login_art2.jpg',
                  height: height * 0.8,
                  width: width * 0.35,
                  fit: BoxFit.fitHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: UIConstants.colors.backgroundGrey,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          width: width * 0.3,
                          height: height * 0.84,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: UIConstants.colors.primaryWhite,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset('assets/images/app_logo.png',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.fitHeight),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Welcome back, professor!',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: UIConstants.colors.primaryTextBlack),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SimpleTextField(
                                hintText: 'Email',
                                labelText: 'Email',
                                prefixIconData: Icons.email_outlined,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                textColor: Colors.black,
                                accentColor: UIConstants.colors.primaryPurple,
                                textEditingController: _emailCont,
                                validator: (value) {
                                  if (value.isEmpty) return false;
                                  return true;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SimpleTextField(
                                hintText: 'Password',
                                labelText: 'Password',
                                prefixIconData: Icons.password,
                                obscureText: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                textColor: Colors.black,
                                accentColor: UIConstants.colors.primaryPurple,
                                textEditingController: _passCont,
                                validator: (value) {
                                  if (value.isEmpty) return false;
                                  return true;
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Checkbox(
                                      value: isAdmin,
                                      onChanged: (value) {
                                        setState(() {
                                          isAdmin = value!;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text('Login as admin'),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (isLoading) return;
                                  onLoginButtonPresed();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      UIConstants.colors.primaryPurple,
                                  minimumSize: Size(width * 0.3, 65),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: UIConstants
                                                .colors.primaryWhite),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onLoginButtonPresed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final controller = AuthenticationController();

      try {
        if (isAdmin) {
          await controller.loginAsAdmin(
              _emailCont.text, _passCont.text, 'admin');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const AdminSidebarScreen()),
              (Route<dynamic> route) => false);
        } else {
          await controller.login(_emailCont.text, _passCont.text, 'teacher');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SidebarScreen()),
              (Route<dynamic> route) => false);
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: UIConstants.colors.primaryGreen,
            duration: const Duration(seconds: 4),
            content: Text(
              "Login Successful!",
              style: TextStyle(
                  fontSize: 20, color: UIConstants.colors.primaryWhite),
            )));
      } catch (error) {
        print('In screen error');
        print(error.toString());
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: UIConstants.colors.primaryRed,
            duration: const Duration(seconds: 4),
            content: Text(
              error.toString(),
              style: TextStyle(
                  fontSize: 20, color: UIConstants.colors.primaryWhite),
            )));
      }
    }
  }
}
