import 'package:flutter/material.dart';
import 'package:ml_app/src/features/terms_and_conditions/screens/terms_condition_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsAndConditionScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '🔖',
              style: TextStyle(fontSize: 100),
            ),
          ),
          Text(
            'Terms and Conditions',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
