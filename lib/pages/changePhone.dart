import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({super.key});

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void login() {
    // Implement your login logic here
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      Navigator.pop(context);
    });
  }
  // ignore: non_constant_identifier_names
  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Change Phone',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      body: Center(
        child: 
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Form(
                    key: loginFormKey,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // return "Please Enter Phone Number";
                        } else if (value.length != 11) {
                          return "Enter Valid Phone Number (11 digits)";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'New Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                  const SizedBox(height: 250), // Add padding below the text field
                  Container(
                    alignment: Alignment.center,
                    child: FilledButton(
                      onPressed: () {
                        if (loginFormKey.currentState!.validate()) {
                          login();
        
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                              textColor: Colors.red,
                              label: "Home Page", onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => CommerceHome(),
                            ),
                            (route) => false
                            
                          );
                            }),
                            duration: const Duration(seconds: 2),
                            content: const Text("your phone number was succesfully changed")));
                        }
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Add padding above the button
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
      child: TextButton(
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your home page UI here
    return Container();
  }
}
