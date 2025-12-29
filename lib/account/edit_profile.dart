import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:country_picker/country_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color bg = Color(0xFF0B0B0B);
  static const Color disabledBg = Color(0x5cABABAB);
  static const Color enabledBg = Colors.white12;
  static Color enabledBorder = Colors.yellow.withOpacity(0.12);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController(
    text: 'jennylovesfood',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'jenny.dcruze@gmail.com',
  );
  final TextEditingController mobileController = TextEditingController(
    text: '9000000000',
  );
  final TextEditingController firstNameController = TextEditingController(
    text: 'Jenny',
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "D'cruze",
  );

  // ---------------- COUNTRY PICKER ----------------
  String countryCode = '+61';
  String countryFlag = '🇦🇺';

  // ---------------- SAVE PROFILE ----------------
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', mobileController.text);
    await prefs.setString('code', countryCode);
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
  }

  // ---------------- INPUT DECORATION ----------------
  InputDecoration _decoration({
    String? errorText,
    String? prefix,
    bool enabled = true,
  }) {
    return InputDecoration(
      prefixText: prefix,
      prefixStyle: const TextStyle(color: Colors.white70),
      errorText: errorText,
      filled: true,
      fillColor: enabled ? enabledBg : disabledBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: enabled ? enabledBorder : Colors.transparent,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: enabledBorder, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- APP BAR ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- FORM ----------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ---------------- PROFILE IMAGE ----------------
                      ClipOval(
                        child: Image.asset(
                          'assets/account/userImage.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Change profile picture',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _label('Username'),
                      TextFormField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(prefix: '@ ', enabled: true),
                      ),

                      const SizedBox(height: 8),

                      _label('Email Address'),
                      TextFormField(
                        controller: emailController,
                        enabled: false,
                        style: const TextStyle(color: Colors.white70),
                        decoration: _decoration(enabled: false),
                      ),

                      const SizedBox(height: 8),

                      _label('Mobile No.'),
                      Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: disabledBg, // #ABABAB5C
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // Country flag + code (STATIC)
                            Text(
                              countryFlag,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              countryCode,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Phone number (STATIC)
                            Expanded(
                              child: Text(
                                mobileController.text,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      _label('First Name'),
                      TextFormField(
                        controller: firstNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(enabled: true),
                      ),

                      _label('Last Name'),
                      TextFormField(
                        controller: lastNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(enabled: true),
                      ),

                      const SizedBox(height: 65),

                      // ---------------- UPDATE BUTTON ----------------
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFCF00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await saveProfile();
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'Update profile',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LABEL ----------------
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            color: const Color(0xFF8A8A8A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
