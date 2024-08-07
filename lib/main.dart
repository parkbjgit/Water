import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 패키지 임포트
import 'package:provider/provider.dart';
import 'score_manager.dart';
import 'data.dart';
import 'models/tree_model.dart';
import 'pages/home_page.dart';
import 'pages/reward_page.dart';
import 'pages/quiz_page.dart';
import 'pages/garden_page.dart';
import 'pages/mission_page.dart';
import 'pages/water_usage_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/map_page.dart'; // 지도 페이지 임포트

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 위치 권한 요청
  //await requestLocationPermission(); // 추가된 부분

  final scoreManager = ScoreManager();
  await scoreManager.setPoints(10000); // 초기화 시 10000 포인트 설정

  final treeManager = TreeManager();
  await treeManager.loadTree();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => scoreManager),
        ChangeNotifierProvider(create: (context) => ItemData()),
        ChangeNotifierProvider(create: (context) => treeManager),
      ],
      child: MyApp(),
    ),
  );
}

// 권한 요청 함수
Future<void> requestLocationPermission() async {
  if (await Permission.location.request().isGranted) {
    // 권한이 허용됨
  } else {
    // 권한이 거부됨
    // 필요한 경우 추가적인 권한 요청 로직을 여기에 추가
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '퀴즈 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'BMHANNA', // 글로벌 폰트 설정
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          displayMedium: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          displaySmall: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          headlineMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          headlineSmall: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          titleLarge: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'BMHANNA'),
          titleMedium: TextStyle(fontSize: 16.0, fontFamily: 'BMHANNA'),
          titleSmall: TextStyle(fontSize: 14.0, fontFamily: 'BMHANNA'),
          bodyLarge: TextStyle(fontSize: 16.0, fontFamily: 'BMHANNA'),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'BMHANNA'),
          labelLarge: TextStyle(fontSize: 16.0, fontFamily: 'BMHANNA'),
          bodySmall: TextStyle(fontSize: 12.0, fontFamily: 'BMHANNA'),
          labelSmall: TextStyle(fontSize: 10.0, fontFamily: 'BMHANNA'),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/home': (context) => HomePage(),
        '/quiz': (context) => QuizPage(),
        '/reward': (context) => RewardPage(),
        '/garden': (context) => GardenPage(),
        '/mission': (context) => MissionPage(),
        '/water_usage': (context) => WaterUsagePage(),
        '/map': (context) => MapPage(), // 지도 페이지 경로 설정
        '/login': (context) => LoginSignupPage(),
        '/leaderboard': (context) => LeaderboardPage(), // 리더보드 페이지 경로 설정
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
