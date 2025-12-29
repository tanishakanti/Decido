import 'package:flutter/material.dart';

class UserProfileReviewsScreen extends StatelessWidget {
  const UserProfileReviewsScreen({super.key});

  Widget userProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───── USER INFO ROW ─────
          Row(
            children: [
              CircleAvatar(
                radius: 33,
                backgroundImage: const AssetImage(
                  "assets/account/userImage.png",
                ),
              ),
              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Jenny D’cruze",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "1,545",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Followers • Joined in Aug 2025",
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          // ───── STATIC REVIEW COUNT ─────
          const Text(
            "25 Reviews",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0800),
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
                ],
              ),
            ),

            // ───────── CONTENT ─────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  userProfileHeader(), // 👈 IMAGE 1 content

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: const [
                        UserReviewCard(rating: 4),
                        UserReviewCard(rating: 5, isRatingOnly: true),
                        UserReviewCard(rating: 5, showRestricted: true),
                        UserReviewCard(rating: 4, isRatingOnly: true),
                        UserReviewCard(rating: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ───────── FOLLOW BUTTON ─────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GestureDetector(
                onTap: () {
                  // TODO: Follow action
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/account/followUser.png',
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Follow",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
}

class UserReviewCard extends StatelessWidget {
  final bool showRating;
  final bool isRatingOnly;
  final bool showRestricted;
  final int rating;

  const UserReviewCard({
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
              // ───── Rating ─────
              if (showRating)
                Row(
                  children: List.generate(5, (index) {
                    final isFilled = index < rating;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isFilled
                              ? const Color(0xFFCDB100)
                              : const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.asset(
                          "assets/account/star.png",
                          height: 14,
                          width: 14,
                          color: isFilled
                              ? Colors.white
                              : const Color(0x80FFFFFF),
                        ),
                      ),
                    );
                  }),
                ),

              if (showRating) const SizedBox(height: 10),

              // ───── Review Text ─────
              if (!isRatingOnly)
                const Text(
                  "I visited this place on a weekday evening and was pleasantly surprised. "
                  "The warm, relaxed ambience is perfect for enjoying good food.\n\n"
                  "If you're looking for a spot to chill with friends or enjoy a calm dinner, "
                  "this is a great choice.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

              const SizedBox(height: 14),

              // ───── USER INFO ROW ─────
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      "assets/account/userImage2.png",
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jenny D’cruze",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "@jennylovesfood",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
