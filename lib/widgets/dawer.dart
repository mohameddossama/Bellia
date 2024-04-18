import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttercourse/pages/aboutUs.dart';
import 'package:fluttercourse/pages/aboutUs.dart';
import 'package:fluttercourse/pages/login.dart';
import 'package:fluttercourse/pages/my_cars.dart';
//import 'package:fluttercourse/commerceHome.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/pages/accountPage.dart';
import 'package:fluttercourse/pages/subscriptionPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class DrawerNig extends StatelessWidget {
  DrawerNig({super.key});

  List drawItems = [
    {"icon": Icons.account_box, "name": "Account", "nav": AccountPage()},
    {"icon": Icons.local_shipping, "name": "orders", "nav": const orderPage()},
    {
      "icon": Icons.label_important,
      "name": "Subscriptions",
      "nav": SubscriptionPage()
    },
    {"icon": Icons.car_repair, "name": "My Cars", "nav": const MyCars()},
    {"icon": Icons.info, "name": "About Us", "nav": const AboutUs()},
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor:const Color.fromARGB(255, 224, 58, 58) ,
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 224, 58, 58)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/icons/person.png"),
                  // child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(90),
                  //     child: Image.asset(
                  //       "images/me.jpg",
                  //       fit: BoxFit.fill,
                  //     )),
                ),
                accountName: Text("Mohamed Ali"),
                accountEmail: Text("Mohamed@gmail.com")),
            // ListTile(
            //     title: const Text("Home Page"),
            //     leading: const Icon(Icons.home),
            //     onTap: () {
            //       Navigator.of(context).pushReplacement(MaterialPageRoute(
            //           builder: (context) => const CommerceHome()));
            //     }),
            // const SizedBox(height: 1),
            ...List.generate(drawItems.length, (i) {
              return ListTile(
                title: Text(drawItems[i]["name"]),
                leading: Icon(drawItems[i]["icon"]),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => drawItems[i]["nav"],
                  ));
                },
              );
            }),

            // Container(
            //   padding: EdgeInsets.zero,
            //   height: 353,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics:
            //         const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            //     itemCount: drawItems.length,
            //     itemBuilder: (context, i) {
            //       return ListTile(
            //         title: Text(drawItems[i]["name"]),
            //         leading: Icon(drawItems[i]["icon"]),
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => drawItems[i]["nav"]));
            //         },
            //       );
            //     },
            //   ),
            // ),
            ListTile(
              title: const Text("Log Out"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
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
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: const Text("Warning"),
                //         content: const Text(
                //             "You are about to Logout , are you sure you want to proceed with this action ?"),
                //         actions: [
                //           TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pushReplacement(
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             const login_page()));
                //               },
                //               child: const Text("Logout")),
                //           TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //               child: const Text("Cancel")),
                //         ],
                //       );
                //     });
              },
            ),
          ]),
    );
  }
}
