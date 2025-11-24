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
      title: 'Feras Qaq Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue[700],
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple[400],
        scaffoldBackgroundColor: const Color(0xFF111827),
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
  bool isDarkMode = true;
  bool isEnglish = true;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, String> get content {
    return isEnglish
        ? {
            'name': 'Feras Muien Zabayyan Qaq',
            'altName': 'Firas Al Barghouthy',
            'title': 'Computer Science Student',
            'location': 'Palestine → Dubai',
            'about':
                'I enjoy working with people to learn from their experiences and share my own. Programming is my passion; I practice daily, even with small, fun projects, not just professional ones.',
            'skills': 'Skills',
            'projects': 'Projects',
            'contact': 'Contact',
            'comingSoon': 'Coming Soon',
            'email': 'Email',
            'github': 'GitHub',
            'linkedin': 'LinkedIn',
          }
        : {
            'name': 'فراس معين ظبيان قاق',
            'altName': 'فراس البرغوثي',
            'title': 'طالب علوم حاسوب',
            'location': 'فلسطين ← دبي',
            'about':
                'أستمتع بالعمل مع الناس لأتعلم من تجاربهم وأشارك تجاربي الخاصة. البرمجة شغفي؛ أمارسها يوميًا، حتى مع المشاريع الصغيرة الممتعة، وليس فقط المشاريع الاحترافية.',
            'skills': 'المهارات',
            'projects': 'المشاريع',
            'contact': 'التواصل',
            'comingSoon': 'قريبًا',
            'email': 'البريد الإلكتروني',
            'github': 'جيت هاب',
            'linkedin': 'لينكد إن',
          };
  }

  Color get primaryColor =>
      isDarkMode ? Colors.purple[400]! : Colors.purple[700]!;
  Color get secondaryColor =>
      isDarkMode ? Colors.blue[400]! : Colors.blue[700]!;
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF111827) : const Color(0xFFF5F5F5);
  Color get cardColor => isDarkMode ? const Color(0xFF1F2937) : Colors.white;
  Color get textColor => isDarkMode ? Colors.white : Colors.black87;
  Color get subtextColor => isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    animation: _particleController.value,
                    isDark: isDarkMode,
                  ),
                  child: Container(),
                );
              },
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          _buildHeroSection(),
                          _buildSkillsSection(),
                          _buildProjectsSection(),
                          _buildContactSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryColor, secondaryColor],
            ).createShader(bounds),
            child: Text(
              isEnglish ? 'F.Q' : 'ف.ق',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEnglish = !isEnglish;
                  });
                },
                icon: Icon(Icons.language, color: primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        constraints: const BoxConstraints(minHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [primaryColor, secondaryColor, primaryColor],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: Text(
                content['name']!,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content['altName']!,
              style: TextStyle(fontSize: 24, color: subtextColor),
            ),
            const SizedBox(height: 12),
            Text(
              content['title']!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('📍', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  content['location']!,
                  style: TextStyle(fontSize: 18, color: subtextColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              content['about']!,
              style: TextStyle(fontSize: 18, color: textColor, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = [
      {'name': 'Flutter', 'icon': Icons.layers, 'level': 0.85},
      {'name': 'Python', 'icon': Icons.code, 'level': 0.90},
      {'name': 'JavaScript', 'icon': Icons.terminal, 'level': 0.80},
      {'name': 'Database', 'icon': Icons.storage, 'level': 0.75},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: primaryColor, size: 32),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ).createShader(bounds),
                child: Text(
                  content['skills']!,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: _buildSkillCard(
                            skills[index]['name'] as String,
                            skills[index]['icon'] as IconData,
                            skills[index]['level'] as double,
                            value,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
    String name,
    IconData icon,
    double level,
    double animationValue,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: level * animationValue,
                minHeight: 12,
                backgroundColor: isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(primaryColor, secondaryColor, 0.5)!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryColor, secondaryColor],
            ).createShader(bounds),
            child: Text(
              content['projects']!,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                content['comingSoon']!,
                style: TextStyle(fontSize: 28, color: subtextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    final contacts = [
      {
        'title': content['email']!,
        'icon': Icons.email,
        'url': 'mailto:ferasmuin@gmail.com',
      },
      {
        'title': content['linkedin']!,
        'icon': Icons.work,
        'url': 'https://www.linkedin.com/in/feras-qaq-a603a6302/',
      },
      {
        'title': content['github']!,
        'icon': Icons.code,
        'url': 'https://github.com/ferasqaq-dev',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryColor, secondaryColor],
            ).createShader(bounds),
            child: Text(
              content['contact']!,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return _buildContactCard(
                    contacts[index]['title'] as String,
                    contacts[index]['icon'] as IconData,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animation;
  final bool isDark;

  ParticlePainter({required this.animation, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.purple[500]! : Colors.blue[400]!).withOpacity(
        0.2,
      );

    for (int i = 0; i < 30; i++) {
      final random = math.Random(i);
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();
      final radius = random.nextDouble() * 3 + 1;

      final animatedRadius =
          radius * (0.5 + 0.5 * math.sin(animation * 2 * math.pi + i));
      canvas.drawCircle(Offset(x, y), animatedRadius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
