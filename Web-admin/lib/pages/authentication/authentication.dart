import 'package:flutter/material.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/auth.dart';
import 'package:tl_web_admin/providers/user.dart';
import 'package:tl_web_admin/routing/routes.dart';
import 'package:tl_web_admin/utils/http_exception.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisibility = true;
  bool _isLoading = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(emailController.text.toString(),
              passwordController.text.toString())
          .then((value) {
        Provider.of<Auth>(context, listen: false).checkRole().then((value) {
          if (value == true) {
            Get.offAllNamed(rootRoute);
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            Provider.of<User>(context, listen: false).logout();
            Provider.of<Auth>(context, listen: false).logOut();
            _showErrorDialog(
                'The account does not have permission to login to the site.');
          }
        });
      });
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(maxWidth: 400, maxHeight: 485),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset("assets/icons/logo.png"),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text("Login",
                              style: GoogleFonts.roboto(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Welcome back to the admin panel.",
                            color: lightGrey,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          if (val.isEmpty || !val.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "abc@domain.com",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty || val.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: isVisibility,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(isVisibility
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isVisibility = !isVisibility;
                                });
                              },
                            ),
                            labelText: "Password",
                            hintText: "123",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (value) {}),
                              CustomText(
                                text: "Remeber Me",
                              ),
                            ],
                          ),
                          CustomText(text: "Forgot password?", color: active)
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: _submit,
                        child: Container(
                          decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CustomText(
                            text: "Login",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
