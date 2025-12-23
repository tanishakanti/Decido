import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vibe2/Home/restInfo.dart';


class ReviewDetailsPage extends StatefulWidget {
  final int rating;
  ReviewDetailsPage({
    super.key,
    required this.rating,
  });

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  final Set<String> improvements = {};
  String waitTime = '';
  String company = '';

  bool get canSubmit =>
      improvements.isNotEmpty || waitTime.isNotEmpty || company.isNotEmpty;

  void _showExitOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'exit',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8 * animation.value,
            sigmaY: 8 * animation.value,
          ),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: _ExitPill(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => _showExitOverlay(context),
        ),
        title: const Text(
          "ABC Restaurant",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ratingCard(),
          const SizedBox(height: 16),
          _improvementSection(),
          const SizedBox(height: 16),
          _waitTimeSection(),
          const SizedBox(height: 16),
          _companySection(),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canSubmit ? Colors.redAccent : Colors.grey.shade400,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: canSubmit ? () {} : null,
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ---------------- Rating Card ----------------
  Widget _ratingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _ratingText(widget.rating),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < widget.rating
                        ? Colors.amber
                        : Colors.grey.shade300,
                  );
                }),
              ),
            ],
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFFFF3CD),
            child: Text("🙂"),
          )
        ],
      ),
    );
  }

  // ---------------- Improvement ----------------
  Widget _improvementSection() {
    return _section(
      title: "What can be improved?",
      options: const ["Food", "Beverages", "Service", "Ambience"],
      selected: improvements,
      multi: true,
    );
  }

  // ---------------- Wait Time ----------------
  Widget _waitTimeSection() {
    return _section(
      title: "How long did you wait to get seated?",
      options: const [
        "No wait",
        "Less than 10 mins",
        "10–30 mins",
        "Over 30 mins"
      ],
      selected: {waitTime},
      multi: false,
      onSingleSelect: (v) => setState(() => waitTime = v),
    );
  }

  // ---------------- Company ----------------
  Widget _companySection() {
    return _section(
      title: "Who did you go out with?",
      options: const ["Friends", "Partner", "Colleagues", "Family", "Solo"],
      selected: {company},
      multi: false,
      onSingleSelect: (v) => setState(() => company = v),
      subtitle:
      "We use this only to improve your experience, your responses are private",
    );
  }

  // ---------------- Reusable Section ----------------
  Widget _section({
    required String title,
    String? subtitle,
    required List<String> options,
    required Set<String> selected,
    required bool multi,
    Function(String)? onSingleSelect,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((o) {
              final isSelected = selected.contains(o);
              return ChoiceChip(
                label: Text(o),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    if (multi) {
                      isSelected
                          ? improvements.remove(o)
                          : improvements.add(o);
                    } else {
                      onSingleSelect?.call(o);
                    }
                  });
                },
                selectedColor: Colors.redAccent.withOpacity(0.15),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _ratingText(int r) {
    switch (r) {
      case 1:
        return "My experience was terrible";
      case 2:
        return "My experience was bad";
      case 3:
        return "My experience was average";
      case 4:
        return "My experience was good";
      case 5:
        return "My experience was amazing";
      default:
        return "";
    }
  }
}

class _ExitPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Submit review
            GestureDetector(
              onTap: () {
                // TODO: submit review logic
              },
              child: _pillButton(
                text: 'Submit review',
                bg: Colors.grey.shade200,
                textColor: Colors.black,
              ),
            ),

            const SizedBox(width: 10),

            // Discard & exit
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RestaurantDetailsPage(
                      index: 0,
                      heroTag: 'heroTag',
                    ), // restaurant detail page
                  ),
                      (route) => false,
                );
              },
              child: _pillButton(
                text: 'Discard & exit',
                bg: Colors.transparent,
                textColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillButton({
    required String text,
    required Color bg,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
