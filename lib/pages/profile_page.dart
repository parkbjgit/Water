// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'common_layout.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ProfileCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
