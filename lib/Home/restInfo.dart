import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibe2/Home/reviewRate.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final int index;
  final String heroTag;


  const RestaurantDetailsPage({
    super.key,
    required this.index,
    required this.heroTag,
  });

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}
enum BottomAction { book, pay }
BottomAction selectedAction = BottomAction.pay;

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final ImagePicker _picker = ImagePicker();
  List<XFile> userPhotos = [];

  final ScrollController _scrollController = ScrollController();

  // Tabs
  final List<Tab> myTabs = const [
    Tab(text: 'Pre-book offers'),
    Tab(text: 'Walk-in offers'),
    Tab(text: 'Menu'),
    Tab(text: 'Photos'),
    Tab(text: 'Reviews'),
    Tab(text: 'About'),
  ];

  final Map<String, GlobalKey> _sectionKeys = {
    'Pre-book offers': GlobalKey(),
    'Walk-in offers': GlobalKey(),
    'Menu': GlobalKey(),
    'Photos': GlobalKey(),
    'Reviews': GlobalKey(),
    'About': GlobalKey(),
  };


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<void> _callRestaurant(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Error: Could not launch phone dialer.");
    }
  }

  Future<void> _openDirections(double lat, double lng) async {
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Error: Could not open Google Maps.");
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        userPhotos.insert(0, image);
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        userPhotos.insert(0, image);
      });
    }
  }

  void _openAddPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Take photo", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text("Choose from gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),

            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _scrollToSection(String key) {
    final ctx = _sectionKeys[key]?.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.02, // just below pinned navbar
    );
  }

  void _updateTabOnScroll() {
    for (int i = myTabs.length - 1; i >= 0; i--) {
      final key = myTabs[i].text!;
      final ctx = _sectionKeys[key]?.currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final y = box.localToGlobal(Offset.zero).dy;

      if (y <= MediaQuery.of(context).padding.top + 120) {
        if (_tabController.index != i) {
          _tabController.animateTo(i);
        }
        break;
      }
    }
  }

  Widget _smallChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.32),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1F2937),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }


  Widget _cashbackBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF947F80),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Text('10%',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '10% CASHBACK on every dining bill',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }

  void _openPayBillSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0B0B0D),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Pay your bill",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _payOptionTile(
                          icon: Icons.account_balance_wallet,
                          title: "Pay via UPI / Wallet",
                          subtitle: "GPay, PhonePe, Paytm",
                        ),
                        _payOptionTile(
                          icon: Icons.credit_card,
                          title: "Credit / Debit Card",
                          subtitle: "Visa, Mastercard, RuPay",
                        ),
                        _payOptionTile(
                          icon: Icons.local_offer,
                          title: "Apply offers",
                          subtitle: "View available deals",
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE780),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Proceed to pay",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _payOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFE780)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenH = MediaQuery.of(context).size.height;
    final expandedHeight = screenH * 0.44;

    return Material(
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: SafeArea(
              top: false,
              child: Container(
                height: 84, // 🔥 FIXED HEIGHT (this is the key)
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // -------- BOOK A TABLE --------
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAction = BottomAction.book;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          height: 48, // 🔥 button height fixed
                          decoration: BoxDecoration(
                            color: selectedAction == BottomAction.book
                                ? const Color(0xFFFFE780)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFE780),
                              width: 1.4,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Book a table",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedAction == BottomAction.book
                                  ? Colors.black
                                  : const Color(0xFFFFE780),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // -------- PAY BILL --------
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAction = BottomAction.pay;
                          });
                          _openPayBillSheet(); // bottom sheet
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          height: 48, // 🔥 button height fixed
                          decoration: BoxDecoration(
                            color: selectedAction == BottomAction.pay
                                ? const Color(0xFFFFE780)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFE780),
                              width: 1.4,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: selectedAction == BottomAction.pay
                                ? const Text(
                              "Pay bill",
                              key: ValueKey("payActive"),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            )
                                : const Text(
                              "Pay bill",
                              key: ValueKey("payInactive"),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFE780),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          backgroundColor: const Color(0xFF0B0B0D),
          body: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                _updateTabOnScroll();
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildHero(expandedHeight),
                  _buildActionButtons(),
                  _buildCashback(),
                  _buildPinnedTabBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildSection("Pre-book offers"),
                        _buildSection("Walk-in offers"),
                        _buildSection("Menu"),
                        _buildSection("Photos"),
                        _buildSection("Reviews"),
                        _buildSection("About"),
                      ],
                    ),
                  ),
                ],
              )
          )
        ),
      ),
    );
  }

  Future<void> shareRestaurantWithImage() async {
    // Load image from assets
    final ByteData byteData = await rootBundle.load('assets/abc.png');
    final Uint8List bytes = byteData.buffer.asUint8List();

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/abc.png');

    // Write image to temp file
    await file.writeAsBytes(bytes);

    // Share image + text
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Check out this restaurant!\nABC Restaurant\nRating: 4.2 ⭐',
    );
  }

  Widget _buildHero(double expandedHeight) {
    return SliverAppBar(
      backgroundColor: Colors.black87,
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,

      leading: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.35),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),

      actions: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.35),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.35),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () async {
                  await shareRestaurantWithImage();
                },
              ),
            ),
          ),
        ),
      ],

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCollapsed =
              constraints.maxHeight <= kToolbarHeight + 20;
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 72, bottom: 12),

            title: isCollapsed
                ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: Colors.black.withOpacity(0.45),
                  child: const Text(
                    "ABC Restaurant",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
                : null,
            background: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isCollapsed ? 15 : 0,
                  sigmaY: isCollapsed ? 30 : 0,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // --- IMAGE ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: widget.heroTag,
                          child: Image.asset(
                            'assets/abc.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // --- GRADIENT ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.14),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 28,
                      right: 120,
                      bottom: 24,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ABC Restaurant',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Multi-cuisine • ₹250 for one',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13),
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              _smallChip(Icons.location_on, '1.1 km'),
                              const SizedBox(width: 8),
                              _smallChip(Icons.delivery_dining,
                                  'Free delivery'),
                            ])
                          ]),
                    ),

                    // Rating
                    Positioned(
                      right: 22,
                      bottom: 24,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            Text('4.2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(width: 6),
                            Icon(Icons.star, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

    Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: Row(
          children: [
            Expanded(
              child: _actionButton(
                icon: Icons.event_seat,
                label: 'Book a table',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionButton(
                icon: Icons.navigation,
                label: 'Direction',
                onTap: () => _openDirections(19.091, 72.916),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionButton(
                icon: Icons.call,
                label: 'Call',
                onTap: () => _callRestaurant('7208136999'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCashback() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
        child: _cashbackBanner(),
      ),
    );
  }

  Widget _buildPinnedTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHeaderDelegate(
        minHeight: 64,
        maxHeight: 64,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  height: 48,
                  constraints: const BoxConstraints(maxWidth: 380),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF393942),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    indicatorColor: Color(0xFF393942),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white70,
                    onTap: (i) {
                      final key = myTabs[i].text!;
                      _scrollToSection(key);
                    },
                    tabs: myTabs
                        .map((tab) => Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6),
                      child: Tab(
                        child: Text(
                          tab.text!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    late Widget content;

    switch (title) {
      case "Pre-book offers":
        content = _buildPreBookOffersSection();
        break;

      case "Walk-in offers":
        content = _buildWalkInOffersSection();
        break;

      case "Menu":
        content = _buildMenuSection();
        break;

      case "Photos":
        content = _buildPhotosSection();
        break;

      case "Reviews":
        content = _buildReviewsSection();
        break;

      case "About":
        content = _buildAboutSection();
        break;
    }

    return Container(
        key: _sectionKeys[title],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),
            sectionHeader(title),

            if (title == "Pre-book offers")
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  "Limited slots with extra offers",
                  style: TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),

            const SizedBox(height: 10),
            content,
            const SizedBox(height: 28),
          ],
        ),
    );
  }


  Widget _buildPreBookOffersSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE3E8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("FLAT 20% OFF",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("available for limited slots",
                          style: TextStyle(color: Colors.black54, fontSize: 12))
                    ]),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text("Book now",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF3B0B0C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "15 slots available from 5:15 PM today",
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildWalkInOffersSection() {
    String selectedDay = "Today";
    List<String> days = [
      "Today",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    bool isDropdownOpen = false;

    final Map<String, String> offerTextByDay = {
      "Today": "INSTANT OFFER\nFlat\n10% OFF\nValid all day",
      "Monday": "MONDAY DEAL\nFlat\n15% OFF\nLunch only",
      "Tuesday": "TUESDAY TREAT\nBuy 1 Get 1",
      "Wednesday": "MIDWEEK OFFER\n20% Cashback",
      "Thursday": "THURSDAY SPECIAL\nFree Dessert",
      "Friday": "WEEKEND STARTER\n10% OFF",
      "Saturday": "SATURDAY NIGHT\nLive Music + Offers",
      "Sunday": "SUNDAY BRUNCH\nFlat 25% OFF",
    };

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedDay == "Today"
                          ? const Color(0xFF3B0B0C)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text("Today's offers",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),

                  PopupMenuButton<String>(
                    offset: const Offset(0, 44),
                    color: const Color(0xFF1C1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    onOpened: () {
                      setState(() => isDropdownOpen = true);
                    },
                    onCanceled: () {
                      setState(() => isDropdownOpen = false);
                    },
                    onSelected: (value) {
                      setState(() {
                        selectedDay = value;
                        isDropdownOpen = false;
                      });
                    },

                    itemBuilder: (context) {
                      return offerTextByDay.keys.map((day) {
                        final bool isSelected = day == selectedDay;

                        return PopupMenuItem<String>(
                          value: day,
                          child: Row(
                            children: [
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.pinkAccent, size: 16),
                              if (isSelected) const SizedBox(width: 6),
                              Text(
                                day,
                                style: TextStyle(
                                  color: isSelected ? Colors.pinkAccent : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },

                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedDay,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 6),

                          AnimatedRotation(
                            turns: isDropdownOpen ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A3AA8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            offerTextByDay[selectedDay] ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "CASHBACK\nFlat\n10% cashback\nafter bill payment",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("BANK BENEFITS",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset("assets/abc.png",
                              width: 42, height: 42, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "10% OFF up to ₹1000 on Kotak Bank Payments\nUse code KOTAK1000",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                          (i) => Container(
                        margin: const EdgeInsets.all(4),
                        width: i == 0 ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == 0 ? Colors.white : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildMenuSection() {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          _menuCard("Food", "10 pages"),
          _menuCard("Bar", "7 pages"),
          _menuCard("Dessert", "5 pages"),
        ],
      ),
    );
  }

  Widget _menuCard(String title, String pages) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset("assets/abc.png",
                height: 140, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(pages, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }


  Widget _buildPhotosSection() {
    List<dynamic> imgs = [
      ...userPhotos,
      ...List.generate(10, (i) => "assets/abc.png"),
    ];

    int remaining = imgs.length - 6;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              imgs.length > 6 ? 6 : imgs.length,
                  (i) {
                if (i == 5 && remaining > 0) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(imgs[i],
                            width: 110, height: 110, fit: BoxFit.cover),
                      ),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.black54,
                        ),
                        child: Center(
                          child: Text(
                            "+$remaining",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(imgs[i],
                      width: 110, height: 110, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 14),

        GestureDetector(
          onTap: _openAddPhotoSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.pinkAccent.withOpacity(0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text(
              "➕ Add photo",
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final PageController _pageController =
    PageController(viewportFraction: 0.92);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),

        // REVIEW CAROUSEL
        SizedBox(
          height: 270,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _reviewCard(index),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Dots indicator
        // Center(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: List.generate(
        //       3,
        //           (i) => Container(
        //         margin: const EdgeInsets.all(4),
        //         width: i == 0 ? 10 : 6,
        //         height: 6,
        //         decoration: BoxDecoration(
        //           color: i == 0 ? Colors.white : Colors.grey,
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        const SizedBox(height: 10),

        // Leave review
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, color: Colors.pinkAccent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Leave a review",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

          ),
        ),

        const SizedBox(height: 14),

        Center(
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              "See all reviews →",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }


  Widget _reviewCard(int index) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ["Shikha Naikar", "Rohan Mehta", "Ananya Shah"][index],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${index + 1} days ago",
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Text("5",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 2),
                    Icon(Icons.star, size: 14, color: Colors.white),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            "This place is so beautiful, amazing. If you're going for a vibe, amazing if you're going for a date, it's great to go with family... read more",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 12),

          Row(
            children: List.generate(
              3,
                  (i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/abc.png",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),

        // Main info card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ₹2000 for two
              _aboutRow(
                icon: Icons.currency_rupee,
                text: "₹2000 for two",
                iconColor: Colors.orange,
              ),

              const SizedBox(height: 10),

              // Cuisine
              _aboutRow(
                icon: Icons.restaurant_menu,
                text: "North Indian, Asian, Continental",
                iconColor: Colors.white70,
              ),

              const SizedBox(height: 10),

              // Location
              _aboutRow(
                icon: Icons.location_on,
                text: "Chandivali, Powai, Mumbai",
                iconColor: Colors.redAccent,
              ),

              const SizedBox(height: 18),

              // Featured in
              const Text(
                "Featured In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Featured card
              Container(
                width: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14)),
                      child: Image.asset(
                        "assets/abc.png",
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Insta-worthy spots",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Facilities
              const Text(
                "Facilities",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column
                  Expanded(
                    child: Column(
                      children: const [
                        _FacilityItem(text: "Dinner"),
                        _FacilityItem(text: "Lunch"),
                        _FacilityItem(text: "Home delivery"),
                      ],
                    ),
                  ),

                  // Right column
                  Expanded(
                    child: Column(
                      children: const [
                        _FacilityItem(text: "Takeaway available"),
                        _FacilityItem(text: "Wheelchair accessible"),
                        _FacilityItem(text: "Serves alcohol"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Explore other restaurants",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 210,
          child: CarouselView(
            itemExtent: 250,
            shrinkExtent: 150,
            itemSnapping: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: List.generate(
              4,
                  (index) => _exploreRestaurantCard(),
            ),
          ),
        ),

      ],
    );
  }

  Widget _aboutRow({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            color: Colors.black.withOpacity(0.4),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _exploreRestaurantCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14191d),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'assets/abc.png',
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Shalimar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text("4.2", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Text("4.7 km", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityItem extends StatelessWidget {
  final String text;
  const _FacilityItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.65),
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) =>
      oldDelegate.child != child ||
          oldDelegate.minHeight != minHeight ||
          oldDelegate.maxHeight != maxHeight;
}