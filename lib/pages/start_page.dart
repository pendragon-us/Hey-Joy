import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffae8cc9),
        body: Stack(
          children: [
            //Container That contain the background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/start.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            //Container that contain the Button and the text
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Sign Up Button
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 250),
                        width: MediaQuery.of(context).size.width/1.5,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    //Already have an account? Login Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/logIn');
                          },
                          child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}