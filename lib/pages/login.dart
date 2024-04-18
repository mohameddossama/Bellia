import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/forgotPass.dart';
import 'package:fluttercourse/pages/register.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    if(googleUser==null){return;}

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
                            builder: (context) => ForgotPass()));
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
                      // if (loginFormKey.currentState!.validate()) {
                      //   login();
                      //   Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => const CommerceHome()),
                      //     (Route<dynamic> route) => false,
                      //   );
                      // }
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        if (FirebaseAuth.instance.currentUser!.emailVerified ==
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
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const CommerceHome(),
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
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                'Wrong password provided for that user.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnOkOnPress: () {},
                          )..show();
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
                          fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Container(
                          width: 30,
                          height: 30,
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
                  const SizedBox(height: 20),
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
                            builder: (context) => const Register(),
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
