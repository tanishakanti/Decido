import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'restInfo.dart';
import 'package:vibe2/Onboarding/Authentication/login.dart';

// Colors (background is pure black)
const Color kBackground = Color(0xFF0B0B0D); // pure black
const Color kTopBar = Color(0xFF0B0B0D);
const Color kToggleOn = Color(0xFFffe780); // yellow toggle

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isUser = true;
  String selectedCategory = 'All';

  late PageController restaurantController;
  late PageController nearYouController;

  bool _isLoadingImage = true;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    restaurantController = PageController(viewportFraction: 0.73);
    nearYouController = PageController(viewportFraction: 0.73);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
        });
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    restaurantController.dispose();
    nearYouController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              logout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> categories = [
    {'key': 'All', 'emoji': '🍟🍔'},
    {'key': 'Italian', 'emoji': '🍕'},
    {'key': 'Indian', 'emoji': '🥘'},
    {'key': 'Burgers', 'emoji': '🍔'},
    {'key': 'Dessert', 'emoji': '🍨'},
  ];

  final List<String> filters = ['Filters', 'Distance', 'Rating', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.black45,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackground,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Container(
                    color: kTopBar,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // location icon circle
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(shape: BoxShape
                                  .circle, color: Color(0xFF2E2908)),
                              child: const Icon(Icons.location_on, color: Color(
                                  0xFFffcf00), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Current location', style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('St. Parkersburg Church,...',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                            // notification button
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(color: Color(0xFFe0e1e1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Icon(
                                    Icons.notifications_none, color: Colors.black,
                                    size: 20),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Sliding pill toggle with dynamic pill content (paste in place of your previous toggle)
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF202831),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: LayoutBuilder(builder: (context, constraints) {
                              const double pillWidthFactor = 0.48;
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background labels (visible when NOT covered by the pill)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Icon(Icons.person,
                                                color: isUser
                                                    ? Colors.transparent
                                                    : Colors.white70, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'User',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isUser
                                                    ? Colors.transparent
                                                    : Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Icon(Icons.storefront_rounded,
                                                color: !isUser
                                                    ? Colors.transparent
                                                    : Colors.white70, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Owner',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: !isUser
                                                    ? Colors.transparent
                                                    : Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Sliding pill
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 240),
                                    curve: Curves.easeOut,
                                    alignment: isUser
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: FractionallySizedBox(
                                      widthFactor: pillWidthFactor,
                                      child: Container(
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE780),
                                          borderRadius: BorderRadius.circular(32),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.12),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                              milliseconds: 200),
                                          transitionBuilder: (child, anim) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                          child: isUser
                                              ? Row(
                                            key: const ValueKey('user'),
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: const [
                                              Icon(
                                                  Icons.person, color: Colors.black,
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('User',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)),
                                            ],
                                          )
                                              : Row(
                                            key: const ValueKey('owner'),
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: const [
                                              Icon(Icons.storefront_rounded,
                                                  color: Colors.black, size: 18),
                                              SizedBox(width: 8),
                                              Text('Owner',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Tappable overlay areas
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (!isUser) setState(() => isUser = true);
                                          },
                                          child: Container(),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (isUser) setState(() => isUser = false);
                                          },
                                          child: Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ----- Categories carousel (circular chips) -----
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 18),
                      itemBuilder: (context, i) {
                        final cat = categories[i];
                        final selected = cat['key'] == selectedCategory;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => selectedCategory = cat['key']!),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: selected ? kToggleOn : Colors
                                    .white,
                                child: Text(cat['emoji']!,
                                    style: const TextStyle(fontSize: 28)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cat['key']!,
                              style: TextStyle(
                                  color: selected ? Color(0xFFffcf00) : Colors
                                      .white),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ----- Search box -----
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF202831),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ----- Filters carousel (horizontally scrollable chips) -----
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final label = filters[i];
                        IconData icon;
                        Color iconColor;

                        if (i == 0) {
                          icon = Icons.tune;
                          iconColor = Colors.white; // change if you want
                        } else if (i == 1) {
                          icon = Icons.place;
                          iconColor = Colors.redAccent; // independently change color
                        } else if (i == 2) {
                          icon = Icons.star;
                          iconColor = Colors.amber; // independently change color
                        } else {
                          icon = Icons.local_fire_department;
                          iconColor = Colors.redAccent; // independently change color
                        }

                        return ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(icon, size: 18, color: iconColor),
                          label: Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14191d),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius
                                .circular(12)),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      controller: restaurantController,
                      itemCount: 5,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: restaurantController,
                          builder: (context, child) {
                            double value = 1.0;

                            if (restaurantController.position.haveDimensions) {
                              value = restaurantController.page! - index;
                              value = (1 - (value.abs() * 0.20)).clamp(0.80, 1.0);
                            }

                            return Transform.scale(
                              scale: value,
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                          // pass index so hero tag is stable and unique per card
                          child: _restaurantCarouselCard(index),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text("Near you",
                              style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                        Text("View All",
                            style: TextStyle(fontWeight: FontWeight.w600,
                                color: Color(0xFFffcf00))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 230,
                    child: PageView.builder(
                      controller: nearYouController,
                      itemCount: 5,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: nearYouController,
                          builder: (context, child) {
                            double value = 1.0;

                            if (nearYouController.position.haveDimensions) {
                              value = nearYouController.page! - index;
                              value = (1 - (value.abs() * 0.20)).clamp(0.80, 1.0);
                            }

                            return Transform.scale(
                              scale: value,
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                          child: _nearYouCard(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          bottomNavigationBar: Container(
            height: 75,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(38)),
            ),
            child: NavBarStyle15(

              currentIndex: selectedIndex,
              onTap: (i) {
                setState(() => selectedIndex = i);

                if (i == 4) { // Account tab
                  _showLogoutDialog(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // now accepts index for a stable hero tag
  Widget _restaurantCarouselCard(int index) {
    // card width is a portion of screen width (small horizontally)
    final double cardWidth = MediaQuery
        .of(context)
        .size
        .width * 0.40;
    // make the card taller than wide
    final double cardHeight = cardWidth * 1.35;
    final double imageHeight = cardHeight * 0.52;
    const double radius = 35.0;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                RestaurantDetailsPage(
                    index: index, heroTag: 'restaurant-hero-$index'),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1f2328),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius - 6),
                child: SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: _isLoadingImage
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[700]!,
                    highlightColor: Colors.grey[500]!,
                    child: Container(color: Colors.black),
                  )
                      : Hero(
                    tag: 'restaurant-hero-$index',
                    child: Image.asset(
                      'assets/abc.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABC Restaurant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    'ABC Restaurant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  // Rating row at bottom
                  Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 6),
                      Text('4.2', style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                      SizedBox(width: 40),
                      Text('15 reviews',
                          style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nearYouCard(int index) {
    // responsive same as restaurant card
    final double cardWidth = MediaQuery
        .of(context)
        .size
        .width * 0.40;
    final double cardHeight = cardWidth * 1.25;
    final double imageHeight = cardHeight * 0.52;
    const double radius = 35.0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantDetailsPage(
              index: index,
              heroTag: 'restaurant_$index', // unique per item
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1f2328),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image inset and rounded on all corners
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius - 6),
                child: SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: Hero(
                    tag: 'restaurant_$index',
                    child: Image.asset(
                      'assets/abc.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Content area
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ABC Restaurant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    'ABC Restaurant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),

                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 6),
                      Text('4.2', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 45),
                      Text('15 reviews',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class NavBarStyle15 extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBarStyle15({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _bg = Colors.black45;
  static const Color _yellow = Color(0xFFFFE780);
  static const Color _centerRed = Color(0xFFFF6B61);

  @override
  Widget build(BuildContext context) {
    const double centerSize = 72;
    const double ringSize = 92;

    return SizedBox(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(38)),
              child: Container(
                color: _bg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _navItem(Icons.home, "Home", 0),
                      _navItem(Icons.trending_up, "Trending", 1),

                      const SizedBox(width: 62), // empty space for center button

                      _navItem(Icons.card_giftcard, "Rewards", 3),
                      _navItem(Icons.account_circle, "Account", 4),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: SizedBox(
                width: ringSize,
                height: ringSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow behind ring
                    Container(
                      width: ringSize + 16,
                      height: ringSize + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    // Outer dark ring
                    Container(
                      width: ringSize,
                      height: ringSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F1212),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.45),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),

                    // Inner red circle
                    Container(
                      width: centerSize,
                      height: centerSize,
                      decoration: const BoxDecoration(
                        color: _centerRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        size: 38,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ITEM BUILDER ----------------
  Widget _navItem(IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? _yellow : _yellow.withOpacity(0.45);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
