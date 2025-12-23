import 'package:flutter/material.dart';
import 'resetMpin.dart';
import 'enterMpin.dart';

class VerifyMPinCodePage extends StatefulWidget {
  const VerifyMPinCodePage({super.key});

  @override
  State<VerifyMPinCodePage> createState() => _VerifyMPinCodePageState();
}

class _VerifyMPinCodePageState extends State<VerifyMPinCodePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const String _demoOtp = "123456";

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _focusNode.requestFocus();
    });

    // Rebuild on input
    _codeController.addListener(() => setState(() {}));

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

  void _verifyOtp() async {
    if (_codeController.text == _demoOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetMPinPage()),
      );
    } else {
      setState(() => _isError = true);
      _shakeController.forward(from: 0);
      _codeController.clear();

      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isError = false);
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final bool isComplete = _codeController.text.length == 6;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Semantics(
                label: "Go back to login page",
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EnterMPinPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Reset your m-pin",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "We have sent a 6 digit code on your email id\ntani***@gmail.com",
                style: TextStyle(color: Colors.white70, fontSize: 13),
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
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isError ? Colors.redAccent : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "• " * _codeController.text.length +
                        "_ " * (6 - _codeController.text.length),
                    style: const TextStyle(
                      letterSpacing: 6,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't get it?",
                    style: TextStyle(color: Colors.white54),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("OTP resent successfully"),
                        ),
                      );
                    },
                    child: const Text(
                      "Tap to resend.",
                      style: TextStyle(
                        color: Color(0xFFFFC800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isComplete ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    disabledBackgroundColor:
                    const Color(0xFFFFC800).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Update m-pin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 0,
                child: TextField(
                  controller: _codeController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,

                  showCursor: false,
                  enableInteractiveSelection: false,
                  style: const TextStyle(color: Colors.transparent),

                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
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


