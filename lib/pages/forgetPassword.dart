import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<Forgetpassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  bool isOldPasswordVisible = false;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email";
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ScaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Reset Password',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          height: 880,
          child: Form(
            key: passwordFormKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your Email Address',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We will send a verification link to your email',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        showCursor: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: emailValidator,
                        //obscureText: !isOldPasswordVisible,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 400),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 224, 58, 58),
                              borderRadius: BorderRadius.circular(25)),
                          child: MaterialButton(
                            onPressed: () async {
                              if (passwordFormKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: emailController.text);
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.rightSlide,
                                    dialogType: DialogType.success,
                                    body: Center(
                                      child: 
                                      Container(
                                         padding: EdgeInsets.all(10),
                                        child: Text(
                                          'An email was sent to reset your password , please check your inbox',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    title: 'This is Ignored',
                                    desc: 'This is also Ignored',
                                    btnOkOnPress: () {
                                      Navigator.of(context).pop();
                                    },
                                  )..show();
                                } catch (e) {
                                  print(e);
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.rightSlide,
                                    dialogType: DialogType.error,
                                    body: Center(
                                      child: 
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'The email entered does not exist , please enter the correct email.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    title: 'This is Ignored',
                                    desc: 'This is also Ignored',
                                    btnOkOnPress: () {
                                    },
                                  )..show();
                                }
                              }
                            },
                            child: const Text(
                              'Send a Link',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
