import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(const PortfolioApp());
}

// ─── Color Palette ────────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF070B18);
  static const surface = Color(0xFF0D1526);
  static const surfaceElevated = Color(0xFF131D33);
  static const border = Color(0xFF1E2D4A);
  static const violet = Color(0xFF7C3AED);
  static const violetLight = Color(0xFF9D5CF6);
  static const cyan = Color(0xFF22D3EE);
  static const cyanDim = Color(0xFF0891B2);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF475569);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
}

// ─── App ──────────────────────────────────────────────────────────────────────
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firas Qaq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        primaryColor: AppColors.violet,
      ),
      home: const PortfolioPage(),
    );
  }
}

// ─── Main Page ────────────────────────────────────────────────────────────────
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with TickerProviderStateMixin {
  bool isEnglish = true;
  final ScrollController _scroll = ScrollController();
  late AnimationController _bgController;
  late AnimationController _navController;
  double _scrollOffset = 0;

  final _sectionKeys = {
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scroll.addListener(() {
      setState(() => _scrollOffset = _scroll.offset);
      if (_scroll.offset > 80) {
        _navController.forward();
      } else {
        _navController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _navController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(String key) {
    final ctx = _sectionKeys[key]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            // ── Ambient Background ──
            AnimatedBuilder(
              animation: _bgController,
              builder: (_, __) => CustomPaint(
                painter: AmbientBgPainter(_bgController.value, _scrollOffset),
                size: Size.infinite,
              ),
            ),

            // ── Content ──
            CustomScrollView(
              controller: _scroll,
              slivers: [
                _buildNav(),
                SliverList(
                  delegate: SliverChildListDelegate([
                    HeroSection(
                      key: _sectionKeys['hero'],
                      isEnglish: isEnglish,
                      onViewProjects: () => _scrollTo('projects'),
                      onContact: () => _scrollTo('contact'),
                    ),
                    AboutSection(
                        key: _sectionKeys['about'], isEnglish: isEnglish),
                    ExperienceSection(
                        key: _sectionKeys['experience'], isEnglish: isEnglish),
                    ProjectsSection(
                        key: _sectionKeys['projects'], isEnglish: isEnglish),
                    SkillsSection(
                        key: _sectionKeys['skills'], isEnglish: isEnglish),
                    ContactSection(
                        key: _sectionKeys['contact'], isEnglish: isEnglish),
                    const _Footer(),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNav() {
    final labels = isEnglish
        ? ['Home', 'About', 'Experience', 'Projects', 'Skills', 'Contact']
        : ['الرئيسية', 'عني', 'الخبرة', 'المشاريع', 'المهارات', 'التواصل'];
    final keys = [
      'hero',
      'about',
      'experience',
      'projects',
      'skills',
      'contact'
    ];

    final isWide = MediaQuery.of(context).size.width > 800;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: AnimatedBuilder(
        animation: _navController,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Color.lerp(Colors.transparent,
                AppColors.surface.withOpacity(0.95), _navController.value),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withOpacity(_navController.value),
                width: 1,
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          // Nav links — left side in EN (LTR), right side in AR (RTL) thanks to Directionality
          if (isWide)
            ...List.generate(
                labels.length,
                (i) => _NavItem(
                      label: labels[i],
                      onTap: () => _scrollTo(keys[i]),
                    )),
          const Spacer(),
          _LangToggle(
            isEnglish: isEnglish,
            onToggle: () => setState(() => isEnglish = !isEnglish),
          ),
          const SizedBox(width: 12),
          _NavLogo(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Nav Widgets ──────────────────────────────────────────────────────────────
class _NavLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.violet.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(colors: [
          AppColors.violet.withOpacity(0.15),
          AppColors.cyan.withOpacity(0.05),
        ]),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('>',
            style: TextStyle(
                color: AppColors.cyan, fontSize: 14, fontFamily: 'monospace')),
        const SizedBox(width: 6),
        const Text('feras.dev',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600)),
        Text('_',
            style: TextStyle(
                color: AppColors.violet,
                fontSize: 14,
                fontFamily: 'monospace')),
      ]),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.onTap});
  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _hovered
                ? AppColors.violet.withOpacity(0.15)
                : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              color: _hovered ? AppColors.cyan : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback onToggle;
  const _LangToggle({required this.isEnglish, required this.onToggle});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isEnglish ? 'عربي' : 'EN',
          style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontFamily: 'monospace'),
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────
class HeroSection extends StatefulWidget {
  final bool isEnglish;
  final VoidCallback onViewProjects;
  final VoidCallback onContact;
  const HeroSection({
    Key? key,
    required this.isEnglish,
    required this.onViewProjects,
    required this.onContact,
  }) : super(key: key);
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _typeController;
  late AnimationController _fadeController;
  late AnimationController _floatController;
  String _displayedText = '';
  String _targetText = 'Firas Qaq';
  Timer? _typeTimer;
  int _charIndex = 0;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _typeController = AnimationController(vsync: this, duration: Duration.zero);

    Future.delayed(const Duration(milliseconds: 600), _startTyping);

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _showCursor = !_showCursor);
    });
  }

  void _startTyping() {
    _targetText = widget.isEnglish ? 'Firas Qaq' : 'فراس قاق';
    _typeTimer = Timer.periodic(const Duration(milliseconds: 70), (t) {
      if (_charIndex < _targetText.length) {
        if (mounted) {
          setState(
              () => _displayedText = _targetText.substring(0, ++_charIndex));
        }
      } else {
        t.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(HeroSection old) {
    super.didUpdateWidget(old);
    if (old.isEnglish != widget.isEnglish) {
      _typeTimer?.cancel();
      _charIndex = 0;
      setState(() => _displayedText = '');
      _targetText = widget.isEnglish ? 'Firas Qaq' : 'فراس قاق';
      _startTyping();
    }
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    _fadeController.dispose();
    _floatController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return FadeTransition(
      opacity: _fadeController,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Grid overlay
            CustomPaint(painter: _DotGridPainter(), size: Size.infinite),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Eyebrow ──
                    SlideIn(
                      delay: 200,
                      child: Row(children: [
                        Container(
                          width: 32,
                          height: 1,
                          color: AppColors.cyan,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.isEnglish
                              ? '// hello world'
                              : '// مرحبا بالعالم',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: AppColors.cyan,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 24),

                    // ── Name typewriter ──
                    SlideIn(
                      delay: 400,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: _displayedText,
                            style: TextStyle(
                              fontSize: isMobile ? 42 : 72,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.05,
                              letterSpacing: -1,
                            ),
                          ),
                          TextSpan(
                            text: _showCursor ? '|' : ' ',
                            style: TextStyle(
                              fontSize: isMobile ? 42 : 72,
                              fontWeight: FontWeight.w200,
                              color: AppColors.violet,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Role tags ──
                    SlideIn(
                      delay: 600,
                      child: Wrap(spacing: 10, runSpacing: 10, children: [
                        _RoleTag(
                            widget.isEnglish
                                ? 'Full Stack Developer'
                                : 'مطور Full Stack',
                            AppColors.violet),
                        _RoleTag(
                            widget.isEnglish
                                ? 'AI Enthusiast'
                                : 'مهتم بالذكاء الاصطناعي',
                            AppColors.cyan),
                        _RoleTag(
                            widget.isEnglish ? 'Problem Solver' : 'حلّال مشاكل',
                            AppColors.green),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // ── Location ──
                    SlideIn(
                      delay: 700,
                      child: Row(children: [
                        Icon(Icons.location_on_outlined,
                            color: AppColors.textMuted, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          widget.isEnglish ? 'Dubai, UAE' : 'دبي، الإمارات',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              fontFamily: 'monospace'),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 48),

                    // ── CTAs ──
                    SlideIn(
                      delay: 900,
                      child: Wrap(spacing: 16, runSpacing: 12, children: [
                        _PrimaryButton(
                          label: widget.isEnglish
                              ? 'View Projects'
                              : 'عرض المشاريع',
                          onTap: widget.onViewProjects,
                        ),
                        _GhostButton(
                          label:
                              widget.isEnglish ? 'Get in Touch' : 'تواصل معي',
                          onTap: widget.onContact,
                        ),
                      ]),
                    ),

                    const SizedBox(height: 80),

                    // ── Social quick links ──
                    SlideIn(
                      delay: 1100,
                      child: Row(children: [
                        _SocialPill(
                          icon: Icons.code,
                          label: 'GitHub',
                          url: 'github.com/ferasqaq-dev',
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        _SocialPill(
                          icon: Icons.business_center_outlined,
                          label: 'LinkedIn',
                          url: 'linkedin.com/in/feras-qaq',
                          color: Color(0xFF0A66C2),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),

            // ── Scroll hint ──
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, 6 * _floatController.value),
                  child: Column(children: [
                    Text(
                      widget.isEnglish ? 'scroll' : 'اسحب',
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.textMuted,
                          fontSize: 11,
                          letterSpacing: 2),
                    ),
                    const SizedBox(height: 6),
                    Container(
                        width: 1,
                        height: 32,
                        color: AppColors.textMuted.withOpacity(0.5)),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleTag extends StatelessWidget {
  final String label;
  final Color color;
  const _RoleTag(this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
        color: color.withOpacity(0.08),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: color,
            letterSpacing: 0.5),
      ),
    );
  }
}

class _SocialPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final Color color;
  const _SocialPill(
      {required this.icon,
      required this.label,
      required this.url,
      required this.color});
  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  _hovered ? widget.color.withOpacity(0.6) : AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: _hovered ? widget.color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon,
              size: 16, color: _hovered ? widget.color : AppColors.textMuted),
          const SizedBox(width: 8),
          Text(widget.label,
              style: TextStyle(
                  fontSize: 13,
                  color: _hovered ? widget.color : AppColors.textMuted,
                  fontFamily: 'monospace')),
        ]),
      ),
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────
class AboutSection extends StatelessWidget {
  final bool isEnglish;
  const AboutSection({Key? key, required this.isEnglish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return _SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(isEnglish ? '01 / about' : '01 / عني'),
          const SizedBox(height: 12),
          _SectionTitle(isEnglish ? 'Who I Am' : 'من أنا'),
          const SizedBox(height: 48),
          if (isMobile) ...[
            _AboutText(isEnglish: isEnglish),
            const SizedBox(height: 32),
            _AboutChips(isEnglish: isEnglish),
          ] else
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: _AboutText(isEnglish: isEnglish)),
              const SizedBox(width: 60),
              Expanded(flex: 2, child: _AboutChips(isEnglish: isEnglish)),
            ]),
        ],
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  final bool isEnglish;
  const _AboutText({required this.isEnglish});
  @override
  Widget build(BuildContext context) {
    final text = isEnglish
        ? 'I enjoy working with people to learn from their experiences and share my own. Programming is my passion — I practice daily, even with small fun projects outside the professional scope.\n\nCurrently seeking opportunities in Web Development, AI, or Data Science where I can grow fast and contribute meaningfully.'
        : 'أستمتع بالعمل مع الناس لأتعلم من تجاربهم وأشارك تجاربي الخاصة. البرمجة شغفي — أمارسها يوميًا حتى مع المشاريع الصغيرة الممتعة.\n\nأبحث حاليًا عن فرص في تطوير الويب أو الذكاء الاصطناعي أو علوم البيانات.';

    return SlideIn(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          height: 1.9,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _AboutChips extends StatelessWidget {
  final bool isEnglish;
  const _AboutChips({required this.isEnglish});
  @override
  Widget build(BuildContext context) {
    final chips = [
      (
        Icons.school_outlined,
        isEnglish ? 'Birzeit University' : 'جامعة بيرزيت'
      ),
      (Icons.star_outline, 'GPA 3.2 / 4.0'),
      (Icons.translate, isEnglish ? 'English C1' : 'إنجليزي C1'),
      (Icons.phone_outlined, '+971-55-962-8712'),
      (Icons.email_outlined, 'ferasmuin@gmail.com'),
    ];

    return SlideIn(
      delay: 200,
      child: Column(
        children: chips
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Icon(c.$1, color: AppColors.violet, size: 18),
                      const SizedBox(width: 14),
                      Text(c.$2,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontFamily: 'monospace')),
                    ]),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ─── Experience Section ───────────────────────────────────────────────────────
class ExperienceSection extends StatelessWidget {
  final bool isEnglish;
  const ExperienceSection({Key? key, required this.isEnglish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      accent: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(isEnglish ? '02 / experience' : '02 / الخبرة',
              color: AppColors.cyan),
          const SizedBox(height: 12),
          _SectionTitle(isEnglish ? 'Training Experience' : 'الخبرة التدريبية'),
          const SizedBox(height: 48),
          _ExperienceCard(isEnglish: isEnglish),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final bool isEnglish;
  const _ExperienceCard({required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final bullets = isEnglish
        ? [
            'Designed responsive restaurant pages using HTML, CSS, and Bootstrap',
            'Built a calculator application utilizing JavaScript, jQuery, and Bootstrap',
            'Developed a complete Quiz Management System with PHP and MySQL',
            'Gained exposure to Laravel framework and modern web development practices',
          ]
        : [
            'تصميم صفحات مطاعم متجاوبة باستخدام HTML و CSS و Bootstrap',
            'بناء تطبيق آلة حاسبة باستخدام JavaScript و jQuery و Bootstrap',
            'تطوير نظام إدارة اختبارات كامل باستخدام PHP و MySQL',
            'اكتساب خبرة في Laravel وممارسات تطوير الويب الحديثة',
          ];

    return SlideIn(
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withOpacity(0.04),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot
            Column(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.violet, AppColors.cyan],
                  ),
                ),
                child: const Icon(Icons.work_outline,
                    color: Colors.white, size: 22),
              ),
              Container(width: 2, height: 180, color: AppColors.border),
            ]),
            const SizedBox(width: 28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? 'Full Stack Web Development Intern'
                                  : 'متدرب تطوير ويب Full Stack',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isEnglish
                                  ? 'Computer Center – Birzeit University'
                                  : 'مركز الحاسوب - جامعة بيرزيت',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.cyan,
                                  fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEnglish ? 'Jul – Sep 2025' : 'يوليو – سبتمبر 2025',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...bullets.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                      color: AppColors.cyan,
                                      shape: BoxShape.circle)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Text(b,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textSecondary,
                                        height: 1.6))),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Projects Section ─────────────────────────────────────────────────────────
class ProjectsSection extends StatelessWidget {
  final bool isEnglish;
  const ProjectsSection({Key? key, required this.isEnglish}) : super(key: key);

  static final _projects = [
    _ProjectData(
      titleEn: 'HR Management System',
      titleAr: 'نظام إدارة الموارد البشرية',
      descEn: 'Mobile app for employee info, attendance, and salaries.',
      descAr: 'تطبيق موبايل لمعلومات الموظفين والحضور والرواتب.',
      tech: ['Flutter', 'MySQL', 'Node.js'],
      status: 'In Progress',
      icon: '👥',
      color: AppColors.violet,
    ),
    _ProjectData(
      titleEn: 'Hospital Management System',
      titleAr: 'نظام إدارة مستشفى',
      descEn:
          'Manage patient records and appointments with a full SQL backend.',
      descAr: 'إدارة سجلات المرضى والمواعيد مع قاعدة بيانات SQL.',
      tech: ['PHP', 'MySQL'],
      status: 'Completed',
      icon: '🏥',
      color: AppColors.cyan,
    ),
    _ProjectData(
      titleEn: 'E-Store Website',
      titleAr: 'موقع متجر إلكتروني',
      descEn: 'Online store with product listing and order management.',
      descAr: 'متجر إلكتروني مع عرض المنتجات وإدارة الطلبات.',
      tech: ['HTML', 'CSS', 'PHP'],
      status: 'Completed',
      icon: '🛒',
      color: AppColors.green,
    ),
    _ProjectData(
      titleEn: 'Shortest Path Between Cities',
      titleAr: 'أقصر مسار بين المدن',
      descEn:
          "Dijkstra's algorithm for finding shortest paths on a city graph.",
      descAr: 'خوارزمية Dijkstra لإيجاد أقصر المسارات بين المدن.',
      tech: ['Java', 'Algorithms'],
      status: 'Completed',
      icon: '🗺️',
      color: AppColors.amber,
    ),
    _ProjectData(
      titleEn: 'Sudoku Solver',
      titleAr: 'حلّال لعبة سودوكو',
      descEn:
          'Sudoku puzzle solver using backtracking and recursion with file I/O.',
      descAr: 'حل ألغاز السودوكو باستخدام التراجع والعودية مع قراءة الملفات.',
      tech: ['Java', 'Backtracking', 'File I/O'],
      status: 'Completed',
      icon: '🎮',
      color: Color(0xFFEC4899),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 1100
        ? 3
        : w > 700
            ? 2
            : 1;

    return _SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(isEnglish ? '03 / projects' : '03 / المشاريع'),
          const SizedBox(height: 12),
          _SectionTitle(isEnglish ? 'Featured Work' : 'أبرز المشاريع'),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 0.9,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: _projects.length,
            itemBuilder: (_, i) => _ProjectCard(
              project: _projects[i],
              isEnglish: isEnglish,
              index: i,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String titleEn, titleAr, descEn, descAr, status, icon;
  final List<String> tech;
  final Color color;
  const _ProjectData({
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
    required this.tech,
    required this.status,
    required this.icon,
    required this.color,
  });
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  final bool isEnglish;
  final int index;
  const _ProjectCard(
      {required this.project, required this.isEnglish, required this.index});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final isProgress = p.status == 'In Progress';

    return SlideIn(
      delay: widget.index * 80,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered ? p.color.withOpacity(0.5) : AppColors.border,
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: p.color.withOpacity(0.12),
                        blurRadius: 32,
                        spreadRadius: -4)
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(p.icon, style: const TextStyle(fontSize: 36)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isProgress
                            ? AppColors.amber.withOpacity(0.5)
                            : AppColors.green.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: isProgress
                          ? AppColors.amber.withOpacity(0.08)
                          : AppColors.green.withOpacity(0.08),
                    ),
                    child: Text(
                      widget.isEnglish
                          ? p.status
                          : (isProgress ? 'قيد التطوير' : 'مكتمل'),
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: isProgress ? AppColors.amber : AppColors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.isEnglish ? p.titleEn : p.titleAr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  widget.isEnglish ? p.descEn : p.descAr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: p.tech
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: p.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: p.color.withOpacity(0.25)),
                          ),
                          child: Text(t,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: p.color)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Skills Section ───────────────────────────────────────────────────────────
class SkillsSection extends StatelessWidget {
  final bool isEnglish;
  const SkillsSection({Key? key, required this.isEnglish}) : super(key: key);

  static const _skills = [
    ('Java', 0.90, '☕', AppColors.amber),
    ('PHP', 0.85, '🐘', Color(0xFF8B5CF6)),
    ('JavaScript', 0.80, '⚡', AppColors.amber),
    ('HTML / CSS', 0.90, '🎨', AppColors.cyan),
    ('MySQL', 0.85, '🗄️', Color(0xFF3B82F6)),
    ('Python', 0.70, '🐍', AppColors.green),
    ('Flutter', 0.75, '📱', AppColors.cyan),
    ('Laravel', 0.65, '🔥', Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 1100
        ? 4
        : w > 700
            ? 3
            : 2;

    return _SectionWrapper(
      accent: AppColors.violet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(isEnglish ? '04 / skills' : '04 / المهارات'),
          const SizedBox(height: 12),
          _SectionTitle(isEnglish ? 'Technical Stack' : 'المهارات التقنية'),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 1.15,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _skills.length,
            itemBuilder: (_, i) {
              final s = _skills[i];
              return SlideIn(
                delay: i * 60,
                child: _SkillCard(
                    name: s.$1, level: s.$2, icon: s.$3, color: s.$4),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String name, icon;
  final double level;
  final Color color;
  const _SkillCard(
      {required this.name,
      required this.level,
      required this.icon,
      required this.color});
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _barController;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim =
        CurvedAnimation(parent: _barController, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _barController.forward();
    });
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? widget.color.withOpacity(0.5) : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 10),
            Text(widget.name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _barAnim,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.level * _barAnim.value,
                  minHeight: 5,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(widget.color),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(widget.level * 100).toInt()}%',
              style: TextStyle(
                  fontSize: 12, fontFamily: 'monospace', color: widget.color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Contact Section ──────────────────────────────────────────────────────────
class ContactSection extends StatelessWidget {
  final bool isEnglish;
  const ContactSection({Key? key, required this.isEnglish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 900
        ? 3
        : w > 600
            ? 2
            : 1;

    final contacts = [
      (
        Icons.email_outlined,
        isEnglish ? 'Email' : 'البريد',
        'ferasmuin@gmail.com',
        AppColors.violet
      ),
      (
        Icons.phone_outlined,
        isEnglish ? 'Phone' : 'الهاتف',
        '+971-55-962-8712',
        AppColors.cyan
      ),
      (
        Icons.business_center_outlined,
        'LinkedIn',
        'linkedin.com/in/feras-qaq',
        const Color(0xFF0A66C2)
      ),
      (Icons.code, 'GitHub', 'github.com/ferasqaq-dev', Color(0xFF8B5CF6)),
      (
        Icons.location_on_outlined,
        isEnglish ? 'Location' : 'الموقع',
        isEnglish ? 'Dubai, UAE' : 'دبي، الإمارات',
        AppColors.amber
      ),
    ];

    return _SectionWrapper(
      accent: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(isEnglish ? '05 / contact' : '05 / تواصل',
              color: AppColors.cyan),
          const SizedBox(height: 12),
          _SectionTitle(isEnglish ? 'Get In Touch' : 'تواصل معي'),
          const SizedBox(height: 12),
          Text(
            isEnglish
                ? 'Open to opportunities, collaborations, and interesting conversations.'
                : 'مفتوح للفرص والتعاون والمحادثات الممتعة.',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 2.8,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: contacts.length,
            itemBuilder: (_, i) {
              final c = contacts[i];
              return SlideIn(
                delay: i * 60,
                child: _ContactCard(
                    icon: c.$1, label: c.$2, value: c.$3, color: c.$4),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _ContactCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered ? widget.color.withOpacity(0.5) : AppColors.border,
          ),
        ),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, color: widget.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                        letterSpacing: 0.5)),
                const SizedBox(height: 3),
                Text(widget.value,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('© 2025 Firas Qaq',
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontFamily: 'monospace')),
          Text('Built with Flutter',
              style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.6),
                  fontSize: 12,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }
}

// ─── Shared Section Widgets ───────────────────────────────────────────────────
class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color accent;
  const _SectionWrapper({required this.child, this.accent = AppColors.violet});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, {this.color = AppColors.violet});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        letterSpacing: 2,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -0.5,
      ),
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});
  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [AppColors.violetLight, AppColors.cyan]
                  : [AppColors.violet, AppColors.violetLight],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppColors.violet.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: -4)
                  ]
                : [],
          ),
          child: Text(widget.label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});
  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
                color: _hovered ? AppColors.violet : AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: _hovered
                ? AppColors.violet.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Text(widget.label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? AppColors.violet : AppColors.textSecondary,
                  letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

// ─── Slide-In Animation Widget ────────────────────────────────────────────────
class SlideIn extends StatefulWidget {
  final Widget child;
  final int delay;
  const SlideIn({super.key, required this.child, this.delay = 0});
  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── Ambient Background Painter ───────────────────────────────────────────────
class AmbientBgPainter extends CustomPainter {
  final double t;
  final double scroll;
  AmbientBgPainter(this.t, this.scroll);

  @override
  void paint(Canvas canvas, Size size) {
    // Dot grid
    final dotPaint = Paint()..color = AppColors.border.withOpacity(0.6);
    const spacing = 36.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        canvas.drawCircle(Offset(i * spacing, j * spacing), 1, dotPaint);
      }
    }

    // Ambient orbs
    _drawOrb(
      canvas,
      size,
      cx: size.width * 0.85 + 60 * math.sin(t * 2 * math.pi),
      cy: size.height * 0.15 + 40 * math.cos(t * 2 * math.pi),
      r: 300,
      color: AppColors.violet.withOpacity(0.12),
    );
    _drawOrb(
      canvas,
      size,
      cx: size.width * 0.1 + 40 * math.cos(t * 2 * math.pi + 1),
      cy: size.height * 0.7 + 50 * math.sin(t * 2 * math.pi + 1),
      r: 250,
      color: AppColors.cyan.withOpacity(0.07),
    );
  }

  void _drawOrb(Canvas canvas, Size size,
      {required double cx,
      required double cy,
      required double r,
      required Color color}) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [color, Colors.transparent])
          .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, paint);
  }

  @override
  bool shouldRepaint(AmbientBgPainter old) => true;
}

// ─── Dot Grid Painter (hero overlay) ─────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.violet.withOpacity(0.03);
    const s = 28.0;
    for (var x = 0.0; x < size.width; x += s) {
      for (var y = 0.0; y < size.height; y += s) {
        canvas.drawCircle(Offset(x, y), 1.5, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
