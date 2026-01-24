//home_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'blog_pages.dart';
import 'classes_page.dart';
import 'about_me_page.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    return Scaffold(
      appBar: const BlogNavBar(activeMenu: "Home"),
      drawer: isMobile ? const MobileDrawer(activeMenu: "Home") : null,
      body: Stack(
        children: [
          Container(color: const Color(0xFFE3F2FD)),
          Positioned(
            left: isMobile ? -screenWidth * 0.1 : -screenWidth * 0.2,
            top: -100,
            child: Container(
              width: screenWidth * (isMobile ? 1.2 : 0.8),
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          isMobile ? _buildMobileLayout(isDark) : _buildDesktopLayout(isDark),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      children: [
        Expanded(child: _profileImage()),
        Expanded(child: _profileText(isDark, CrossAxisAlignment.start)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60),
          _profileImage(height: 400),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _profileText(isDark, CrossAxisAlignment.center),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _profileImage({double height = 2450}) {
    return Center(
      child: Image.network(
        'assets/myicon.png',
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.face, size: 200),
      ),
    );
  }

  Widget _profileText(bool isDark, CrossAxisAlignment alignment) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment,
      children: [
        const Text("👋 Hello There, I'm", style: TextStyle(fontSize: 26, color: Color.fromARGB(255, 0, 94, 255))),
        Text("Sopheak Eng",
          textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600 ? 48 : 72,
            fontWeight: FontWeight.bold,
            letterSpacing: -2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const TypewriterText(
          text: "GTR Engineering.",
          style: TextStyle(fontSize: 32, color: Color.fromARGB(255, 0, 140, 255), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}


//////////////////////////////////////////  MENU 
class MobileDrawer extends StatelessWidget {
  final String activeMenu;
  const MobileDrawer({super.key, required this.activeMenu});
  
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Drawer(
    
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, 
    ),
    backgroundColor: isDark ? Colors.grey : Colors.white,
    child: Column(
      children: [
        
        Container(
          color: isDark ? const Color(0xFF303030) : const Color.fromARGB(255, 255, 252, 252), 
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    
                    ),
                    SizedBox(width: 10),
                    //Icon(Icons.hub_outlined, color: Colors.blueAccent, size: 28),
                    Spacer(),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.github, size: 20),
                      onPressed: () => launchUrl(Uri.parse('https://github.com/Phae-k/Eng-Sopheak.git')),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search), 
                        onPressed: (){}
                        ),
            ] ,
              ),
            ),
        ),
        ),
        //Divider(height: 1),
       
            
            SizedBox(height: 50),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [ 

                  _buildDrawerItem(
                    context,
                    icon: Icons.home,
                    title: "Home",
                    isActive: activeMenu == "Home",
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  HomePage())),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.article_outlined,
                    title: "Pages",
                    isActive: activeMenu == "Pages",
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  BlogPages())),
                  ),
                  _buildExpandableItem(
                    context,
                    icon: Icons.menu_book_outlined,
                    title: "Classes",
                    isActive: activeMenu == "Classes",
                    children: [
                      _buildDrawerItem(
                        context,
                        icon: Icons.book_outlined,
                        title: "Python",
                        isActive: activeMenu == "Classes",
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ClassesPage())),
                      ),
                    ],
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_pin_outlined,
                    title: "About Me",
                    isActive: activeMenu == "About Me",
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AboutMePage())),
                  ),
                ],
              ),
            ),
            const Text("Theme Mode"),
            IconButton(
              icon: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined, size: 20),
              onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool isActive = false}) {
    Color color = isActive ? const Color(0xFF0056B3) : Colors.black54;
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: TextStyle(color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 18)),
          onTap: onTap,
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 1, thickness: 0.5)),
      ],
    );
  }

  Widget _buildExpandableItem(BuildContext context, {required IconData icon, required String title, required List<Widget> children, bool isActive = false}) {
    Color color = isActive ? const Color(0xFF0056B3) : Colors.black54;
    return Column(
      children: [
        ExpansionTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          children: children,
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 1, thickness: 0.5)),
      ],
    );
  }
}
/////////////////////////////////////////////////////

class BlogNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String activeMenu;
  const BlogNavBar({super.key, required this.activeMenu});
  @override
  State<BlogNavBar> createState() => _BlogNavBarState();
  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _BlogNavBarState extends State<BlogNavBar> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _showClassesMenu = false;
  bool _isSearchingMobile = false; 

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    return AppBar(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      automaticallyImplyLeading: isMobile,
      title: Row(
        children: [
          if (!isMobile) ...[

            Icon(Icons.hub_outlined, color: Color.fromARGB(255, 1, 110, 200), size: 28),
            SizedBox(width: 10),
            Text("My CV", 
            style: TextStyle(color: isDark ? Colors.white : const Color.fromARGB(221, 78, 77, 77), 
            fontWeight: FontWeight.bold)),
            Spacer(),
            _navBtn(context, "Home", Icons.home, const HomePage()),
            _navBtn(context, "Pages", Icons.article_outlined, const BlogPages()),
            _classesBtn(context, isDark),
            _navBtn(context, "About Me", Icons.person_pin_outlined, const AboutMePage()),
            const SizedBox(width: 150),
          ],
          
          if (isMobile) 
         
          Spacer(),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.github, size: 20, color: isDark ? Colors.white70 : Colors.black54), 
            onPressed: () => launchUrl(Uri.parse('https://github.com/Phae-k/Eng-Sopheak.git'))
          ),
  
          if (!isMobile)
            IconButton(
              icon: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined, size: 20),
              onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
            ),
          
          if (isMobile)
            _isSearchingMobile 
              ? _searchBox(isDark, isMobile: true)
              : IconButton(
                  icon: const Icon(Icons.search), 
                  onPressed: () => setState(() => _isSearchingMobile = true)
                ),
                
          if (!isMobile) _searchBox(isDark),
        ],
      ),
    );
  }

  Widget _searchBox(bool isDark, {bool isMobile = false}) {
    return Container(
      width: isMobile ? 120 : 180, 
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100], 
        borderRadius: BorderRadius.circular(20),
        border: isMobile ? Border.all(color: Colors.blue, width: 1.5) : null,
      ),
      child: TextField(
        controller: _searchController,
        autofocus: isMobile, 
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, size: 18), 
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 12),
        ),
        onSubmitted: (_) => setState(() => _isSearchingMobile = false),
      ),
    );
  }

  Widget _navBtn(BuildContext context, String title, IconData icon, Widget target) {
    bool isSel = widget.activeMenu == title;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(border: isSel ? const Border(bottom: BorderSide(color: Colors.blue, width: 2)) : null),
      child: TextButton.icon(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target)),
        icon: Icon(icon, size: 18, color: isSel ? Colors.blue : (isDark ? Colors.white70 : Colors.black54)),
        label: Text(title, style: TextStyle(color: isSel ? Colors.blue : (isDark ? Colors.white70 : Colors.black54))),
      ),
    );
  }

  Widget _classesBtn(BuildContext context, bool isDark) {
    bool isSel = widget.activeMenu == "Classes";
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextButton(
          onPressed: () => setState(() => _showClassesMenu = !_showClassesMenu),
          child: Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 18, color: isSel ? Colors.blue : (isDark ? Colors.white70 : Colors.black54)),
              const SizedBox(width: 5),
              Text("Classes", style: TextStyle(color: isSel ? Colors.blue : (isDark ? Colors.white70 : Colors.black54))),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
        ),
        if (_showClassesMenu)
          Positioned(
            top: 50,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: InkWell(
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ClassesPage())),
                child: const Text("Python"),
              ),
            ),
          ),
      ],
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const TypewriterText({super.key, required this.text, required this.style});
  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayText = "";
  int _currentIndex = 0;
  bool _showCursor = true;
  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) setState(() { _showCursor = !_showCursor; });
    });
  }

  void _startTyping() {
    _typeTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_currentIndex < widget.text.length) {
        if (mounted) {
          setState(() {
            _displayText += widget.text[_currentIndex];
            _currentIndex++;
          });
        }
      } else {
        _typeTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayText, style: widget.style),
        Opacity(
          opacity: _showCursor ? 1.0 : 0.0,
          child: Text("|", style: widget.style),
        ),
      ],
    );
  }
}