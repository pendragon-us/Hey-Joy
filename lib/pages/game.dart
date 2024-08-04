import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_joy_application/data/game_pref.dart';

import '../utils/game_profile_card.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> displayXO = ['','','','','','','','',''];
  bool isO = true;
  bool gameActive = true;
  String userBestTime = '00:00';
  DateTime? gameStartTime;
  bool isComputerThinking = false;


  @override
  void initState() {
    super.initState();
    _loadBestTime();
  }

  Future<void> _loadBestTime() async {
    await GamePref.init();
    setState(() {
      userBestTime = GamePref.getGameData();
    });
  }

  void tapped(int index) {
    if (!gameActive || displayXO[index] != '') return;

    setState(() {
      gameStartTime ??= DateTime.now();
      displayXO[index] = 'X'; // User's move
      isO = !isO;
      if (!checkWinner('X')) {
        isComputerThinking = true;
        Future.delayed(Duration(seconds: 1), () { // Add this line
          computerMove();
          isComputerThinking = false;
        });
      }
    });
  }

  void computerMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == '') {
        emptyIndices.add(i);
      }
    }

    if (emptyIndices.isNotEmpty) {
      int randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];
      setState(() {
        displayXO[randomIndex] = 'O';
        isO = !isO;
        checkWinner('O');
      });
    }
  }

  bool checkWinner(String player) {
    // Winning combinations
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (List<int> combo in winningCombinations) {
      if (displayXO[combo[0]] == player &&
          displayXO[combo[1]] == player &&
          displayXO[combo[2]] == player) {
        gameActive = false;
        if (player == 'X') {
          calculateAndDisplayTime();
        }
        showWinnerDialog(player);
        return true;
      }
    }

    if (!displayXO.contains('')) {
      gameActive = false;
      showWinnerDialog(null);
    }

    return false;
  }

  void calculateAndDisplayTime() {
    if (gameStartTime != null) {
      final duration = DateTime.now().difference(gameStartTime!);
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      final currentTime = '$minutes:$seconds';

      // Check if the current time is better than the best time
      _compareAndSaveBestTime(currentTime);
    }
  }

  Future<void> _compareAndSaveBestTime(String currentTime) async {
    final bestTime = GamePref.getGameData();

    if (bestTime == 'No BestTime' || _isCurrentTimeBetter(currentTime, bestTime)) {
      await GamePref.saveGameData(currentTime);
      setState(() {
        userBestTime = currentTime;
      });
    }
  }

  bool _isCurrentTimeBetter(String currentTime, String bestTime) {
    final currentDuration = _parseTime(currentTime);
    final bestDuration = _parseTime(bestTime);

    return currentDuration < bestDuration;
  }

  Duration _parseTime(String time) {
    final parts = time.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);

    return Duration(minutes: minutes, seconds: seconds);
  }

  void showWinnerDialog(String? winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == null ? 'Draw' : '$winner Wins'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                displayXO = ['','','','','','','','',''];
                gameActive = true;
                isO = true;
                gameStartTime = null; // Reset game start time
              });
              Navigator.of(context).pop();
            },
            child: Text('Restart'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(isComputerThinking ? Colors.red : Colors.transparent)
                  ),

                  //back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Game title
                  Text(
                    "Tic Tac Toe",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Divider
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Best Time: $userBestTime",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Game profile cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: GameProfileCard(
                          color: Colors.blue,
                          image: 'images/userScore.png',
                          mark: 'X',
                          user: 'You',
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: GameProfileCard(
                          color: Colors.red,
                          image: 'images/computerScore.png',
                          mark: 'O',
                          user: 'Computer',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Game board
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: const [Colors.red, Colors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        tapped(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            displayXO[index],
                            style: TextStyle(
                              fontSize: 64,
                              color: displayXO[index] == 'O'
                                  ? Colors.blue
                                  : displayXO[index] == 'X'
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
