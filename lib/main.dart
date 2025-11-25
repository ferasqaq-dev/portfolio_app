import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feras Al Barghouthy Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF6366F1),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({Key? key}) : super(key: key);

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  bool isEnglish = true;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _particleController;
  late AnimationController _heroController;
  double scrollProgress = 0.0;
  String activeSection = 'home';

  var _homeKey = GlobalKey();
  var _aboutKey = GlobalKey();
  var _experienceKey = GlobalKey();
  var _projectsKey = GlobalKey();
  var _skillsKey = GlobalKey();
  var _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _scrollController.addListener(() {
      setState(() {
        scrollProgress = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(String section) {
    final positions = {
      'home': 0.0,
      'about': 800.0,
      'experience': 1400.0,
      'projects': 2200.0,
      'skills': 3200.0,
      'contact': 4000.0,
    };

    _scrollController.animateTo(
      positions[section] ?? 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Map<String, dynamic> get content {
    return isEnglish
        ? {
            'nav': [
              'Home',
              'About',
              'Experience',
              'Projects',
              'Skills',
              'Contact'
            ],
            'greeting': 'Hi, I\'m',
            'name': 'Feras Al Barghouthy',
            'altName': 'Feras Muien Zabayyan Qaq',
            'title': 'Computer Science Student',
            'subtitle': 'Full Stack Developer | AI Enthusiast | Problem Solver',
            'location': 'Ramallah, Palestine',
            'aboutTitle': 'About Me',
            'about':
                'I enjoy working with people to learn from their experiences and share my own. Programming is my passion; I practice daily, even with small, fun projects, not just professional ones. Currently seeking job opportunities in Web Development, AI, or Data Science.',
            'experienceTitle': 'Training Experience',
            'skillsTitle': 'Technical Skills',
            'projectsTitle': 'Featured Projects',
            'contactTitle': 'Get In Touch',
            'viewProject': 'View Details',
            'downloadCV': 'Download CV',
          }
        : {
            'nav': [
              'الرئيسية',
              'عني',
              'الخبرة',
              'المشاريع',
              'المهارات',
              'التواصل'
            ],
            'greeting': 'مرحبا، أنا',
            'name': 'فراس البرغوثي',
            'altName': 'فراس معين ظبيان قاق',
            'title': 'طالب علم حاسوب',
            'subtitle':
                'مطور Full Stack | مهتم بالذكاء الاصطناعي | حلّال مشاكل',
            'location': 'رام الله، فلسطين',
            'aboutTitle': 'عني',
            'about':
                'أستمتع بالعمل مع الناس لأتعلم من تجاربهم وأشارك تجاربي الخاصة. البرمجة شغفي؛ أمارسها يوميًا، حتى مع المشاريع الصغيرة الممتعة، وليس فقط المشاريع الاحترافية. أبحث حاليًا عن فرص عمل في تطوير الويب أو الذكاء الاصطناعي أو علوم البيانات.',
            'experienceTitle': 'الخبرة التدريبية',
            'skillsTitle': 'المهارات التقنية',
            'projectsTitle': 'المشاريع',
            'contactTitle': 'تواصل معي',
            'viewProject': 'عرض التفاصيل',
            'downloadCV': 'تحميل السيرة الذاتية',
          };
  }

  final experiences = [
    {
      'title': 'Full Stack Web Development Intern',
      'titleAr': 'متدرب تطوير ويب Full Stack',
      'company': 'Computer Center – Birzeit University',
      'companyAr': 'مركز الحاسوب - جامعة بيرزيت',
      'period': 'Jul 2025 – Sep 2025',
      'periodAr': 'يوليو 2025 – سبتمبر 2025',
      'description': [
        'Designed responsive restaurant pages using HTML, CSS, and Bootstrap',
        'Built a calculator application utilizing JavaScript, jQuery, and Bootstrap',
        'Developed a complete Quiz Management System with PHP and MySQL',
        'Gained exposure to Laravel framework and modern web development practices'
      ],
      'descriptionAr': [
        'تصميم صفحات مطاعم متجاوبة باستخدام HTML و CSS و Bootstrap',
        'بناء تطبيق آلة حاسبة باستخدام JavaScript و jQuery و Bootstrap',
        'تطوير نظام إدارة اختبارات كامل باستخدام PHP و MySQL',
        'اكتساب خبرة في Laravel وممارسات تطوير الويب الحديثة'
      ],
      'icon': '💼',
    }
  ];

  final projects = [
    {
      'title': 'HR Management System',
      'titleAr': 'نظام إدارة الموارد البشرية',
      'desc':
          'Mobile app for employee info, attendance, and salaries using Flutter and MySQL',
      'descAr':
          'تطبيق موبايل لمعلومات الموظفين والحضور والرواتب باستخدام Flutter و MySQL',
      'tech': 'Flutter, MySQL, Node.js',
      'status': 'In Progress',
      'statusAr': 'قيد التطوير',
      'icon': '👥',
      'color': const Color(0xFF6366F1),
    },
    {
      'title': 'Hospital Management System',
      'titleAr': 'نظام إدارة مستشفى',
      'desc':
          'System to manage patient records and appointments with SQL database',
      'descAr': 'نظام لإدارة سجلات المرضى والمواعيد مع قاعدة بيانات SQL',
      'tech': 'PHP, MySQL, SQL',
      'status': 'Completed',
      'statusAr': 'مكتمل',
      'icon': '🏥',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'E-Store Website',
      'titleAr': 'موقع متجر إلكتروني',
      'desc': 'Online store with product listing and order management',
      'descAr': 'متجر إلكتروني مع عرض المنتجات وإدارة الطلبات',
      'tech': 'HTML, CSS, PHP',
      'status': 'Completed',
      'statusAr': 'مكتمل',
      'icon': '🛒',
      'color': const Color(0xFF06B6D4),
    },
    {
      'title': 'Shortest Path Between Cities',
      'titleAr': 'أقصر مسار بين المدن',
      'desc': 'Dijkstra\'s algorithm implementation for finding shortest paths',
      'descAr': 'تطبيق خوارزمية Dijkstra لإيجاد أقصر المسارات',
      'tech': 'Java, Algorithms',
      'status': 'Completed',
      'statusAr': 'مكتمل',
      'icon': '🗺️',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Sudoku Solver Game',
      'titleAr': 'حلّال لعبة سودوكو',
      'desc': 'Sudoku puzzle solver using backtracking and recursion',
      'descAr': 'حل ألغاز السودوكو باستخدام التراجع والعودية',
      'tech': 'Java, Backtracking, File I/O',
      'status': 'Completed',
      'statusAr': 'مكتمل',
      'icon': '🎮',
      'color': const Color(0xFFF59E0B),
    },
  ];

  final skills = [
    {
      'name': 'Java',
      'level': 0.9,
      'icon': '☕',
      'color': const Color(0xFFF59E0B)
    },
    {
      'name': 'PHP',
      'level': 0.85,
      'icon': '🐘',
      'color': const Color(0xFF8B5CF6)
    },
    {
      'name': 'JavaScript',
      'level': 0.8,
      'icon': '⚡',
      'color': const Color(0xFFF59E0B)
    },
    {
      'name': 'HTML/CSS',
      'level': 0.9,
      'icon': '🎨',
      'color': const Color(0xFF06B6D4)
    },
    {
      'name': 'MySQL',
      'level': 0.85,
      'icon': '🗄️',
      'color': const Color(0xFF3B82F6)
    },
    {
      'name': 'Python',
      'level': 0.7,
      'icon': '🐍',
      'color': const Color(0xFF10B981)
    },
    {
      'name': 'Flutter',
      'level': 0.75,
      'icon': '📱',
      'color': const Color(0xFF06B6D4)
    },
    {
      'name': 'Laravel',
      'level': 0.65,
      'icon': '🔥',
      'color': const Color(0xFFEF4444)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ModernParticlePainter(
                    animation: _particleController.value,
                    scrollProgress: scrollProgress,
                  ),
                  child: Container(),
                );
              },
            ),

            // Main Content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Modern Navigation Bar
                _buildSliverAppBar(),

                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeroSection(),
                    _buildAboutSection(),
                    _buildExperienceSection(),
                    _buildProjectsSection(),
                    _buildSkillsSection(),
                    _buildContactSection(),
                    const SizedBox(height: 80),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final isScrolled = scrollProgress > 50;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: isScrolled
          ? const Color(0xFF1E293B).withOpacity(0.95)
          : Colors.transparent,
      elevation: isScrolled ? 8 : 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isEnglish ? 'F.Q' : 'ف.ق',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Desktop Navigation
        if (MediaQuery.of(context).size.width > 768)
          ...List.generate(6, (index) {
            final sections = [
              'home',
              'about',
              'experience',
              'projects',
              'skills',
              'contact'
            ];
            final labels = content['nav'] as List;
            return TextButton(
              onPressed: () => scrollToSection(sections[index]),
              child: Text(
                labels[index],
                style: TextStyle(
                  color: activeSection == sections[index]
                      ? const Color(0xFF6366F1)
                      : Colors.white70,
                  fontWeight: activeSection == sections[index]
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }),

        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () => setState(() => isEnglish = !isEnglish),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      key: _homeKey,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          // Animated gradient orbs
          Positioned(
            top: 100,
            right: -100,
            child: AnimatedBuilder(
              animation: _heroController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    50 * math.sin(_heroController.value * 2 * math.pi),
                    50 * math.cos(_heroController.value * 2 * math.pi),
                  ),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 150,
            left: -150,
            child: AnimatedBuilder(
              animation: _heroController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -30 * math.cos(_heroController.value * 2 * math.pi),
                    30 * math.sin(_heroController.value * 2 * math.pi),
                  ),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Hero Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _heroController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _heroController,
                      curve: Curves.easeOut,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content['greeting'],
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                              Color(0xFF06B6D4),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            content['name'],
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content['altName'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1).withOpacity(0.2),
                                const Color(0xFF8B5CF6).withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            content['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content['subtitle'],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF6366F1),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              content['location'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => scrollToSection('projects'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    isEnglish
                                        ? 'View Projects'
                                        : 'عرض المشاريع',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  //const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () => scrollToSection('contact'),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFF6366F1)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isEnglish ? 'Contact Me' : 'تواصل معي',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _heroController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      10 * math.sin(_heroController.value * 4 * math.pi),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isEnglish ? 'Scroll Down' : 'اسحب للأسفل',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      key: _aboutKey,
      padding: const EdgeInsets.all(80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(content['aboutTitle']),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1E293B).withOpacity(0.6),
                      const Color(0xFF334155).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['about'],
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.8,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildInfoChip('🎓', 'Birzeit University'),
                        _buildInfoChip('📊', 'GPA: 3.2/4.0'),
                        _buildInfoChip(
                            '🌐',
                            isEnglish
                                ? 'English: C1 Level'
                                : 'الإنجليزية: مستوى C1'),
                        _buildInfoChip('📱', '+972-56-699-0357'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      key: _experienceKey,
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(content['experienceTitle']),
          const SizedBox(height: 60),
          ...experiences.map((exp) {
            return Container(
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E293B).withOpacity(0.8),
                    const Color(0xFF334155).withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          exp['icon'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? exp['title'] as String
                                  : exp['titleAr'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEnglish
                                  ? exp['company'] as String
                                  : exp['companyAr'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEnglish
                                  ? exp['period'] as String
                                  : exp['periodAr'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...(isEnglish
                          ? exp['description'] as List<String>
                          : exp['descriptionAr'] as List<String>)
                      .map((desc) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6366F1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      key: _projectsKey,
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(content['projectsTitle']),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 768
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return _buildProjectCard(project, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1E293B).withOpacity(0.8),
                      (project['color'] as Color).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (project['color'] as Color).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  (project['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              project['icon'] as String,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: project['status'] == 'In Progress'
                                  ? const Color(0xFFF59E0B).withOpacity(0.2)
                                  : const Color(0xFF10B981).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isEnglish
                                  ? project['status'] as String
                                  : project['statusAr'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: project['status'] == 'In Progress'
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isEnglish
                            ? project['title'] as String
                            : project['titleAr'] as String,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isEnglish
                            ? project['desc'] as String
                            : project['descAr'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const Spacer(),
                      const Divider(
                        color: Color(0xFF334155),
                        height: 32,
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (project['tech'] as String).split(', ').map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      key: _skillsKey,
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(content['skillsTitle']),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 4
                  : constraints.maxWidth > 768
                      ? 3
                      : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return _buildSkillCard(skills[index], index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> skill, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 80)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E293B).withOpacity(0.8),
                    (skill['color'] as Color).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (skill['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    skill['icon'] as String,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    skill['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (skill['level'] as double) * value,
                      minHeight: 8,
                      backgroundColor: const Color(0xFF334155),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        skill['color'] as Color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${((skill['level'] as double) * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: skill['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    final contacts = [
      {
        'icon': Icons.email,
        'label': 'Email',
        'labelAr': 'البريد الإلكتروني',
        'value': 'ferasmuin@gmail.com',
        'color': const Color(0xFF6366F1),
      },
      {
        'icon': Icons.phone,
        'label': 'Palestine',
        'labelAr': 'فلسطين',
        'value': '+972-56-699-0357',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.phone,
        'label': 'UAE',
        'labelAr': 'الإمارات',
        'value': '+971-50-769-4213',
        'color': const Color(0xFF06B6D4),
      },
      {
        'icon': Icons.business,
        'label': 'LinkedIn',
        'labelAr': 'لينكد إن',
        'value': 'feras-qaq',
        'color': const Color(0xFF0A66C2),
      },
      {
        'icon': Icons.code,
        'label': 'GitHub',
        'labelAr': 'جيت هاب',
        'value': 'github.com/feras03',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.location_on,
        'label': 'Location',
        'labelAr': 'الموقع',
        'value': 'Ramallah, Palestine',
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Container(
      key: _contactKey,
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(content['contactTitle']),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 768
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E293B).withOpacity(0.8),
                          (contact['color'] as Color).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (contact['color'] as Color).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (contact['color'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            contact['icon'] as IconData,
                            color: contact['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isEnglish
                                    ? contact['label'] as String
                                    : contact['labelAr'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                contact['value'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFF06B6D4),
            ],
          ).createShader(bounds),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class ModernParticlePainter extends CustomPainter {
  final double animation;
  final double scrollProgress;

  ModernParticlePainter({
    required this.animation,
    required this.scrollProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 50; i++) {
      final random = math.Random(i);
      final baseX = size.width * random.nextDouble();
      final baseY = size.height * random.nextDouble();

      final x = baseX + 30 * math.sin(animation * 2 * math.pi + i);
      final y = baseY +
          30 * math.cos(animation * 2 * math.pi + i) -
          (scrollProgress * 0.1);

      final radius = random.nextDouble() * 2 + 1;

      paint.color = i % 3 == 0
          ? const Color(0xFF6366F1).withOpacity(0.3)
          : i % 3 == 1
              ? const Color(0xFF8B5CF6).withOpacity(0.3)
              : const Color(0xFF06B6D4).withOpacity(0.3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Create gradient mesh
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6366F1).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(ModernParticlePainter oldDelegate) => true;
}
