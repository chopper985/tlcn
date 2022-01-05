import 'package:flutter/material.dart';
import 'package:flutter_shop_application/models/http_exception.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = new GlobalKey<FormState>();
  // TextEditingController _oldPassController = new TextEditingController();
  TextEditingController _newPassController = new TextEditingController();
  TextEditingController _confirmNewPassController = new TextEditingController();
  bool _isLoading = false;
  bool _isVisibilityTwo = true;
  bool _isVisibilityThree = true;

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
              Provider.of<Auth>(context, listen: false).logOut();
              Provider.of<User>(context, listen: false).logout();
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
            },
          )
        ],
      ),
    );
  }

  tapResetPassword(
      BuildContext context, String token, String _confirmPass) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .resetPassword(_confirmPass, token)
            .then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                    'Change Password Success!',
                    style: TextStyle(color: Colors.white),
                  ))),
                  setState(() {
                    _isLoading = false;
                  }),
                  Navigator.of(context).pop()
                });
      } on HttpException catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('The account has expired, please login again!');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context, listen: false).token;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: _isLoading
            ? Lottie.asset('assets/images/loading_plane_paper.json')
            : Form(
                key: _formkey,
                child: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(
                    height: 38,
                  ),
                  Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _isVisibilityTwo,
                      validator: (val) => val!.trim().length < 6
                          ? 'New password is too short!'
                          : null,
                      controller: _newPassController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: !_isVisibilityTwo
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisibilityTwo = !_isVisibilityTwo;
                            });
                          },
                        ),
                        fillColor: Colors.black,
                        hintText: 'Enter new password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                        labelText: 'New password',
                        prefixIcon: Container(
                            child: new Icon(
                          LineAwesomeIcons.lock,
                          color: Colors.black,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: _isVisibilityThree,
                      validator: (val) => val!.trim().length < 6
                          ? 'Password is too short!'
                          : val.trim() == _newPassController.text
                              ? null
                              : 'Password does not match',
                      controller: _confirmNewPassController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: !_isVisibilityThree
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisibilityThree = !_isVisibilityThree;
                            });
                          },
                        ),
                        fillColor: Colors.black,
                        hintText: 'Enter confirm password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                        labelText: 'Confirm new password',
                        prefixIcon: Container(
                            child: new Icon(
                          LineAwesomeIcons.lock,
                          color: Colors.black,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blue.shade800,
                              Colors.blue.withOpacity(0.7)
                            ]),
                            border: Border.all(width: 2, color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextButton(
                          onPressed: () => tapResetPassword(
                              context, token!, _confirmNewPassController.text),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  )
                ]))));
  }
}
