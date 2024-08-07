import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_score.dart';

class ScoreManager extends ChangeNotifier {
  int _totalPoints = 0;
  int _appleCount = 0;
  List<UserScore> _leaderboard = [];

  int get totalPoints => _totalPoints;
  int get appleCount => _appleCount;
  List<UserScore> get leaderboard => _leaderboard;

  Future<void> setPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', points);
    _totalPoints = points;
    notifyListeners();
  }

  Future<void> addPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalPoints += points;
    await prefs.setInt('totalPoints', _totalPoints);
    notifyListeners();
  }

  Future<void> subtractPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalPoints -= points;
    await prefs.setInt('totalPoints', _totalPoints);
    notifyListeners();
  }

  Future<void> setAppleCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appleCount', count);
    _appleCount = count;
    notifyListeners();
  }

  Future<void> addApple() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _appleCount += 1;
    await prefs.setInt('appleCount', _appleCount);
    notifyListeners();
  }

  Future<void> loadScoreData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _totalPoints = prefs.getInt('totalPoints') ?? 0;
    _appleCount = prefs.getInt('appleCount') ?? 0;
    notifyListeners();
  }

  List<UserScore> getLeaderboard() {
    return _leaderboard;
  }

  void updateLeaderboard(List<UserScore> leaderboard) {
    _leaderboard = leaderboard;
    notifyListeners();
  }

  // 임의의 데이터를 추가하는 메서드
  void generateMockData() {
    _leaderboard = [
      UserScore('귀여운 지민이', 1500, 10),
      UserScore('싹싹한 상욱이', 1400, 8),
      UserScore('잘생긴 범준이', 1300, 7),
      UserScore('든든한 병현이', 1200, 5),
      UserScore('우아한 예진이', 1100, 3),
      UserScore('씩씩한 경민이', 1000, 2),
    ];
    notifyListeners();
  }
}
