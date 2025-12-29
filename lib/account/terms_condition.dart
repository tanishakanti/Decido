import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Terms & Conditions",
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

            const SizedBox(height: 8),

            // ───────── CONTENT ─────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),

                    _Paragraph(
                      text:
                          "Lorem ipsum odor amet, consectetuer adipiscing elit. Ultricies fermentum id lobortis ligula malesuada nostra. Nullam molestie neque nibh tempor sed. Felis arcu torquent volutpat blandit suscipit proin gravida. Fusce aliquet conubia fermentum feugiat litora at est. Bibendum diam ridiculus quisque vivamus ullamcorper nam viverra finibus efficitur. Pretium nisl augue platea quisque ullamcorper nostra.",
                    ),

                    _Paragraph(
                      text:
                          "Mi consectetur commodo malesuada commodo amet dignissim. Volutpat vel interdum inceptos a montes commodo quisque ligula. Sollicitudin ultricies montes, arcu est urna lacinia magna. Aliquam dictum maximus bibendum natoque facilisis libero. Volutpat posuere ut ac in vulputate maecenas. Etiam auctor mus condimentum etiam dui torquent. Dictum convallis fusce maecenas fames sagittis malesuada. Tempor in mollis orci augue, nisl duis nascetur. Conubia facilisi magnis nulla aptent hac per fermentum ex.",
                    ),

                    _Paragraph(
                      text:
                          "Sollicitudin maximus platea fringilla ad lorem dui arcu duis conubia. Mollis senectus montes sapien risus conubia justo litora. Rutrum massa neque risus praesent; vulputate integer magnis non. Diam nostra penatibus platea proin aenean maximus class sem. Diam eros cursus cras consequat integer finibus curae porttitor. Aenean ipsum himenaeos suscipit curae placerat conubia sem rutrum posuere. Pellentesque pretium class lobortis rhoncus, elit accumsan gravida.",
                    ),

                    _Paragraph(
                      text:
                          "Consequat volutpat viverra purus fames integer. Placerat ad ullamcorper vestibulum suscipit, suscipit volutpat diam nostra integer. Egestas aptent habitant, sapien maecenas id a eleifend. Torquent turpis eget fermentum; scelerisque ac maecenas nisi lectus. Donec efficitur quam mattis.",
                    ),

                    SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────── PARAGRAPH WIDGET ─────────
class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
