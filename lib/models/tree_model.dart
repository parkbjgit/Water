import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tree {
  int experience;
  int level;
  List<bool> evolutionStages;

  Tree({this.experience = 0, this.level = 0, List<bool>? evolutionStages})
      : evolutionStages = evolutionStages ?? [false, false, false, false, false, false];

  void addExperience(int exp) {
    experience += exp;
    if (experience >= 3500) {
      experience = 3500;
    }
  }

  void evolve() {
    if (experience >= (level + 1) * 500 && level < 7) {
      level++;
    }
  }

  void evolveWithItem() {
    if (level < 7) {
      if (experience >= 500 && !evolutionStages[0]) {
        level++;
        evolutionStages[0] = true;
      } else if (experience >= 1000 && !evolutionStages[1]) {
        level++;
        evolutionStages[1] = true;
      } else if (experience >= 1500 && !evolutionStages[2]) {
        level++;
        evolutionStages[2] = true;
      } else if (experience >= 2000 && !evolutionStages[3]) {
        level++;
        evolutionStages[3] = true;
      } else if (experience >= 2500 && !evolutionStages[4]) {
        level++;
        evolutionStages[4] = true;
      } else if (experience >= 3000 && !evolutionStages[5]) {
        level++;
        evolutionStages[5] = true;
      }
    }
  }

  void reset() {
    experience = 0;
    level = 0;
    evolutionStages = [false, false, false, false, false, false];
  }

  void plantSeed() {
    level = 1;
    experience = 0;
  }
}

class TreeManager extends ChangeNotifier {
  Tree _tree = Tree();

  Tree get tree => _tree;

  Future<void> loadTree() async {
    final prefs = await SharedPreferences.getInstance();
    _tree.experience = prefs.getInt('treeExperience') ?? 0;
    _tree.level = prefs.getInt('treeLevel') ?? 0;
    _tree.evolutionStages = [
      prefs.getBool('evolutionStage0') ?? false,
      prefs.getBool('evolutionStage1') ?? false,
      prefs.getBool('evolutionStage2') ?? false,
      prefs.getBool('evolutionStage3') ?? false,
      prefs.getBool('evolutionStage4') ?? false,
      prefs.getBool('evolutionStage5') ?? false,
    ];
    notifyListeners();
  }

  Future<void> saveTree() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('treeExperience', _tree.experience);
    await prefs.setInt('treeLevel', _tree.level);
    await prefs.setBool('evolutionStage0', _tree.evolutionStages[0]);
    await prefs.setBool('evolutionStage1', _tree.evolutionStages[1]);
    await prefs.setBool('evolutionStage2', _tree.evolutionStages[2]);
    await prefs.setBool('evolutionStage3', _tree.evolutionStages[3]);
    await prefs.setBool('evolutionStage4', _tree.evolutionStages[4]);
    await prefs.setBool('evolutionStage5', _tree.evolutionStages[5]);
  }

  void addExperience(int exp) {
    _tree.addExperience(exp);
    saveTree();
    notifyListeners();
  }

  void evolve() {
    _tree.evolve();
    saveTree();
    notifyListeners();
  }

  void evolveWithItem() {
    _tree.evolveWithItem();
    saveTree();
    notifyListeners();
  }

  void resetTree() {
    _tree.reset();
    saveTree();
    notifyListeners();
  }

  void plantSeed() {
    _tree.plantSeed();
    saveTree();
    notifyListeners();
  }
}
