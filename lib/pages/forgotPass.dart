import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/util/dimensions.dart';

// ignore: must_be_immutable
class ForgotPass extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  bool isOldPasswordVisible = false;

  ForgotPass({super.key});

  void resetPassword() {}

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
        body: 
        SingleChildScrollView(
          child: Form(
                key: passwordFormKey,
                child:
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
                const SizedBox(height: 100),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 58, 58),
                        borderRadius: BorderRadius.circular(25)),
                    child: MaterialButton(
                      onPressed: () {
                        if (passwordFormKey.currentState!.validate()) {
                          //resetPassword();
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => const CommerceHome()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "An Email was sent , please check your inbox",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 250, 249, 249),
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.height15),
                                  ),
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                    size: Dimensions.height25,
                                  )
                                ],
                              )));
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
                ),
        )
    );
  }
}

// class FilledButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final Widget child;

//   const FilledButton({
//     Key? key,
//     required this.onPressed,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: child,
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(
//             const Color.fromRGBO(23, 23, 23, 1),
//           ),
//           foregroundColor: MaterialStateProperty.all<Color>(
//             Colors.white,
//           ),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
