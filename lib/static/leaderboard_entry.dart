import 'dart:convert';

class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
  });

  factory LeaderboardEntry.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return LeaderboardEntry(
      userId: data['user_id'],
      username: data['username'],
      score: data['score'],
    );
  }
}
