import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow(
      {required this.place,
      required this.score,
      required this.name,
      this.isCurrentUser = false,
      super.key});

  final int place;
  final int score;
  final String name;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: isCurrentUser ? Color.fromARGB(33, 0, 0, 0) : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(place.toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "TitleFont",
                    color: isCurrentUser
                        ? const Color.fromARGB(255, 10, 18, 43)
                        : const Color(0x75000000))),
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
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "TitleFont",
                    color: isCurrentUser
                        ? const Color.fromARGB(255, 10, 18, 43)
                        : const Color(0x75000000))),
            Text(score.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "TitleFont",
                    color: Color(0xfffc8383)))
          ],
        ),
      ),
    );
  }
}
