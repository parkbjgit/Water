import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _loginUsernameController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupUsernameController =
      TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  bool _isLogin = true;
  String _errorMessage = '';

  Future<void> _login() async {
    // 로그인 로직
  }

  Future<void> _signup() async {
    // 회원가입 로직
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? '로그인' : '회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLogin ? _buildLoginForm() : _buildSignupForm(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Icon(_isLogin ? Icons.person_add : Icons.login),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _loginUsernameController,
            decoration: InputDecoration(labelText: '사용자 이름'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '사용자 이름을 입력해주세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _loginPasswordController,
            decoration: InputDecoration(labelText: '비밀번호'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_loginFormKey.currentState?.validate() ?? false) {
                _login();
              }
            },
            child: Text('로그인'),
          ),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _signupUsernameController,
            decoration: InputDecoration(labelText: '사용자 이름'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '사용자 이름을 입력해주세요';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _signupPasswordController,
            decoration: InputDecoration(labelText: '비밀번호'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_signupFormKey.currentState?.validate() ?? false) {
                _signup();
              }
            },
            child: Text('회원가입'),
          ),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
