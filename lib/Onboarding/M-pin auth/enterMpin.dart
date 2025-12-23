import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe2/Home/home.dart';
import 'package:vibe2/Onboarding/M-pin%20auth/verifyMpin.dart';

class EnterMPinPage extends StatefulWidget {
  const EnterMPinPage({super.key});

  @override
  State<EnterMPinPage> createState() => _EnterMPinPageState();
}

class _EnterMPinPageState extends State<EnterMPinPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isError = false;

  @override
  void initState() {
    super.initState();

    // Auto-open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Rebuild UI on pin change
    _pinController.addListener(() => setState(() {}));

    // Shake animation
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('mpin');

    if (_pinController.text == savedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _isError = true);
      _shakeController.forward(from: 0);
      _pinController.clear();

      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isError = false);
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isComplete = _pinController.text.length == 6;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Back button
              // IconButton(
              //   onPressed: () => Navigator.pop(context),
              //   icon: const Icon(Icons.arrow_back, color: Colors.white),
              // ),

              const SizedBox(height: 20),

              const Text(
                "Enter your m-pin",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter your secure 6-digit m-pin to sign in your account",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final filled = index < _pinController.text.length;
                    return Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: filled
                            ? (_isError
                            ? Colors.redAccent
                            : const Color(0xFF1E1E1E))
                            : const Color(0xFF1E1E1E),
                        border: Border.all(
                          color: filled
                              ? Colors.transparent
                              : Colors.white24,
                        ),
                      ),
                      child: filled
                          ? const Center(
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    );
                  }),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VerifyMPinCodePage()),
                    );
                  },
                  child: const Text(
                    "Forgot m-pin?",
                    style: TextStyle(
                      color: Color(0xFFFFC800),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ENTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isComplete ? _verifyPin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    disabledBackgroundColor:
                    const Color(0xFFFFC800).withOpacity(0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Enter m-pin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Hidden TextField (system keyboard)
              SizedBox(
                height: 0,
                child: TextField(
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  autofocus: true,

                  showCursor: false,
                  enableInteractiveSelection: false,
                  style: const TextStyle(color: Colors.transparent),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
