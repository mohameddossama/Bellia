import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';

// ignore: must_be_immutable
class SubscriptionPage extends StatelessWidget {
  bool isGarageSelected = true;

  SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
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
        title: const Text(
          "Subscription",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      // 
      // PreferredSize(
      //   preferredSize: const Size.fromHeight(100.0),
      //   child: Container(
      //     color: const Color.fromARGB(255, 224, 58, 58),
      //     width: double.infinity,
      //     height: 90,
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: const Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(Icons.arrow_back, color: Colors.white),
      //         SizedBox(width: 10),
      //         Text("Subscription",
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white,
      //             )),
      //       ],
      //     ),
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (isGarageSelected)
              Card(
                margin: const EdgeInsets.all(50),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const ListTile(
                      title: Center(
                        child: Text('Garage',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.grade, color: Colors.amber),
                            SizedBox(width: 5),
                            Text("Gold"),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_month,
                                color: Colors.red.shade800),
                            const SizedBox(width: 5),
                            const Text("Subscription date: 29/2/2024"),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_busy, color: Colors.red.shade800),
                            const SizedBox(width: 5),
                            const Text("Expiration date: 6/3/2024"),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Request a Photo'),
                              content: const Text(
                                  "Would you like the photo to be sent to +201125564479?"),
                              actions: <TextButton>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK',
                                      style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Request a photo',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 224, 58, 58)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            Card(
              margin: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const ListTile(
                    title: Center(
                      child: Text('Car Wash',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Icon(Icons.format_paint, color: Colors.blue),
                          Icon(Icons.cleaning_services, color: Colors.amber),
                          // Icon(Icons.shower, color: Colors.amber),
                          //Icon(Icons.brightness_high, color: Colors.amber),
                          // Icon(Icons.wb_sunny, color: Colors.amber),
                          SizedBox(width: 5),
                          Text("Quick Shine"),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_month,
                              color: Colors.red.shade800),
                          const SizedBox(width: 5),
                          const Text("Subscription Date: 15/2/2024"),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_busy, color: Colors.red.shade800),
                          const SizedBox(width: 5),
                          const Text("Expiration Date: 15/3/2024"),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
