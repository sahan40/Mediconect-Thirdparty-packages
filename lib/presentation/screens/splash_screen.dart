import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/navigation/navigation_extensions.dart';
import '../../core/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _textController;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _glowOpacity;

  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Make status bar transparent on splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Icon controller — 900ms
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Text controller — 700ms, starts after icon
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Icon scale: 0.6 → 1.0 with elastic overshoot
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    // Icon fade-in: 0 → 1
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Glow pulse: 0 → 1 → 0.6
    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    // Text slide up: offset(0, 0.3) → offset(0, 0)
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Text fade-in: 0 → 1
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Small initial delay
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Play icon animation
    await _iconController.forward();
    if (!mounted) return;

    // Short pause, then text appears
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _textController.forward();

    // Wait then navigate to login
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.28),

              // ── Animated icon card ──────────────────────────
              AnimatedBuilder(
                animation: _iconController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _iconOpacity.value,
                    child: Transform.scale(
                      scale: _iconScale.value,
                      child: _IconCard(glowOpacity: _glowOpacity.value),
                    ),
                  );
                },
              ),

              // ── Flexible spacer ─────────────────────────────
              const Spacer(),

              // ── Animated text block ─────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(position: _textSlide, child: child),
                  );
                },
                child: const _TextBlock(),
              ),

              const SizedBox(height: 32),

              // ── Page indicator dots ─────────────────────────
              const _PageDots(activeDot: 0, totalDots: 3),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final double glowOpacity;
  const _IconCard({required this.glowOpacity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Outer cyan glow ───────────────────────────────
          Opacity(
            opacity: glowOpacity * 0.25,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF29B6F6).withOpacity(0.55),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom-right accent glow spot ─────────────────
          Positioned(
            right: 16,
            top: 20,
            child: Opacity(
              opacity: glowOpacity * 0.6,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF29B6F6).withOpacity(0.8),
                      blurRadius: 20,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Main white card ───────────────────────────────
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                // Main soft shadow
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                // Cyan glow under card
                BoxShadow(
                  color: const Color(0xFF29B6F6).withOpacity(0.12),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF1E9FD8),
              size: 80,
            ),
          ),

          // ── Heartbeat line overlay (drawn on top of icon) ──
          Positioned(
            bottom: 62,
            left: 44,
            right: 44,
            child: CustomPaint(
              size: const Size(double.infinity, 18),
              painter: _HeartbeatLinePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartbeatLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.8
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    final path =
        Path()
          ..moveTo(0, midY)
          ..lineTo(w * 0.28, midY)
          ..lineTo(w * 0.38, midY - h * 0.85)
          ..lineTo(w * 0.48, midY + h * 0.75)
          ..lineTo(w * 0.58, midY)
          ..lineTo(w * 0.68, midY - h * 0.3)
          ..lineTo(w * 0.75, midY)
          ..lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TextBlock extends StatelessWidget {
  const _TextBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App name
        const Text(
          'MediConnect',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'Smart care, better health',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  final int activeDot;
  final int totalDots;

  const _PageDots({required this.activeDot, required this.totalDots});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF1E9FD8) : const Color(0xFFCDE8F5),
          ),
        );
      }),
    );
  }
}
