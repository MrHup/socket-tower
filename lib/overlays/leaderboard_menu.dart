import 'package:flutter/material.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_row.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_title.dart';
import 'package:socket_showdown/static/leaderboard_entry.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable
class LeaderboardMenu extends StatefulWidget {
  LeaderboardMenu(this.game, {this.score = 0, super.key});
  Object? game;
  int score;

  @override
  State<LeaderboardMenu> createState() => _LeaderboardMenuState();
}

// get list of top 10 scores
// user_id, username, score

// if best_score > lowest score in top 10
// if user_id in top 10
// if user_id in top 10 and best_score>score -> replace score and sort list
// else if user_id not in top 10 and best_score>score -> add user_id, username, best_score, sort list and remove lowest score
// update list in firebase realtime database

class _LeaderboardMenuState extends State<LeaderboardMenu> {
  Future<List<LeaderboardEntry>> fetchLeaderBoardEntries() async {
    // get entries from realtime database
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref("top10");
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      final List<dynamic> entries = snapshot.value as List<dynamic>;
      print(entries);
    } else {
      print('No data available.');
      return [];
    }

    return [];
  }

  Future<List<LeaderboardRow>> sortLeaderBoardEntries() async {
    await fetchLeaderBoardEntries();
    return [
      LeaderboardRow(place: 1, score: 100, name: 'User1'),
      LeaderboardRow(place: 2, score: 90, name: 'User2'),
      LeaderboardRow(place: 3, score: 80, name: 'User3'),
      LeaderboardRow(place: 4, score: 70, name: 'User4'),
      LeaderboardRow(place: 5, score: 60, name: 'User5'),
      LeaderboardRow(place: 6, score: 50, name: 'User6'),
      LeaderboardRow(place: 7, score: 40, name: 'User7'),
      LeaderboardRow(place: 8, score: 30, name: 'User8'),
      LeaderboardRow(place: 9, score: 20, name: 'User9'),
      LeaderboardRow(place: 10, score: 10, name: 'User10'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(127, 0, 0, 0),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: SizedBox(
                width: 350,
                height: 500,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    LeaderboardTitle(),
                    SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<List<LeaderboardRow>>(
                          future:
                              sortLeaderBoardEntries(), // Replace with your actual method to fetch leaderboard entries
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<LeaderboardRow> entries = snapshot.data!;
                              return ListView(
                                children:
                                    entries.map((entry) => entry).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    )
                    // score
                  ],
                ),
              ),
            ),
            Positioned(
              top: -50, // Adjust this value according to your preference
              child: Image.asset("assets/images/logo_blue.png"),
            ),
          ],
        ),
      ),
    );
  }
}
