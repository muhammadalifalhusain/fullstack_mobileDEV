import 'package:flutter/material.dart';
import 'landing_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Efek zoom in dan out

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Navigate to LandingPage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LandingPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      body: Column(
        children: [
          // Area utama dengan logo di center
          Expanded(
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 250, 
                    height: 250, 
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'from\n ',
                    style: TextStyle(
                      color: Colors.grey[400], 
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextSpan(
                    text: 'PPATQ Raudlatul Falah',
                    style: TextStyle(
                      color: Color(0xFF00695C), // Warna hijau teal
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}