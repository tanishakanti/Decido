import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'enterMpin.dart';

class ResetMPinPage extends StatefulWidget {
  const ResetMPinPage({super.key});

  @override
  State<ResetMPinPage> createState() => _ResetMPinPageState();
}

class _ResetMPinPageState extends State<ResetMPinPage> {
  final TextEditingController newPin = TextEditingController();
  final TextEditingController confirmPin = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  Future<void> saveNewPin() async {
    if (newPin.text != confirmPin.text || newPin.text.length != 6) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mpin', newPin.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnterMPinPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled =
        newPin.text.length == 6 && newPin.text == confirmPin.text;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              const Text(
                "Create new m-pin",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              _pinField("New m-pin", newPin),
              const SizedBox(height: 16),
              _pinField("Confirm m-pin", confirmPin),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: enabled ? saveNewPin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    disabledBackgroundColor:
                    const Color(0xFFFFC800).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Save m-pin",
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

  Widget _pinField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFF1E1E1E),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            counterText: '',
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
