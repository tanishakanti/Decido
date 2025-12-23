import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Onboarding/Authentication/login.dart';
import 'Onboarding/M-pin auth/createMpin.dart';
import 'Onboarding/M-pin auth/enterMpin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();

        final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        final String? mpin = prefs.getString('mpin');
        late final Widget nextPage;

        if (!isLoggedIn) {
          // ❌ Never logged in
          nextPage = const LoginPage();
        } else if (mpin == null) {
          // ✅ Logged in but MPIN not set (rare case / signup flow)
          nextPage = const CreateMPinPage();
        } else {
          // ✅ Logged in + MPIN exists
          nextPage = const EnterMPinPage();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: nextPage,
                ),
              );
            },
          ),
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
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: 160,
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
