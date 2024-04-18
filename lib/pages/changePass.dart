import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/forgotPass.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

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

  void changePassword() {
    // Implement your logic for changing the password here
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
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
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
        child:
         ListView(
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
                              changePassword();
                              // Navigate to the home page or perform any other actions
                            }
                          },
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () { 
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPass()));
                               },
                              child: const Text("Forgot Password?",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromARGB(255, 228, 21, 7)),))],
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
                          changePassword();
                          // Navigate to the home page or perform any other actions
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
          minimumSize: MaterialStateProperty.all(const Size(150, 50)),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromRGBO(255, 0, 0, 1),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
