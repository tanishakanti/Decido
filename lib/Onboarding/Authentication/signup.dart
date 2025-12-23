import 'package:flutter/material.dart';
import 'package:vibe2/Onboarding/M-pin%20auth/createMpin.dart';
import 'package:vibe2/Onboarding/Authentication/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmError;

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool isValidEmail(String email) {
    final RegExp emailRegex =
    RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  void _tryCreateAccount() {
    setState(() {
      emailError = null;
      passwordError = null;
      confirmError = null;

      final email = emailController.text.trim();
      final pass = passwordController.text.trim();
      final confirm = confirmController.text.trim();

      if (email.isEmpty) {
        emailError = "Please enter email";
      } else if (!isValidEmail(email)) {
        emailError = "Enter a valid email";
      }

      if (pass.isEmpty) {
        passwordError = "Please enter password";
      }

      if (confirm.isEmpty) {
        confirmError = "Please confirm password";
      } else if (pass != confirm) {
        confirmError = "Passwords do not match";
      }

      if (emailError == null &&
          passwordError == null &&
          confirmError == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateMPinPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 55),

              const Text(
                'Create an account.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 10),

              const Text(
                'Welcome friend, enter your details and lets get you to decide the next best restaurant.',
                style: TextStyle(fontSize: 12, height: 1.3, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              const Text("Email Address",
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 8),

              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  filled: true,
                  fillColor: const Color(0xFFFFF6D9),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(emailError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 20),

              const Text("Password",
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  filled: true,
                  fillColor: const Color(0xFFFFF6D9),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),
                ),
              ),

              if (passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(passwordError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 20),

              const Text("Confirm Password",
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 8),

              TextField(
                controller: confirmController,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  filled: true,
                  fillColor: const Color(0xFFFFF6D9),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() => showConfirmPassword = !showConfirmPassword);
                    },
                  ),
                ),
              ),

              if (confirmError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(confirmError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 22),

              const Text.rich(
                TextSpan(
                  text: 'By entering your number, you\'re agreeing to our ',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions ',
                      style: TextStyle(
                          color: Color(0xFFA69345), fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: 'and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          color: Color(0xFFA69345), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _tryCreateAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Create an account",
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: const Text(
                    "Login to my account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
