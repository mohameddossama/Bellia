import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/AccountInfo.dart';
import 'package:fluttercourse/pages/changePass.dart';
//import 'package:fluttercourse/pages/changePhone.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class AccountPage extends StatelessWidget {
    AccountPage({super.key});

    
  List iconName =[
    {"name":"Account info","nav": const AccountInfo()},
    {"name":"Change Password","nav": const ChangePassword()},
    // {"name":"Change Phone Number","nav": const ChangePhone()},
    {"name":"Log Out","nav": const login_page()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
            'Account',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
           CircleAvatar(backgroundImage: AssetImage("assets/icons/person.png"),),
          ],),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>CommerceHome()), (route) => false);
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      body: 
      Center(
        child: 
        Container(
          margin: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.only(top: 60),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: iconName.length,
          itemBuilder:(context, i) {
            return  
            Container(
              margin: const EdgeInsets.symmetric(vertical: 9),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MaterialButton(
                onPressed: () {
                  if(i!=2){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>iconName[i]["nav"]));}
                  else{
                    AwesomeDialog(
                  context: context,
                  animType: AnimType.rightSlide,
                  dialogType: DialogType.warning,
                  body: Center(
                    child: Text(
                      'You are about to Logout , are you sure you want to proceed with this action ?',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: 'This is Ignored',
                  desc: 'This is also Ignored',
                  btnOkOnPress: ()async {
                    await FirebaseAuth.instance.signOut();
                     GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.disconnect();
                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> login_page()), (route) => false);
                  },
                  btnCancelOnPress: () {
                     Navigator.of(context).pop();
                  },
                )..show();
                  }
                  
                },
                child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(iconName[i]["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Icon(Icons.arrow_forward),
                ],
              ),)
            ); 
          },
         
        ),
      ),
    ));
  }
}