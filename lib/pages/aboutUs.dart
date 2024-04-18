import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    const String mission =
        'Bellia car care center has a clear mission for Providing  exceptional automotive care and customer service.We deliver exceptional services that go beyond customers’ expectations while providing safety on the road.';
    const String vision =
        'Bellia car care center aims to be a premier destination for automotive care. We strive to be recognized as  the go-to car care center that customers trust and rely on.'
        'We aim to be a trusted leader in automotive care, embracing innovation and making a positive difference in our community.';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        foregroundColor: Colors.white,
        title: Text('About Us',style: TextStyle(fontSize: Dimensions.height25,fontWeight: FontWeight.bold)),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
             ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('5 Boulevard, Al Mandara',style: TextStyle(fontSize: Dimensions.height18,fontWeight: FontWeight.w700)),
            ),
             ListTile(
              leading: const Icon(Icons.textsms),
              title: Text('01097936736',style: TextStyle(fontSize: Dimensions.height18,fontWeight: FontWeight.w700)),
            ),
             SizedBox(height: Dimensions.height20),
            FilledButton(
                onPressed: () {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '01097936736',
                  );
                  launchUrl(launchUri);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 58, 58),
                  minimumSize:  Size(Dimensions.height200, Dimensions.height45)),
                child:  Text('Call Us',style: TextStyle(fontSize: Dimensions.height20,fontWeight: FontWeight.bold),)),
             SizedBox(
              height: Dimensions.height20,
            ),
            SizedBox(
              height: Dimensions.height400,
              child: ListView(
                children: [
                  Text(
                    'Our Mission',
                    style: TextStyle(fontSize: Dimensions.height25, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                   Text(mission, style: TextStyle(fontSize: Dimensions.height18)),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    'Our Vision',
                    style: TextStyle(fontSize: Dimensions.height25, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                   Text(vision, style: TextStyle(fontSize: Dimensions.height18)),
                ],
              ),
            ),
            const Spacer(),
             Row(
              children: [
                const Expanded(
                  child: Divider(
                    endIndent: 20,
                  ),
                ),
                Text('Follow us',style: TextStyle(fontSize: Dimensions.height15,fontWeight: FontWeight.bold),),
                const Expanded(
                    child: Divider(
                  indent: 20,
                )),
              ],
            ),
            SizedBox(
              height: Dimensions.height85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        _launchSocial(
                            'https://www.facebook.com/profile.php?id=61557081369133&mibextid=ZbWKwL');
                      },
                      child:
                          Image.asset('assets/icons/facebook.jpg', height: Dimensions.height40)),
                  // GestureDetector(
                  //   onTap: () {
                  //     try {
                  //       final Uri emailLaunchUri = Uri(
                  //         scheme: 'mailto',
                  //         path: 'belliacar000@gmail.com',
                  //       );
                  //       launchUrl(emailLaunchUri);
                  //     } catch (e) {
                  //       //Handle error
                  //     }
                  //   },
                  //   child: Image.asset(
                  //     'assets/icons/gmail.jpg',
                  //     height: Dimensions.height40,
                  //   ),
                  // ),
                  GestureDetector(
                      onTap: () {
                        _launchSocial(
                            'https://www.instagram.com/belliacarservice?igsh=MTB3ZGk3bWM1aXkwaA==');
                      },
                      child: Image.asset('assets/icons/insta.jpg', height: Dimensions.height40)),
                  GestureDetector(
                      onTap: () {
                        _launchSocial(
                            'https://x.com/BelliaS40801?t=b5upZztBi33rSw8QX76uQA&s=09');
                      },
                      child: Image.asset('assets/icons/x.png', height: Dimensions.height40)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _launchSocial(String url, {String? fallbackUrl}) async {
  try {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  } catch (e) {
    final Uri fallbackUri = Uri.parse(fallbackUrl ?? '');
    await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
  }
}
