import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:socket_showdown/overlays/utils/hover_image.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_row.dart';
import 'package:socket_showdown/overlays/utils/leaderboard_title.dart';
import 'package:socket_showdown/static/game_state.dart';
import 'package:socket_showdown/static/leaderboard_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class LeaderboardMenu extends StatefulWidget {
  LeaderboardMenu(this.game, {this.score = 0, super.key});
  Object? game;
  int score;

  @override
  State<LeaderboardMenu> createState() => _LeaderboardMenuState();
}

class _LeaderboardMenuState extends State<LeaderboardMenu> {
  List<LeaderboardEntry> leaderboardEntries = [];
  Future<List<LeaderboardEntry>> fetchLeaderBoardEntries() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('top10');
    final snapshot = await users.doc("top").get();
    final data = snapshot.data() as Map<String, dynamic>;

    LeaderboardEntry lowestScoreEntry =
        LeaderboardEntry(score: 10000, userId: "", username: "");
    LeaderboardEntry userInTop10Entry =
        LeaderboardEntry(userId: "", username: "", score: 0);
    bool needsToUpload = false;

    List<dynamic> entries = data["top10"];
    leaderboardEntries = [];
    for (var entry in entries) {
      LeaderboardEntry currentEntry = LeaderboardEntry(
          userId: entry["user_id"],
          score: entry["score"],
          username: entry["username"]);
      leaderboardEntries.add(currentEntry);

      if (entry["score"] < lowestScoreEntry.score) {
        lowestScoreEntry = currentEntry;
      }

      if (entry["user_id"] == GameState.userIdentifier) {
        userInTop10Entry = currentEntry;
      }
    }

    if (GameState.bestScore > lowestScoreEntry.score) {
      if (userInTop10Entry.score > 0 &&
          GameState.bestScore > userInTop10Entry.score) {
        for (var entry in leaderboardEntries) {
          if (entry.userId == GameState.userIdentifier) {
            entry.score = GameState.bestScore;

            print("Setting new record for user " +
                GameState.userIdentifier +
                " with score " +
                GameState.bestScore.toString());
            needsToUpload = true;
            break;
          }
        }
      } else if (userInTop10Entry.score == 0) {
        print("New user added to the leaderboard!");
        leaderboardEntries.add(LeaderboardEntry(
            userId: GameState.userIdentifier,
            score: GameState.bestScore,
            username: GameState.userName));
        needsToUpload = true;
      }

      if (needsToUpload) {
        print("Updating leaderboard...");
        leaderboardEntries.sort((a, b) => b.score.compareTo(a.score));
        leaderboardEntries = leaderboardEntries.sublist(0, 10);
        List<Map<String, dynamic>> leaderboardEntriesMap = [];
        for (var entry in leaderboardEntries) {
          leaderboardEntriesMap.add({
            "user_id": entry.userId,
            "username": entry.username,
            "score": entry.score
          });
        }
        users.doc("top").set({"top10": leaderboardEntriesMap});
      }
    }

    return leaderboardEntries;
  }

  Future<List<LeaderboardRow>> sortLeaderBoardEntries() async {
    final List<LeaderboardEntry> entries = await fetchLeaderBoardEntries();
    List<LeaderboardRow> rows = [];
    for (var entry in entries) {
      rows.add(LeaderboardRow(
          place: entries.indexOf(entry) + 1,
          score: entry.score,
          name: entry.username));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(127, 0, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Card(
                  elevation: 20,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: SizedBox(
                    width: 350,
                    height: 500,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const LeaderboardTitle(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<List<LeaderboardRow>>(
                              future:
                                  sortLeaderBoardEntries(), // Replace with your actual method to fetch leaderboard entries
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 10, color: Colors.blue));
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
                        ),
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

            // back button
            Material(
              color: Colors.transparent,
              child: HoverImage(
                normalImage: 'assets/images/buttons/back_up.png',
                hoverImage: 'assets/images/buttons/back_down.png',
                onPressed: () {
                  (widget.game as FlameGame).overlays.remove('leaderboard');
                  (widget.game as FlameGame).overlays.add('replay-menu');
                },
                landScape: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
