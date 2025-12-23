import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe2/Onboarding/M-pin%20auth/enterMpin.dart';
import 'package:vibe2/Onboarding/Authentication/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String? emailError;
  String? passwordError;

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool isValidEmail(String email) {
    final RegExp emailRegex =
    RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  void loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty) {
      setState(() => emailError = "Please enter email");
      return;
    } else if (!isValidEmail(email)) {
      setState(() => emailError = "Enter a valid email");
      return;
    }

    if (pass.isEmpty) {
      setState(() => passwordError = "Please enter password");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnterMPinPage()),
    );
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
                'Login to your account.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Good to see you again, enter your details below to continue deciding.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Email Address",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 8),

              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  filled: true,
                  fillColor: const Color(0xFFFFF6D9),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
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

              const Text(
                "Password",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  filled: true,
                  fillColor: const Color(0xFFFFF6D9),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
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

              if (passwordError != null) ...[
                const SizedBox(height: 6),
                Text(
                  passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],

              const SizedBox(height: 22),

              Text.rich(
                TextSpan(
                  text: 'By entering your number, you\'re agreeing to our ',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions ',
                      style: const TextStyle(
                        color: Color(0xFFA69345),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL('https://flutter.dev');
                        },
                    ),
                    const TextSpan(text: 'and '),
                    const TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFFA69345),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _socialButton("assets/google.png"),
                  _socialButton("assets/facebook.png"),
                  _socialButton("assets/apple.png"),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Create an account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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

  Widget _socialButton(String iconPath) {
    return Container(
      height: 55,
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FittedBox(
        fit: BoxFit.none,
        alignment: AlignmentGeometry.center,
        child: Image.asset(
          iconPath,
          height: 30,
        ),
      ),
    );
  }
}
