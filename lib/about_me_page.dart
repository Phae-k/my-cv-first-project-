import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey infoKey = GlobalKey();
  final GlobalKey eduKey = GlobalKey();
  final GlobalKey pubKey = GlobalKey();
  final GlobalKey disKey = GlobalKey();
  final GlobalKey skillKey = GlobalKey();
  final GlobalKey expKey = GlobalKey();
  final GlobalKey certKey = GlobalKey();

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _onScroll() {
    List<GlobalKey> keys = [infoKey, eduKey, pubKey, disKey, skillKey, expKey, certKey];
    int newIndex = 0;

    for (int i = 0; i < keys.length; i++) {
      final context = keys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        if (position < 250) {
          newIndex = i;
        }
      }
    }

    if (newIndex != _activeIndex) {
      setState(() {
        _activeIndex = newIndex;
      });
    }
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    return Scaffold(
      appBar: const BlogNavBar(activeMenu: "About Me"),
      drawer: isMobile ? const MobileDrawer(activeMenu: 'About Me') : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBreadcrumbs(context),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildMetaData(context),
                  const Divider(height: 50),
                  if (isMobile) ...[
                    _buildMobileMenu(),
                    const SizedBox(height: 20),
                  ],
                  _buildIntroText(),
                  const SizedBox(height: 40),

                  // --- Section: My Information ---
                  _buildSection("My Information", infoKey, 
                    child: _buildInformationTable()
                  ),

                  _buildSection("My Education", eduKey, 
                    child: _buildEducation()),
                  
                

                  _buildSection("My Skill", skillKey, 
                    child: _buildSkill()
                    ),

                  _buildSection("My Experience", expKey, 
                    child: _buildExperience()
                    ),

                  _buildSection("My Reference", certKey, 
                    child: _buildCertificate()
                    ),

                  SizedBox(height: 600), 
                ],
              ),
            ),
          ),

          if (!isMobile)
            Container(
              width: 260,
              padding: const EdgeInsets.only(top: 150, right: 30),
              child: _buildOnThisPageList(isMobile: false),
            ),
        ],
      ),
    );
  }

  // --- Widget for Information Table (2-Column Version) ---
  Widget _buildInformationTable() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFFF9F9F9),
            child: Center(
              child: Image.network(
                'assets/pic.png', 
                height: 350,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.account_box, size: 200, color: Colors.grey),
              ),
            ),
          ),
          
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120), // Label Column
              1: FlexColumnWidth(),     // Data Column
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow("Name", "ENG SOPHEAK"),
              _buildTableRow("Address", "Sangat Prek Leap, Khan Chroy Chongva, Phnom Penh, Cambodia"),
              _buildTableRow("DoB", "02/December/200*"),
              _buildTableRow("Phone", "+855-97-321-0589"),
              _buildTableRow("Email", "e20221247@dtc1.itc.edu.kh"),
              _buildTableRow("LinkedIn", "https://www.linkedin.com/in/engsopheak ↗", isLink: true, url: ""),
             _buildTableRow("Telegram", "https://www.facebook.com/engsopheak ↗", isLink: true, url: "https://www.facebook.com/share/1DsGdQiSxL/?mibextid=wwXIfr"),
             _buildTableRow("Language", "Khmer\nEnglish\nFrench"),
            ],
          ),
        ],
      ),
    );
  }



    Widget _buildEducation() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120), // Label Column
              1: FlexColumnWidth(),     // Data Column
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow("University:", "Institute of Technology of Cambodia (ITC) ↗", isLink: true, url: "https://www.facebook.com/share/1HewFQ6HvA/?mibextid=wwXIfr"),
              _buildTableRow("Department:", "Department of Telecommunication and Network Engineering "),
              _buildTableRow("Major:", "Network Engineering"),
              _buildTableRow("Year:", "01/October/2024 to Present"),
            ],
          ),

          SizedBox(height: 30), 
          
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120), // Label Column
              1: FlexColumnWidth(),     // Data Column
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow("University:", "Institute of Technology of Cambodia (ITC) ↗", isLink: true, url: "https://www.facebook.com/share/1HewFQ6HvA/?mibextid=wwXIfr"),
              _buildTableRow("Department:", "Department of Foundation Year"),
              _buildTableRow("Year:", "16/Feb/2023 to 08/Aug/2024"),
            ],
          ),

          SizedBox(height: 30), 
          
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120), // Label Column
              1: FlexColumnWidth(),     // Data Column
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow("High School:", "Hun Sen Khchao High school. ↗", isLink: true, url: "https://www.facebook.com/share/1FYkZvNG1T/?mibextid=wwXIfr"),
              _buildTableRow("Year:", "01/Nov/2020 to 05/Dec/2022"),
            ],
          ),
        ],
      ),
    );
  }


Widget _buildSkill() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(60), // Width for the Icon column
          1: FlexColumnWidth(),    // Width for the Skill Text column
        },
        border: TableBorder.all(color: Colors.grey[300]!),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
        
          _buildSkillRow(Icons.computer, "Windows"),
          _buildSkillRow(Icons.computer, "Python, C, C++, OOP, MATLAB, Flutter and Type Script)."),
          _buildSkillRow(Icons.analytics, "Data Analysis, Mathematics"),
          _buildSkillRow(Icons.network_cell_outlined, "Word, Excel, PowePoint, Overleaf Latex"),
          //_buildSkillRow(Icons.hub, "Machine Learning (Supervised, Unsupervised, and Reinforcement Learning)."),
        ],
      ),
    );
  }

  // Helper to build a skill row with an Icon and Text
  TableRow _buildSkillRow(IconData icon, String skillText) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(icon, color: Colors.black87, size: 24),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: Text(
            skillText,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
Widget _buildExperience() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [

          _experienceBlock(
            companyName: "Internship ",
            companyUrl: "", 
            rows: [
              
              _buildTableRow("Title:", "Software defined radio ➔", isLink: true, url: "https://your-job-link.com"),
              _buildTableRow("Date:", "10/Aug/2025 to 10/Nov/2025"),
            ],
          ),
          SizedBox(height: 30), 
          
          _experienceBlock(
            companyName: "SceneBuilder Project Team",
            companyUrl: "", 
            rows: [
              _buildTableRow("Title:", "Hotel Reservation System By using JavaFx ➔", isLink: true, url: ""),
              _buildTableRow("Date:", "02/July/2025"),
            ],
          ),

          SizedBox(height: 30), 
          
          _experienceBlock(
            companyName: "Flutter Project Team",
            companyUrl: "", 
            rows: [
              _buildTableRow("Title:", "GTR Information Systems➔", isLink: true, url: ""),
              _buildTableRow("Date:", "23/Jan/2026"),
            ],
          ),

        
        ],
      ),
    );
  }

  Widget _experienceBlock({
    required String companyName, 
    required String companyUrl, 
    required List<TableRow> rows
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          InkWell(
            onTap: () => _launchURL(companyUrl),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    companyName,
                    style: const TextStyle(
                      color: Color(0xFF1976D2), // Professional blue
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.north_east, size: 14, color: Color(0xFF1976D2)),
                ],
              ),
            ),
          ),
          // Details Table
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120),
              1: FlexColumnWidth(),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey[300]!),
              verticalInside: BorderSide(color: Colors.grey[300]!),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: rows,
          ),
        ],
      ),
    );
  }

    Widget _buildCertificate() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120), // Label Column
              1: FlexColumnWidth(),     // Data Column
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableRow("Name", "Dr. SRENG Sokchenda"),
              _buildTableRow("Position", "Head of Department of Telecommunication and Network Engineering "),
              _buildTableRow("Phone", "+855-124-079-10  "),
              _buildTableRow("Email", " sokchenda@itc.edu.kh"),
           
            ],
          ),
        ],
      ),
    );
  }

  // --- Row Builder for 2 Columns ---
  TableRow _buildTableRow(String label, String val, {bool isLink = false, String? url}) {
    return TableRow(
      children: [
        // Column 1: Label
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            label, 
            style: const TextStyle(fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center
          ),
        ),
        // Column 2: Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: isLink && url != null ? () => _launchURL(url) : null,
            child: Text(
              val, 
              style: TextStyle(
                color: isLink ? Colors.blue : Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumbs(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.home, size: 16, color: Colors.blue),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage())),
              child:  Text("Home", style: TextStyle(color: Colors.blue)),
        ),
        Text(" / About / ", style: TextStyle(color: Colors.grey)),
        Icon(Icons.badge, size: 16, color: Colors.grey),
        Text(" My curriculum vitae (CV)", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.contact_page, color: Colors.blue, size: 36),
        SizedBox(width: 10),
        Expanded(
          child: Text("My curriculum vitae (CV)",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildMetaData(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        _metaItem(Icons.person, "Sopheak Eng", "Author ✍️"),
        _metaItem(Icons.calendar_month, "January 24, 2026", "Writing Date 📅"),
        _metaItem(Icons.hourglass_bottom, "Less than 1 minute", "Reading Time ⌛"),
      ],
    );
  }

  Widget _metaItem(IconData icon, String label, String message) {
    return Tooltip(
      message: message,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMobileMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        title: const Text("On This Page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
            child: _buildOnThisPageList(isMobile: true),
          )
        ],
      ),
    );
  }

  Widget _buildOnThisPageList({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile) ...[
          Row(
            children: [
              Text("On This Page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 5),
               IconButton(
                icon: Icon(Icons.print_outlined, size: 18, color: Colors.grey),
                onPressed:(){},
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey[300]!, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _menuLink("My Information", infoKey, 0),
              _menuLink("My Education", eduKey, 1),
              _menuLink("My Skill", skillKey, 4),
              _menuLink("My Experience", expKey, 5),
              _menuLink("My Reference", certKey, 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuLink(String title, GlobalKey key, int index) {
    bool isActive = _activeIndex == index;
    return InkWell(
      onTap: () => _scrollToSection(key),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent, 
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey[600],
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return const Text(
      "I am a motivated and adaptable Telecommunication and Networking student at the Institute of Technology of Cambodia. With basic experience in engineering and strong interest in software development and system design, I’m seeking new challenges to improve my technical skills and communication in fast-paced environments.",
      style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
    );
  }

  Widget _buildSection(String title, GlobalKey key, {String? content, Widget? child}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(thickness: 1),
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(content, style: const TextStyle(fontSize: 16, height: 1.6)),
            ),
          if (child != null) child,
        ],
      ),
    );
  }
}