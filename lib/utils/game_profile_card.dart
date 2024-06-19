import 'package:flutter/material.dart';

class GameProfileCard extends StatelessWidget {

  final Color color;
  final String image;
  final String mark;
  final String user;

  const GameProfileCard({
    super.key,
    required this.color,
    required this.image,
    required this.mark,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height/4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(image),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              user,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              mark,
              style: TextStyle(
                  fontSize: 30,
                  color: mark == 'O'
                      ? Colors.blue
                      : mark == 'X'
                      ? Colors.red
                      : Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      )
    );
  }
}
