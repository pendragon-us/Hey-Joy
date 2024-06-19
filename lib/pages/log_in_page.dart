import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_text_field.dart';
import 'dashboard.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMsg = '';

  void logIn() async{
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showError(e.code);
    }
  }

  void showError(String error){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title:  Center(child: Text(error)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.all(20),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffae8cc9),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            //This container contains the background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/login.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            //This container contains the main UI of the application
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
                child: Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceE,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ),
                          ),
                          Text(
                            ' Or login with Email ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      Column(
                        children: [
                          Column(
                            children: [
                              //user name or email
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Username or Email $errorMsg',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  AppTextField(
                                    hintText: '',
                                    obscureText: false,
                                    contoller: emailController,
                                  ),
                                ],
                              ),
                              //password
                              Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 35),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Forgot?',
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  AppTextField(
                                    hintText: '',
                                    obscureText: true,
                                    contoller: passwordController,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              //Sign In Button
                              GestureDetector(
                                  onTap: logIn,
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width/2,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),

                          SizedBox(height: 60),
                          //don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 35, top: 5),
                                    child: Text("Don't have an account?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 35, top: 5),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacementNamed(context, '/signUp');
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
