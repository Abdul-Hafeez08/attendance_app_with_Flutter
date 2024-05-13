import 'dart:io';
import 'package:attendance_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  Color primary = const Color(0xffeef444c); //Color(0xffeef444c)
  bool isClicked = false;
  bool isClicked1 = false;
  String checkin = "--:--";
  String checkout = "--:--";
  bool isInArea = false;

  @override
  void initState() {
    super.initState();
    checkUserLocation();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("employee")
          .where('id', isEqualTo: User.employeeId)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat(' dd MMMM yyyy').format(DateTime.now()))
          .get();
      setState(() {
        checkin = snap2['checkin'];
        checkout = snap2['checkout'];
      });
    } catch (e) {
      setState(() {
        checkin = "--:--";
        checkout = "--:--";
      });
    }
  }

  Future<void> checkUserLocation() async {
    bool userInArea = await isUserInArea();
    setState(() {
      isInArea = userInArea;
    });
  }

  Future<bool> isUserInArea() async {
    /*
      i block
        double targetLatitude = 26.2304678;
        double targetLongitude = 68.3749919;
    
      karachi
      double targetLatitude = 24.8542128;
      double targetLongitude = 67.0169969;
    */
    double targetLatitude = 26.2304678;
    double targetLongitude = 68.3749919;
    double maxDistance =
        500; // Maximum allowed distance in meters from the target area

    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    double distanceInMeters = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      targetLatitude,
      targetLongitude,
    );

    return distanceInMeters <= maxDistance;
  }

  @override
  Widget build(BuildContext context) {
    if (!isInArea) {
      // Show out-of-area screen
      return Scaffold(
        appBar: AppBar(
          title: const Text('Area Alert'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                strokeWidth: 4.0,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'You Are Out of Area?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),

              // Add spacing
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 35),
                child: const Text(
                  'Welcome,',
                  style: TextStyle(fontSize: 20, color: Colors.black45),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Employee ${User.employeeId}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 25),
                child: const Text(
                  "Today's Status",
                  style: TextStyle(fontSize: 28),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.man, // Replace this with your desired icon
                            color: Colors.black, size: 30,
                          ),
                          const Text(
                            "Check in",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            checkin,
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ), //
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons
                                .directions_walk_outlined, // Replace this with your desired icon
                            color: Colors.black, size: 30,
                          ),
                          const Text(
                            "Check out",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            checkout,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ), //
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style: TextStyle(
                          color: primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text:
                                DateFormat(' MMMM yyyy').format(DateTime.now()),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  );
                },
              ),
              checkout == "--:--"
                  ? Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Add your desired action here

                                //start
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("employee")
                                    .where('id', isEqualTo: User.employeeId)
                                    .get();

                                DocumentSnapshot snap2 = await FirebaseFirestore
                                    .instance
                                    .collection("employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat(' dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .get();

                                try {
                                  String checkin = snap2['checkin'];
                                  setState(() {
                                    //a is extra
                                    checkout = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                  });

                                  await FirebaseFirestore.instance
                                      .collection("employee")
                                      .doc(snap.docs[0].id)
                                      .collection("Record")
                                      .doc(DateFormat(' dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .update({
                                    'date': Timestamp.now(),
                                    'checkin': checkin,
                                    'checkout': DateFormat('hh:mm a')
                                        .format(DateTime.now()),
                                  });
                                } catch (e) {
                                  setState(() {
                                    checkin = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("employee")
                                      .doc(snap.docs[0].id)
                                      .collection("Record")
                                      .doc(DateFormat(' dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .set(
                                    {
                                      'date': Timestamp.now(),
                                      'checkin': DateFormat('hh:mm a')
                                          .format(DateTime.now()),
                                      'checkout': "--:--",
                                    },
                                  );
                                }

                                setState(() {
                                  isClicked = !isClicked;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    isClicked ? Colors.red : Colors.green,
                                fixedSize: const Size(
                                    300, 45), // Set the button color to red
                              ),
                              child: Text(
                                checkin == "--:--"
                                    ? "Click to Check in "
                                    : "Click to Check out",
                                style: TextStyle(
                                    color: checkin == "--:--"
                                        ? Colors.white
                                        : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Column(
                        children: [
                          Text(
                            "You Have Completed This Day",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 1), // Add some space between the texts
                          Text(
                            "Good Afternoon",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ), //end button
            ],
          ),
        ),
      ); //Scaffold}
    }
  }
}
