import 'package:flutter/material.dart';
import 'dart:ui';

class MyReviewScreen extends StatelessWidget {
  const MyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0800), // ⬅ updated background
      body: SafeArea(
        child: Column(
          children: [
            // ───────── HEADER ─────────
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
                      "My Reviews",
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

            // ───────── LIST ─────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ReviewCard(rating: 4),
                  ReviewCard(rating: 5, isRatingOnly: true),
                  ReviewCard(rating: 5, showRestricted: true),
                  ReviewCard(rating: 4, isRatingOnly: true),
                  ReviewCard(rating: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

class ReviewCard extends StatelessWidget {
  final bool showRating;
  final bool isRatingOnly;
  final bool showRestricted;
  final int rating;

  const ReviewCard({
    super.key,
    required this.rating,
    this.showRating = true,
    this.isRatingOnly = false,
    this.showRestricted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───── Rating Row ─────
              if (showRating)
                Row(
                  children: List.generate(5, (index) {
                    final bool isFilled = index < rating;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isFilled
                              ? const Color(0xFFCDB100) // filled bg
                              : const Color(0x33FFFFFF), // empty bg
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          "assets/account/star.png",
                          height: 14,
                          width: 14,
                          color: isFilled
                              ? Colors.white
                              : const Color(0x80FFFFFF), // ⬅ empty star color
                        ),
                      ),
                    );
                  }),
                ),

              if (showRating) const SizedBox(height: 15),

              // ───── Review Text ─────
              if (!isRatingOnly)
                const Text(
                  "I visited this place on a weekday evening and was pleasantly surprised. "
                  "The warm, relaxed ambience is perfect for enjoying good food.\n\n"
                  "I started with their signature starters, which were beautifully presented "
                  "and full of flavor. The main course continued the experience with rich, "
                  "balanced spices and generous portions.\n\n"
                  "If you're looking for a spot to chill with friends or enjoy a calm dinner, "
                  "this is a great choice.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

              const SizedBox(height: 18),

              // ───── Restaurant Row ─────
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/account/restImage.png",
                      height: 44,
                      width: 60, // ⬅ rectangle width increased
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ABC Restaurant",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "George Street",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ───── Dustbin ─────
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                _showDeleteBottomSheet(context);
              },
              child: Image.asset(
                "assets/account/dustbin.png",
                height: 26.67,
                width: 24,
                color: Colors.redAccent,
              ),
            ),
          ),

          // ───── Restricted Badge ─────
          if (showRestricted)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Restricted",
                  style: TextStyle(
                    color: Color(0xFFFE554A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Stack(
          children: [
            // ───── WHITE TRANSLUCENT OVERLAY ─────
            Container(color: Colors.white38),

            // ───── BOTTOM SHEET ─────
            const _DeleteReviewSheet(),
          ],
        );
      },
    );
  }
}

class _DeleteReviewSheet extends StatelessWidget {
  const _DeleteReviewSheet();

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
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  "assets/account/deleteIcon.png", // ⬅ asset
                  height: 68.46,
                  width: 68.46,
                  color: Colors.white, // ⬅ white icon
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Are you sure you want to\ndelete your review",
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
                // ───── NO, DON'T DELETE ─────
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
                        border: Border.all(color: Colors.redAccent, width: 1.5),
                      ),
                      child: const Text(
                        "No, don't delete",
                        style: TextStyle(
                          color: Color(0xFFFE554A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ───── YES, DELETE ─────
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // delete logic later
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE554A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFFE554A)),
                      ),
                      child: const Text(
                        "Yes, delete",
                        style: TextStyle(
                          color: Colors.white,
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

// class _ActionButton extends StatelessWidget {
//   final String text;
//   final bool selected;
//   final VoidCallback onTap;

//   const _ActionButton({
//     required this.text,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 48,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: selected ? Colors.redAccent : Colors.transparent,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.redAccent),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.redAccent,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }
