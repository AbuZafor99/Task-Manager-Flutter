import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/urls.dart' show Urls;
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snacksbar_message.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    // autovalidateMode: AutovalidateMode.always,
                    validator: (String? value) {
                      String email = value ?? "";
                      if (EmailValidator.validate(email) == false) {
                        return "Enter a valid Email.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'First Name'),
                    // autovalidateMode: AutovalidateMode.always,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter your first name.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    // autovalidateMode: AutovalidateMode.always,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter your last name.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneNumberTEController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Phone'),
                    // autovalidateMode: AutovalidateMode.always,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Number is required.";
                      }
                      if (value.trim().length < 11) {
                        return "Enter a valid number (at least 11 digits).";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return "Your password length must be 7 digit";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: _signUpInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSignUpButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  SizedBox(height: 32),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    Map<String, String> requestBody={
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_phoneNumberTEController.text.trim(),
      "password":_passwordTEController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody
    );

    _signUpInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _clearTextField();
      showSnackBarMessage(context, "Registration has been Successful. Please login.");
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _clearTextField(){
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _emailTEController.clear();
    _passwordTEController.clear();
    _phoneNumberTEController.clear();
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _phoneNumberTEController.dispose();
    _lastNameTEController.dispose();
    _emailTEController.dispose();
    super.dispose();
  }
}
