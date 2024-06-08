import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/forgetPassword.dart';
import 'package:fluttercourse/pages/register.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:fluttercourse/welcome_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => login_pageState();
}

class login_pageState extends State<login_page> {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPass = true;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const CommerceHome(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Row(
        children: [
          Container(
            color: Colors.green,
            child: Icon(
              Icons.check,
              size: Dimensions.height30,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Logged in Successfully",
            style: TextStyle(
                fontSize: Dimensions.height22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
      duration: Duration(seconds: 3),
    ));
  }

  Future<void> updateUser(
      String userEmail, Map<String, dynamic> newData) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userEmail);

      await userDocRef.update(newData);
    } catch (error) {
      print("Error updating user data: $error");
    }
  }

  void onLoginPressed() {
    Map<String, dynamic> updatedData = {
      'password': passwordController.text,
    };
    updateUser(emailController.text, updatedData);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Login success'),
              Icon(
                Icons.check,
                color: Colors.green,
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> checkFirstLaunch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstLaunch = pref.getBool('firstLaunch');

    if (firstLaunch == null || firstLaunch == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CommerceHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //image
                  Center(
                    child: SizedBox(
                      width: 270,
                      height: 270,
                      child: Image.asset(
                        'assets/icons/logo.PNG',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //title
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: 15),
                  //password
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: showPass,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: Icon(
                            showPass
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  //forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Forgetpassword()));
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                    ),
                  ),
                  //login button
                  TextButton(
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                          if (FirebaseAuth
                                  .instance.currentUser!.emailVerified ==
                              false) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              body: Center(
                                child: Center(
                                  child: Text(
                                    'Please check your inbox and verify your account before loging in',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              btnOkOnPress: () {},
                            )..show();
                          } else {
                            onLoginPressed();
                            await checkFirstLaunch();
                            // Navigator.of(context)
                            //     .pushReplacement(MaterialPageRoute(
                            //   builder: (context) => const CommerceHome(),
                            // ));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              content: Row(
                                children: [
                                  Container(
                                    color: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      size: Dimensions.height30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Logged in Successfully",
                                    style: TextStyle(
                                        fontSize: Dimensions.height22,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ],
                              ),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found with that email.');
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              body: Center(
                                child: Text(
                                  'No user found with that email.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              btnOkOnPress: () {},
                            )..show();
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              body: Center(
                                child: Text(
                                  'Wrong password provided.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              btnOkOnPress: () {},
                            )..show();
                          }
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 58, 58),
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // if (loginFormKey.currentState!.validate()) {
                      //   login();
                      //   Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => const CommerceHome()),
                      //     (Route<dynamic> route) => false,
                      //   );
                      // }
                      signInWithGoogle();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Login with Google',
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: Dimensions.height20,
                              color: Colors.white),
                        ),
                        Container(
                          width: Dimensions.widht30,
                          height: Dimensions.height30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/icons/google_icon.PNG"))),
                        )
                      ],
                    ),
                  ),
                  // //google button
                  // FilledButton.icon(
                  //     onPressed: () {},
                  //     style: FilledButton.styleFrom(
                  //       minimumSize: const Size(double.infinity, 50),
                  //     ),
                  //     label: const Text(
                  //       'Signup with Google',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     icon: SizedBox(
                  //         height: 25,
                  //         width: 25,
                  //         child: Image.asset('images/google_icon.PNG'))),
                  //register button
                   SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Registration_page(),
                          ));
                        },
                        child: const Text(
                          'Create one now',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
