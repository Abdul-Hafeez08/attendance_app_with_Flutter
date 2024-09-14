import 'package:attendance_app/LoadingScreen.dart';
import 'package:attendance_app/calanderscreen.dart';
import 'package:attendance_app/profilescreen.dart';
import 'package:attendance_app/todayscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  double screenheight = 0;
  double screenwidth = 0;
  Color primary = const Color(0xffeef444c);
  int currentindex = 1;
  String id = '';
  bool hasData = false;
  List<IconData> navigationIcon = [
    FontAwesomeIcons.calendarDays,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];
  @override
  void initState() {
    super.initState();

    getId();
  }

  void getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("employee")
        .where('id', isEqualTo: User.employeeId)
        .get();
    setState(() {
      User.id = snap.docs[0].id;
      hasData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasData) {
      return LoadingScreen(); // Show the loading screen
    }
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: const [
          CalanderScreen(),
          TodayScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(5, 5),
            )
          ],
        ),
        //const
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcon.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentindex = i;
                      });
                    },
                    child: Container(
                      height: screenheight,
                      width: screenwidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcon[i],
                              color:
                                  i == currentindex ? primary : Colors.black45,
                              size: i == currentindex ? 30 : 27,
                            ),
                            i == currentindex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    height: 3,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
