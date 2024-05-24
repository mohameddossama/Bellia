import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttercourse/pages/login.dart';
import 'package:fluttercourse/util/imageUrlProvider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' ;



// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("=============== background message ===============");
//   print("title: ${message.notification!.title}");
//   print("title: ${message..notification!.body}");
//   // print("title: ${message.data}");
// }

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(ChangeNotifierProvider(
      create: (_) => ImageUrlProvider(),
      child: MyApp(),
    ),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  List<String> imgs = [
    "images/pic.PNG",
    "images/pic.PNG",
    "images/pic.PNG",
    "images/pic.PNG",
    "images/pic.PNG",
  ];

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=================\nUser is currently signed out!');
      } else {
        print('=================\nUser is signed in!');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("current height is"+MediaQuery.of(context).size.width.toString());
    print("current height is"+MediaQuery.of(context).size.height.toString());
    return GetMaterialApp(
      // title: 'Belia Cars Services',
       debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 224, 58, 58),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 35, 35, 35),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: const Color(0xFFF2F2F6),
          contentPadding: const EdgeInsets.only(left: 15),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 155, 21, 21), width: 2),
            borderRadius: BorderRadius.circular(25.0),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Color.fromARGB(255, 2, 1, 1))),
        ),
      ),
        home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? CommerceHome() : login_page()
        );
  }
}

