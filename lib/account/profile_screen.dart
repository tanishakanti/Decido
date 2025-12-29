import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe2/account/coming_soon_sheet.dart';
import 'package:vibe2/account/followingUser.dart';
import 'package:vibe2/account/my_review_screen.dart';
import 'package:vibe2/account/terms_condition.dart';
import 'package:vibe2/account/logout_sheet.dart';
import 'package:vibe2/account/findUser.dart';
import 'edit_profile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vibe2/account/followUser.dart';

const Color kBg = Color(0xFF000000);
const Color kCard = Color(0xFF1A1A18);
const Color kYellow = Color(0xFFCDB100);
const Color kArrowYellow = Color(0xFFFFCF00);

class CircleIcon extends StatelessWidget {
  final Widget child;
  final double size;
  final Color background;

  const CircleIcon({
    super.key,
    required this.child,
    this.size = 36,
    this.background = const Color(0xFF1F1F1F),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  String fullName = 'Jenny D’cruz';
  String userId = '1234567890';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final first = prefs.getString('firstName') ?? 'Jenny';
    final last = prefs.getString('lastName') ?? 'D’cruz';

    setState(() {
      fullName = '$first $last';
    });
  }

  void showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.white38,
      builder: (_) => const LogoutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Container(
        color: Colors.black.withOpacity(0.15),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- TITLE ----------------
                const Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                // ---------------- PROFILE CARD ----------------
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/account/userImage.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Name + ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "ID: 1234567890",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );

                          if (updated == true) {
                            loadProfile();
                          }
                        },

                        child: Image.asset(
                          'assets/account/editOption.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ---------------- MAIN OPTIONS ----------------
                _groupBox(
                  children: [
                    _Item(
                      iconAsset: 'assets/account/profile.png',
                      title: "My reviews",
                      subtitle: "View all your reviews so far",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyReviewScreen(),
                          ),
                        );
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/addBusiness.png',
                      title: "Add a business",
                      subtitle: "List your business on our DECIDO",
                      onTap: () {
                        showComingSoonBottomSheet(context);
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/following.png',
                      title: "Following",
                      subtitle: "See all users you follow",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FollowingUserPage(),
                          ),
                        );
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/followUser.png',
                      title: "Follow a user",
                      subtitle: "See all users on DECIDO",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FollowUserPage(),
                          ),
                        );
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/itemfinder.png',
                      title: "Item finder",
                      subtitle: "Look for items globally or in your city",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FindUserPage(),
                          ),
                        );
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/rewards.png',
                      title: "My rewards",
                      subtitle: "View all rewards earned so far",
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------------- MORE SECTION ----------------
                const Text(
                  "More",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),

                const SizedBox(height: 18),

                _groupBox(
                  children: [
                    _Item(
                      iconAsset: 'assets/account/terms.png',
                      title: "Terms & Conditions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsAndConditionsPage(),
                          ),
                        );
                      },
                    ),
                    _Item(
                      iconAsset: 'assets/account/policy.png',
                      title: "Privacy Policy",
                    ),
                    _Item(
                      iconAsset: 'assets/account/notification.png',
                      title: "Email Us",
                    ),
                    _Item(
                      iconAsset: 'assets/account/logout.png',
                      title: "Log out",
                      onTap: () {
                        showLogoutBottomSheet(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------------- FOOTER ----------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Helping you decide.",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white60,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    AppVersionText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- GROUP BOX ----------------
Widget _groupBox({required List<Widget> children}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(18),

      boxShadow: [
        // main lift
        BoxShadow(
          color: Colors.black.withOpacity(0.50),
          blurRadius: 26,
          offset: const Offset(0, 12),
        ),

        BoxShadow(
          color: const Color(0xFFE6C300).withOpacity(0.14),
          blurRadius: 20,
          spreadRadius: -6,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _Item extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _Item({
    required this.iconAsset,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // -------- ASSET ICON --------
            CircleIcon(
              size: 36,
              background: Colors.yellow.withOpacity(0.12),
              child: Image.asset(
                iconAsset,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                //color: Colors.white70,
              ),
            ),

            const SizedBox(width: 12),

            // -------- TEXT --------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // -------- RIGHT ARROW --------
            const SizedBox(
              width: 14,
              height: 14,
              child: Icon(Icons.chevron_right, color: kArrowYellow, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class AppVersionText extends StatelessWidget {
  const AppVersionText({super.key});

  Future<String> _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getVersion(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return Text(
          "App version: ${snapshot.data}",
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        );
      },
    );
  }
}
