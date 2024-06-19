import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/user_pref.dart';
import '../utils/edit_dialog.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  String userName = 'Loading...';
  String text = 'Type a note here...';

  @override
  void initState() {
    super.initState();
    fetchUserName();
    text = UserPref.getNote();
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
        });
      } else {
        setState(() {
          userName = 'User not found';
        });
      }
    } else {
      setState(() {
        userName = 'No user logged in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController textEditingController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff8eee2),
        body: Column(
          children: [
            //Hello
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Hello
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 70,
                    width: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //User picture
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        width: 150,
                        height: 150,
                        image: AssetImage('images/woman.png'),
                      ),
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.edit),
                      )
                    ],
                  ),
                  //User name
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 70,
                    width: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //About me
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                height: 70,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "About me...",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Type the note here'),
                                      content: TextField(
                                        controller: textEditingController,
                                        decoration: InputDecoration(hintText: 'Enter text here'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Save'),
                                          onPressed: () async {
                                            setState(() {
                                              String editedText = textEditingController.text;
                                              UserPref.setNote(editedText);
                                              text = UserPref.getNote();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: (){
                                FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: (){
                                //Navigator.pushReplacementNamed(context, '/dashboard');
                                Navigator.pop(context);
                              },
                              child: Text("Back",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}