//blog_pages.dart

import 'package:flutter/material.dart';
import 'home_page.dart'; // Import to use MobileDrawer and BlogNavBar

class BlogPages extends StatefulWidget {
  const BlogPages({super.key});

  @override
  State<BlogPages> createState() => _BlogPagesState();
}

class _BlogPagesState extends State<BlogPages> {
  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {
    // Check screen width for mobile view
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: const BlogNavBar(activeMenu: "Pages"),
      // Added drawer for hamburger menu
      drawer: isMobile ? const MobileDrawer(activeMenu: '',) : null, 
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabMenu(),
                  const SizedBox(height: 20),
                  if (selectedTab == "All") _buildBlogCard() else _buildEmptyState(),
                ],
              ),
            ),
          ),
         
          if (!isMobile) _buildFixedSidebar(),
        ],
      ),
    );
  }

  Widget _buildTabMenu() {
    return Row(
      children: ["All", "Star"].map((tab) {
        bool isSelected = selectedTab == tab;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () => setState(() => selectedTab = tab),
            child: Column(
              children: [
                Text(tab, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isSelected ? Colors.blue : Colors.grey)),
                if (isSelected) Container(height: 2, width: 20, color: Colors.blue)
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBlogCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome", style: TextStyle(color: Colors.grey)),
          const Text("Welcome to my CV.", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Divider(),
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: [
              _infoLabel(Icons.person, "Sopheak Eng", "Author ✍️"),
              _infoLabel(Icons.calendar_month, "January 24, 2026", "Writing Date 📅"),
              _infoLabel(Icons.hourglass_empty, "Less than 1 minute", "Reading Time"),
              _infoLabel(Icons.grid_view, "Welcome", "Category", color: Colors.purple.shade50),
              _infoLabel(Icons.sell, "Welcome", "Welcome 1", color: Colors.purple.shade50),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoLabel(IconData icon, String text, String tooltip, {Color? color}) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color ?? Colors.transparent, borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: Colors.grey),
            SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Icon(Icons.inbox, size: 100, color: Colors.grey),
          Text("", style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFixedSidebar() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.account_circle, size: 100, color: Colors.blue),
                  SizedBox(height: 10),
                  Text("", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem("1", "Articles"),
                      _StatItem("1", "Category"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem(this.count, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(count, style: const TextStyle(fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey))]);
  }
}