import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/belliaMart.dart';
import 'package:fluttercourse/pages/carTow.dart';
import 'package:fluttercourse/pages/carWash.dart';
import 'package:fluttercourse/pages/garage.dart';
import 'package:fluttercourse/pages/roadSideAssistance.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:fluttercourse/widgets/dawer.dart';
import 'package:fluttercourse/pages/maintenance.dart';

class CommerceHome extends StatefulWidget {
  const CommerceHome({super.key});

  @override
  State<CommerceHome> createState() => _CommerceHomeState();
}

class _CommerceHomeState extends State<CommerceHome> {
  List mostPopular = [
    {
      "image": "assets/icons/brake.png",
      "name": "Brake inspection ",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/carCooling.png",
      "name": "Engin Cooling",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/tire.png",
      "name": "Tire Repair",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/battery.png",
      "name": "battery inspection",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/suspentions.png",
      "name": "Supentions inspection",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/routine.png",
      "name": "Routine Check",
      "nav": const Maintenance()
    },
  ];

  List categories = [
    {
      "image": "assets/icons/roadside.png",
      "service": "roadside \n    help",
      "nav": RoadSideAssistance(subAdministrativeArea: '', street: '',)
    },
    {
      "image": "assets/icons/washing.png",
      "service": "Car Wash",
      "nav": const CarWash()
    },
    {
      "image": "assets/icons/maintenance.png",
      "service": "        Car\nMaintenacne",
      "nav": const Maintenance()
    },
    {
      "image": "assets/icons/garage.png",
      "service": "garage",
      "nav": const Garage()
    },
    {
      "image": "assets/icons/belliaMart.png",
      "service": "Bellia Mart",
      "nav":  BelliaMart()
    },
    {
      "image": "assets/icons/towing.png",
      "service": "Car Tow",
      "nav":  CarTow(subAdministrativeArea: '', street: '',)
    },
  ];

  List dealsImages = [
    {"image": "assets/images/delivery1.png", "nav":  BelliaMart()},
    {"image": "assets/images/washpromo1.png", "nav": const CarWash()},
    {"image": "assets/images/delivery2.png", "nav": BelliaMart()},
    {"image": "assets/images/repairpromo.png", "nav": const Maintenance()},
  ];

  List tipsImages = [
    {"image": "assets/images/tip1.png"},
    {"image": "assets/images/tip2.png"},
    {"image": "assets/images/tip3.png"},
    {"image": "assets/images/tip4.png"},
    {"image": "assets/images/tip5.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      endDrawer: DrawerNig(),
      body: Container(
          padding: const EdgeInsets.all(9.5),
          child: ListView(
            children: [
              // Row(children: [
              //   Expanded(
              //       child: TextFormField(
              //     decoration: InputDecoration(
              //         border: InputBorder.none,
              //         fillColor: Colors.grey[200],
              //         filled: true,
              //         prefixIcon: const Icon(Icons.search),
              //         hintText: "Search"),
              //   )),
              //   // const Padding(
              //   //   padding: EdgeInsets.only(left: 20),
              //   //   child: Icon(
              //   //     Icons.menu,
              //   //     size: 40,
              //   //   ),
              //   // )
              // ]),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: const [
              //           BoxShadow(
              //             color: Color.fromARGB(255, 134, 130, 130),
              //             blurRadius: 4.0,
              //             offset: Offset(0, 5)
              //           ),
              //           BoxShadow(
              //             color: Colors.white,
              //             blurRadius: 5.0,
              //             offset: Offset(-5, 0)
              //           ),
              //           BoxShadow(
              //             color: Colors.white,
              //             blurRadius: 5.0,
              //             offset: Offset(5, 0)
              //           )
              //         ],
              //         color: const Color.fromARGB(255, 247, 63, 63),
              //       ),
              //       padding: const EdgeInsets.all(8),
              //       margin: const EdgeInsets.only(bottom: 13),
              //       child: const Text(
              //         "Flash offers",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Container(
                  margin: EdgeInsets.only(top: Dimensions.height10),
                  decoration: BoxDecoration(
                      //color: const Color.fromARGB(255, 199, 199, 199),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 134, 130, 130),
                            blurRadius: 4.0,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(-5, 0)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(5, 0))
                      ]),
                  height: 250,
                  child: PageView.builder(
                    itemCount: dealsImages.length,
                    itemBuilder: (context, index) {
                      return MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    dealsImages[index]["nav"]));
                          },
                          child: _buildDealsPageItem(index));
                    },
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 134, 130, 130),
                            blurRadius: 4.0,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(-5, 0)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(5, 0))
                      ],
                      color: const Color.fromARGB(255, 247, 63, 63),
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    child: const Text(
                      "Most popular",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 138,
                child: ListView.builder(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  scrollDirection: Axis.horizontal,
                  itemCount: mostPopular.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 70,
                          width: 75,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 199, 199, 199),
                              borderRadius: BorderRadius.circular(100)),
                          child: MaterialButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Maintenance()));
                              },
                              child: Image.asset(
                                mostPopular[i]["image"],
                                height: 42,
                                fit: BoxFit.fill,
                              ))),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 55,
                        child: Text(mostPopular[i]["name"],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.height15,
                                overflow: TextOverflow.ellipsis)),
                      )
                    ]);
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 134, 130, 130),
                            blurRadius: 4.0,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(-5, 0)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(5, 0))
                      ],
                      color: const Color.fromARGB(255, 247, 63, 63),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 4),
                    child: const Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: Dimensions.gridViewContainer,
                child: GridView.builder(
                  physics: const ScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 199, 199, 199),
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => categories[i]["nav"]));
                            },
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    categories[i]["image"],
                                    height: 49,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    categories[i]["service"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  )
                                ])));
                  },
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 134, 130, 130),
                            blurRadius: 4.0,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(-5, 0)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(5, 0))
                      ],
                      color: const Color.fromARGB(255, 247, 63, 63),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 0, bottom: 15),
                    child: const Text(
                      "Bellia Tip of the day",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 41, 34, 34),
                            blurRadius: 1.0,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(-5, 0)),
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                            offset: Offset(5, 0))
                      ]),
                  height: 210,
                  child: PageView.builder(
                    itemCount: tipsImages.length,
                    itemBuilder: (context, index) {
                      return _buildTipsPageItem(index);
                    },
                  ))
            ],
          )),
    );
  }

  Widget _buildDealsPageItem(int index) {
    return Stack(
      children: [
        Container(
          //margin: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    dealsImages[index]["image"],
                  ))),
        )
      ],
    );
  }

  Widget _buildTipsPageItem(int index) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    tipsImages[index]["image"],
                  ))),
        )
      ],
    );
  }
}
