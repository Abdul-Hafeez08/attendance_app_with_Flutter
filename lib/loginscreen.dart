import 'package:attendance_app/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController idcontroler = TextEditingController();
  TextEditingController passcontroler = TextEditingController();

  double screenheight = 0;
  double screenwidth = 0;
  Color primary = const Color(0xffeef444c);
  late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(height: screenheight / 20)
              : Container(
                  height: screenheight / 3,
                  width: screenwidth,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      )),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenwidth / 5,
                    ),
                  ),
                ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 30),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: screenwidth / 10,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldtitle("Employee ID"),
                costumField("Enter Employee ID", idcontroler),
                fieldtitle("Password"),
                costumField2("Enter Password", passcontroler),
                GestureDetector(
                  onTap: () async {
                    String id = idcontroler.text.trim();
                    String password = passcontroler.text.trim();

                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Employee ID is still Empty'),
                        ),
                      );
                    } else if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password Field Empty'),
                        ),
                      );
                    } else {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("employee")
                          .where('id', isEqualTo: id)
                          .get();
                      try {
                        if (password == snap.docs[0]['password']) {
                          sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences
                              .setString('employeeid', id)
                              .then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const homescreen(),
                              ),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("password is wrong"),
                            ),
                          );
                        }
                      } catch (e) {
                        String error = " ";
                        if (e.toString() ==
                            "RangeError (index): Invalid value: Valid value range is empty: 0") {
                          setState(
                            () {
                              error = "Employee Id does not Exist";
                            },
                          );
                        } else {
                          setState(() {
                            error = "Error occured";
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    height: 50,
                    width: screenwidth,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldtitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenwidth / 23,
        ),
      ),
    );
  }

  Widget costumField(String hint, TextEditingController controller) {
    return Container(
      width: screenwidth,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenwidth / 12,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenwidth / 14,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenwidth / 15),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget costumField2(String hint, TextEditingController controller) {
    return Container(
      width: screenwidth,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenwidth / 12,
            child: Icon(
              Icons.lock,
              color: primary,
              size: screenwidth / 16,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenwidth / 15),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
