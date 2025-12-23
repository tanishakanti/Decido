import 'package:flutter/material.dart';
import 'package:vibe2/Onboarding/admin.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();

  String? fnameError;
  String? lnameError;

  void detailUser() {
    setState(() {
      fnameError = null;
      lnameError = null;

      final fname = fnameController.text.trim();
      final lname = lnameController.text.trim();

      if (fname.isEmpty) {
        fnameError = "Please enter first name";
      }
      if (lname.isEmpty) {
        lnameError = "Please enter last name";
      }

      if (fnameError == null && lnameError == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminPage()),
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
                'What\'s your full name?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Tell us more about yourself and help us get to know you better',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "First Name",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: fnameController,
                decoration: InputDecoration(
                  hintText: 'Enter first name',
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

              if (fnameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    fnameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                "Last Name",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: lnameController,
                decoration: InputDecoration(
                  hintText: 'Enter last name',
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

              if (lnameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    lnameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: detailUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Let's go!",
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
                      MaterialPageRoute(builder: (_) => const AdminPage()),
                    );
                  },
                  child: const Text(
                    "Skip",
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
}
