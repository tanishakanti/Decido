import 'dart:ui';
import 'package:flutter/material.dart';

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.45;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: sheetHeight,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ───── RED CIRCLE DUSTBIN ─────
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCF00),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  "assets/account/logoutIcon.png", // ⬅ asset
                  height: 68.46,
                  width: 68.46,
                  color: Colors.black, // ⬅ white icon
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Are you sure you want to\nLog Out?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 50),

            Row(
              children: [
                // ───── NO, DON'T LOGOUT ─────
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFFFFCF00),
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        "No, don't logout",
                        style: TextStyle(
                          color: Color(0xFFFFCF00),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ───── YES, LOG OUT ─────
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //logout logic
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFCF00),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFFFCF00)),
                      ),
                      child: const Text(
                        "Yes, log out",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
