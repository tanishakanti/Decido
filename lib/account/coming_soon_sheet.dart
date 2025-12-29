import 'package:flutter/material.dart';

class ComingSoonSheet extends StatelessWidget {
  const ComingSoonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.55;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.asset(
                  'assets/account/comingSoon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ───── TITLE ─────
            const Text(
              "We are building this for you",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            // ───── SUBTITLE ─────
            const Text(
              "Stay tuned for more updates!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

            const Spacer(),

            // ───── GO BACK ─────
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: const Text(
                  "Go back",
                  style: TextStyle(
                    color: Color(0xFFFFCF00),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

void showComingSoonBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return Stack(
        children: [
          Container(color: Colors.white54),
          const ComingSoonSheet(),
        ],
      );
    },
  );
}
