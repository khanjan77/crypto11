import 'package:flutter/material.dart';
import 'screens/crypto_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/profile_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/deposit_withdraw_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/cryptoList': (context) => CryptoListScreen(onThemeChange: _toggleTheme),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingScreen(onThemeChange: _toggleTheme),
        '/portfolio': (context) => PortfolioScreen(),
        '/depositWithdraw': (context) => DepositWithdrawScreen(),
      },
    );
  }
}
