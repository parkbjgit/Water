import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common_layout.dart';
import '../widgets/profile_card.dart';
import '../score_manager.dart';
import '../user_score.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  //return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  ProfileCard(),
                  SizedBox(height: 20),
                  Expanded(child: LeaderboardSection()), // 리더보드를 추가
                  SizedBox(height: 20), // 버튼과 리더보드 사이에 간격을 추가
                  ElevatedButton(
                    onPressed: () {
                      signInWithGoogle(); // 함수 호출
                    },
                    child: Text('Action Button'),
                  ),
                  SizedBox(height: 20), // 버튼 아래에 여유 공간 추가
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardSection extends StatefulWidget {
  @override
  _LeaderboardSectionState createState() => _LeaderboardSectionState();
}

class _LeaderboardSectionState extends State<LeaderboardSection> {
  @override
  void initState() {
    super.initState();
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

    return Padding(
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
                    leading:
                        Text('${index + 1}', style: TextStyle(fontSize: 18)),
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
        _buildPodiumPlace(leaderboard[2], 3, Colors.brown, 50),
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
