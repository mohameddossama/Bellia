import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';

List<Map<String, dynamic>> garageTasks = [
  {
    'title': 'Gold',
    'color': Color.fromARGB(255, 211, 172, 57).withOpacity(0.6), // Adjusted color
    'imagePath': 'assets/icons/gold.png',
    'additionalText': [
      ' Washed once every week (interior + exterior)',
      ' Covered with a Special Inflatable Capsule Car Bubble Cover',
      ' Special Routine Check before parking the car',
      ' Rodent prevention',
      ' Car cover by a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel stabilizer)'
    ],
    'starImagePath': 'assets/icons/star.png',
  },
  {
    'title': 'Silver',
    'color': const Color.fromARGB(255, 97, 95, 95).withOpacity(0.6), // Adjusted color
    'imagePath': 'assets/icons/silverm.png',
    'additionalText': [
      ' Washed once every Two weeks (exterior only)',
      ' Fluid checks',
      ' Rodent prevention',
      ' Car coverd with a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel stabilizer)'
    ],
    'starImagePath': 'assets/icons/silver.png',
  },
  {
    'title': 'Bronze',
    'color': Color.fromARGB(255, 114, 47, 25).withOpacity(0.6), // Adjusted color
    'imagePath': 'assets/icons/bronzem.png',
    'additionalText': [
      ' Car cover with a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel, stabilizer)'
    ],
    'starImagePath': 'assets/icons/bronze.png',
  },
];

// Define a class to represent user data
class UserData {
  String firstName;
  String lastName;
  String carName;
  String carModel;
  String mobileNumber;
  List<String> divingLicense;
  String numberOfWeeks;
  String selectedService;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.carName,
    required this.carModel,
    required this.mobileNumber,
    required this.divingLicense,
    required this.numberOfWeeks,
    required this.selectedService,
  });
}

class Garage extends StatefulWidget {
  const Garage({super.key});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    arabicController.dispose();
    numberController.dispose();
    carNameController.dispose();
    carModelController.dispose();
    super.dispose();
  }


  List<String> divingLicenseValues = ["", ""];

  final List<String> weeks =
      List.generate(50, (index) => (index + 1).toString());

  String selectedWeek = '1';
  int selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => const CommerceHome()));
            },
          ),
          title: const Row(
            children: [
              SizedBox(width: 16), // Adjust as needed
              Expanded(
                child: Text(
                  'Garage ',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: garageTasks.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    title: garageTasks[index]['title'],
                    color: garageTasks[index]['color'],
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200,
                    isSelected: selectedCardIndex == index,
                    onSelect: (isSelected) {
                      setState(() {
                        selectedCardIndex = isSelected ? index : -1;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: firstNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: lastNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: carNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Car Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: carModelController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Car Model',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: TextField(
                  controller: mobileNumberController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // const Text(
              //   'Plate Number',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: arabicController,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: InputDecoration(
                        labelText: 'س ب ت',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Arabic value';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        labelText: '5 6 3',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Number of weeks',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton(
                    items: weeks
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    value: selectedWeek,
                    borderRadius: BorderRadius.circular(22),
                    menuMaxHeight: 150,
                    onChanged: (value) {
                      setState(() {
                        selectedWeek = value.toString();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Prepare data to save
                  UserData userData = UserData(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    carName: carNameController.text,
                    carModel: carModelController.text,
                    mobileNumber: mobileNumberController.text,
                    divingLicense: divingLicenseValues,
                    numberOfWeeks: selectedWeek,
                    selectedService: selectedCardIndex != -1
                        ? garageTasks[selectedCardIndex]['title']
                        : '',
                  );

                  // Do whatever you want with userData
                  print(userData);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String title;
  final Color color;
  final double width;
  final double height;
  final bool isSelected;
  final Function(bool isSelected) onSelect;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.color,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isPressed = false; // To track if the card is pressed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(!widget.isSelected);
      },
      onTapDown: (_) {
        setState(() {
          isPressed = true; // Card is pressed
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false; // Finger raised
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false; // Cancel tap
        });
      },
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.green[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: isPressed
          //       ? Colors.red
          //       : (widget.isSelected ? Colors.red : Colors.transparent),
          //   width: 2.0,
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    garageTasks.firstWhere((element) =>
                        element['title'] == widget.title)['imagePath'],
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.color, // Color based on title
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: garageTasks
                  .firstWhere((element) => element['title'] == widget.title)[
                      'additionalText']
                  .map<Widget>((text) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      garageTasks.firstWhere((element) =>
                          element['title'] == widget.title)['starImagePath'],
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        text.substring(1),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: widget.title == 'Gold'
                              ? FontWeight.bold
                              : FontWeight
                                  .bold, // Normal weight for Gold card
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
