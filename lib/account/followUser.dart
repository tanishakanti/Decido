import 'package:flutter/material.dart';
import 'package:vibe2/account/userReview.dart';

class FollowUserPage extends StatefulWidget {
  const FollowUserPage({super.key});

  @override
  State<FollowUserPage> createState() => _FollowUserPageState();
}

class _FollowUserPageState extends State<FollowUserPage> {
  // ───── DEMO USERS ─────
  static final List<Map<String, String>> demoUsers = List.generate(
    20,
    (index) => {"name": "Jenny D’cruze", "username": "@jennydcruze"},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
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
                      "Find a User",
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

            const SizedBox(height: 12),

            // ───────── SEARCH BAR ─────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF202831),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/account/search.png', // 🔍 asset icon
                        height: 20,
                        width: 20,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Search by username",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ───────── USER LIST ─────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: demoUsers.length,
                itemBuilder: (context, index) {
                  final user = demoUsers[index];

                  return GestureDetector(
                    onTap: () {
                      // TODO: Navigate to user profile
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            height: 32,
                            width: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white12,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/account/userImage.png',
                              width: 32,
                              height: 32,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Name + username
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user["name"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user["username"]!,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const UserProfileReviewsScreen(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFFFFCF00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ───────── IMPORT CONTACT ─────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
              child: GestureDetector(
                onTap: () {
                  // TODO: import contacts logic
                },
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCF00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Import contact",
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
      ),
    );
  }
}
