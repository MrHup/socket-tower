import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow(
      {required this.place,
      required this.score,
      required this.name,
      super.key});

  final int place;
  final int score;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(place.toString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "TitleFont",
                  color: Color(0x75000000))),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text(name[0] + name[1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "TitleFont",
                    color: Color(0xffffffff))),
          ),
          Text(name,
              style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "TitleFont",
                  color: Color(0x75000000))),
          Text(score.toString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "TitleFont",
                  color: Color(0xfffc8383)))
        ],
      ),
    );
  }
}
