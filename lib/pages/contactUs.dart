import 'package:flutter/material.dart';
//import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);


  Future<void> _launchPhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '0122446449',
    );

    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _launchFacebookUrl() async {
    final Uri facebookUrl = Uri.parse('https://www.facebook.com/profile.php?id=61557081369133&mibextid=ZbWKwL');
    if (!await launchUrl(facebookUrl)) {
      throw 'Could not launch $facebookUrl';
    }
  }

  Future<void> _launchInstagramUrl() async {
    final Uri instagramUrl = Uri.parse('https://www.instagram.com/belliacarservice?igsh=MTB3ZGk3bWM1aXkwaA==');
    if (!await launchUrl(instagramUrl)) {
      throw 'Could not launch $instagramUrl';
    }
  }

  Future<void> _launchTwitterUrl() async {
    final Uri twitterUrl = Uri.parse('https://x.com/BelliaS40801?t=b5upZztBi33rSw8QX76uQA&s=09');
    if (!await launchUrl(twitterUrl)) {
      throw 'Could not launch $twitterUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                 Navigator.of(context).pop();
              },
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          ),
          body:SingleChildScrollView(
            child:
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "If you'd like to send us your feedback, express any complaints"
                      'or have any inquiries, kindly reach out to us on our social media channels:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.questrial().fontFamily,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Facebook:",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.questrial().fontFamily,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Tooltip(
                      message: 'https://www.facebook.com/profile.php?id=61557081369133&mibextid=ZbWKwL',
                      child: GestureDetector(
                        onTap: _launchFacebookUrl,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            ' https://www.facebook.com/profile.php?id=61557081369133&mibextid=ZbWKwL',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 224, 58, 58),
                              decoration: TextDecoration.underline,
                              fontFamily: GoogleFonts.questrial().fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Instagram:",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.questrial().fontFamily,
                      ),
                    ),
                   const SizedBox(width: 3),
                    Tooltip(
                      message: 'https://www.instagram.com/belliacarservice?igsh=MTB3ZGk3bWM1aXkwaA==',
                      child: GestureDetector(
                        onTap: _launchInstagramUrl,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            ' https://www.instagram.com/belliacarservice?igsh=MTB3ZGk3bWM1aXkwaA==',
                            style: TextStyle(
                              fontSize: 15,
                              color:const Color.fromARGB(255, 224, 58, 58),
                              decoration: TextDecoration.underline,
                              fontFamily: GoogleFonts.questrial().fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Twitter:",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: GoogleFonts.questrial().fontFamily,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Tooltip(
                      message: 'https://x.com/BelliaS40801?t=b5upZztBi33rSw8QX76uQA&s=09',
                      child: GestureDetector(
                        onTap: _launchInstagramUrl,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            ' https://x.com/BelliaS40801?t=b5upZztBi33rSw8QX76uQA&s=09',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 224, 58, 58),
                              decoration: TextDecoration.underline,
                              fontFamily: GoogleFonts.questrial().fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  child:
                  Text(
                    'You can also contact us via email: BelliaCarCare@gmail.com',
                    style:
                    TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.questrial().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child:
                  Text(
                    'For complaints or feedback, kindly call or Whatsapp on 01097936736',
                    style:
                    TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.questrial().fontFamily,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _launchPhoneCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:const Color.fromARGB(255, 224, 58, 58),
                    ),
                    child: Text('Call Us', style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.questrial().fontFamily,
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Our office hours are 8 am - 10 pm on weekdays. All inquiries will be attended to within one working day.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.questrial().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontFamily: GoogleFonts.questrial().fontFamily,
                      ),
                      children: [
                        TextSpan(
                            text: 'To avoid duplicated requests and miscommunication, kindly use just one of these channels to reach out to us.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'FIND US',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          fontFamily: GoogleFonts.questrial().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 10),
                                Text(
                                  '5 Boulevard, Al Mandara',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: GoogleFonts.questrial().fontFamily,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
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

Future<void> _launchPhoneCall() async {
  final Uri phoneUri = Uri(
    scheme: 'tel',
    path: '01122446449',
  );

  if (!await launchUrl(phoneUri)) {
    throw 'Could not launch $phoneUri';
  }
}
