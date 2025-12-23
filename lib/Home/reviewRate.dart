import 'package:flutter/material.dart';
import 'package:vibe2/Home/reviews.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;

  void _onStarTap(int rating) {
    setState(() {
      _rating = rating;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, animation, __) =>
              ReviewDetailsPage(rating: rating),
          transitionsBuilder: (_, animation, __, child) {
            final tween = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- Top Bar ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "ABC Restaurant",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Image.asset(
              "assets/review.png",
              height: 180,
            ),

            const SizedBox(height: 24),

            const Text(
              "ABC Restaurant",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- Question ----------------
            const Text(
              "How was your experience?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Star Rating ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 34,
                  onPressed: () => _onStarTap(index + 1),
                  icon: Icon(
                    Icons.star,
                    color: index < _rating
                        ? Colors.yellow
                        : Colors.grey.shade700,
                  ),
                );
              }),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class ReviewBottomSheet extends StatelessWidget {
  final int rating;
  const ReviewBottomSheet({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final data = _ratingUI[rating]!;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReviewDetailsPage(rating: rating),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 24),

            // illustration
            Image.asset(
              data['image']!,
              height: 140,
            ),

            const SizedBox(height: 20),

            // title
            Text(
              data['title']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

const Map<int, Map<String, String>> _ratingUI = {
  1: {
    'title': 'Not a great experience',
    'image': 'assets/review_1.png',
  },
  2: {
    'title': 'Could have been better',
    'image': 'assets/review_2.png',
  },
  3: {
    'title': 'It was okay',
    'image': 'assets/review_3.png',
  },
  4: {
    'title': 'Really good!',
    'image': 'assets/review_4.png',
  },
  5: {
    'title': 'Absolutely loved it!',
    'image': 'assets/review_5.png',
  },
};

