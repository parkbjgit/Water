import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../score_manager.dart';
import 'common_layout.dart';
import '../user_score.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    // 데이터를 초기화하는 메서드 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScoreManager>(context, listen: false).generateMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreManager = Provider.of<ScoreManager>(context);

    List<UserScore> leaderboard = scoreManager.getLeaderboard();
    leaderboard.sort((a, b) {
      int result = b.apples.compareTo(a.apples);
      if (result == 0) {
        result = b.points.compareTo(a.points);
      }
      return result;
    });

    return CommonLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('리더보드'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Top 3 Users',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildPodium(leaderboard),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Text('${index + 1}',
                            style: TextStyle(fontSize: 18)),
                        title: Text(leaderboard[index].nickname,
                            style: TextStyle(fontSize: 18)),
                        subtitle: Text('Apples: ${leaderboard[index].apples}',
                            style: TextStyle(fontSize: 14)),
                        trailing: Text('${leaderboard[index].points} points',
                            style: TextStyle(fontSize: 18)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(List<UserScore> leaderboard) {
    if (leaderboard.length < 3) {
      return Center(child: Text('Not enough data'));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumPlace(leaderboard[1], 2, Colors.grey, 60),
        _buildPodiumPlace(leaderboard[0], 1, Colors.yellow, 80),
        _buildPodiumPlace(leaderboard[2], 3, Colors.brown, 50), // 3등을 더 낮게 설정
      ],
    );
  }

  Widget _buildPodiumPlace(
      UserScore user, int place, Color color, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 40,
          child: Text(
            place.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text(user.nickname, style: TextStyle(fontSize: 18)),
        Text('Apples: ${user.apples}', style: TextStyle(fontSize: 16)),
        Text('${user.points} points', style: TextStyle(fontSize: 16)),
        Container(
          height: height,
          width: 60,
          color: color.withOpacity(0.3),
        ),
      ],
    );
  }
}
