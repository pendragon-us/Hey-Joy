import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {

  final String hintText;
  final bool obscureText;
  final contoller;

  const AppTextField({super.key, required this.hintText, required this.obscureText, this.contoller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: contoller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black54,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
