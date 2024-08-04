import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../utils/app_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void createAccount() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // First create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Encryption key
        final key = encrypt.Key.fromUtf8('my 32 length key................');
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        // Encrypt the password
        final encryptedPassword = encrypter.encrypt(passwordController.text, iv: iv);

        // Create a new user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'password': encryptedPassword.base64,
        });

        Navigator.pushReplacementNamed(context, '/logIn');
      } else {
        Navigator.pop(context);
        showError('User creation failed.');
      }
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
            //Container That contain the background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/signup.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            //Container that contain the Button and the text
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                child: Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceE,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/fb.png', width: 50, height: 50,),
                          Image.asset('images/google.png', width: 35, height: 35,),
                          Image.asset('images/apple.png',width: 50, height: 50,),
                        ],
                      ),
                      SizedBox(height: 15),
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
                            ' Or continue with Email ',
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
                      SizedBox(height: 40),
                      Column(
                        children: [
                          AppTextField(
                            hintText: 'Enter your name',
                            obscureText: false,
                            contoller: nameController,
                          ),
                          AppTextField(
                            hintText: 'Enter username',
                            obscureText: false,
                            contoller: usernameController,
                          ),
                          AppTextField(
                            hintText: 'Enter email',
                            obscureText: false,
                            contoller: emailController,
                          ),
                          AppTextField(
                            hintText: 'Enter password',
                            obscureText: true,
                            contoller: passwordController,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                fillColor: WidgetStateProperty.all(Colors.white),
                                checkColor: Colors.black,
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: Text(
                                  "I agree with the Terms of Service and Privacy Policy",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: createAccount,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 25),
                                      width: MediaQuery.of(context).size.width/2.2,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Create Account",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20, top: 5),
                                    child: Text("Already have an account?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20, top: 5),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacementNamed(context, '/logIn');
                                      },
                                      child: Text(
                                        "Login",
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
