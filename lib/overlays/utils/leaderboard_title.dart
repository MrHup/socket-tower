import 'package:flutter/material.dart';

class LeaderboardTitle extends StatelessWidget {
  const LeaderboardTitle({this.title = "Leaderboard", super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'TitleFont',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 8
                ..color = const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          // Solid text as fill.
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'TitleFont',
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
