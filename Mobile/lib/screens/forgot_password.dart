import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController _emailController = new TextEditingController();
  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

  tapResetPassword(String email) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
              'Please check gmail and change your password!',
              style: TextStyle(color: Colors.white),
            ))),
            Navigator.pop(context),
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
          'Account does not exist! Please re-enter!',
          style: TextStyle(color: Colors.white),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                    child: Text(
                  'Recover forgotten password!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextFormField(
                  validator: (val) => val!.trim().length == 0
                      ? 'Please enter your email!'
                      : null,
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.black,
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.5,
                    ),
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black, width: 1)),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade800,
                      Colors.blue.withOpacity(0.7)
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 7.h,
                  width: 40.w,
                  child: TextButton(
                      onPressed: () => tapResetPassword(_emailController.text),
                      child: Text(
                        'Send request',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
