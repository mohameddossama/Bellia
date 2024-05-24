import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/forgetPassword.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;

  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        await updateUser(user.email, {'password': newPassword});

        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          body: Center(
            child: 
            Container(
               padding: EdgeInsets.all(10),
              child: Text(
                "Password changed successfully",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          btnOkOnPress: () => Navigator.of(context).pop(),
        )..show();
      }
    } catch (error) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        body: Center(
          child: Text(
              'Failed to update password: Incorrect old password.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {},
      )..show();
    }
  }

  void confirmNewPassword() {
    if (passwordFormKey.currentState!.validate()) {
      String newPassword = newPasswordController.text;
      updatePassword(newPassword);
    }
  }

  Future<void> updateUser(
      String? userEmail, Map<String, dynamic> newData) async {
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
      'password': newPasswordController,
    };
    updateUser(FirebaseAuth.instance.currentUser!.email, updatedData);
  }

  @override
  void initState() {
    //fetchOldpassword();
    super.initState();
  }

  String? confirmPasswordValidator(String? value) {
    if (value != newPasswordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  String? newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Change Password',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      body: Center(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Form(
                    key: passwordFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: !isOldPasswordVisible,
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Old Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                isOldPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isOldPasswordVisible = !isOldPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: !isNewPasswordVisible,
                          controller: newPasswordController,
                          validator: newPasswordValidator,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                isNewPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isNewPasswordVisible = !isNewPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: !isNewPasswordVisible,
                          controller: confirmPasswordController,
                          validator: confirmPasswordValidator,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                          onFieldSubmitted: (value) {
                            if (passwordFormKey.currentState!.validate()) {
                              // changePassword();
                              // Navigate to the home page or perform any other actions
                            }
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Forgetpassword()));
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 228, 21, 7)),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 96),
                  Container(
                    alignment: Alignment.center,
                    child: FilledButton(
                      onPressed: () {
                        if (passwordFormKey.currentState!.validate()) {
                          confirmNewPassword();
                          onLoginPressed();
                        }
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const FilledButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(150, 50)),
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromRGBO(255, 0, 0, 1),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
