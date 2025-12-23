import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe2/Onboarding/details.dart';

class CreateMPinPage extends StatefulWidget {
  const CreateMPinPage({super.key});

  @override
  State<CreateMPinPage> createState() => _CreateMPinPageState();
}

class _CreateMPinPageState extends State<CreateMPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> savePin() async {
    if (_pinController.text.length != 6) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('mpin', _pinController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DetailsPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    /// Ensures keyboard opens automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- BACK BUTTON ----------------
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              const Text(
                "Set your m-pin",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create a secure 6-digit m-pin to protect your account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- PIN DOTS ----------------
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    final filled = index < _pinController.text.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled ? Colors.black : Colors.black12,
                      ),
                    );
                  }),
                ),
              ),

              // ---------------- HIDDEN TEXTFIELD ----------------
              /// This is what actually receives input
              Opacity(
                opacity: 0,
                child: TextField(
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- CREATE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: savePin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Create m-pin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
