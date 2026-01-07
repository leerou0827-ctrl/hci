import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. 引入你的各个页面文件
import 'home_page.dart';
import 'academic_page.dart';
import 'scan_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'login_page.dart'; // <--- 新增：引入登录页面

void main() {
  runApp(const DigitalClassroomApp());
}

// 定义全局 Key，方便在子页面（如 ProfilePage）通过 mainGlobalKey.currentState?.logout() 调用注销方法
final GlobalKey<MainEntryPageState> mainGlobalKey = GlobalKey<MainEntryPageState>();

const Color kPrimaryBlue = Color(0xFF0422A7);
const Color kBackgroundColor = Color(0xFFF4F6FC);

class DigitalClassroomApp extends StatelessWidget {
  const DigitalClassroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Classroom',
      theme: ThemeData(
        primaryColor: kPrimaryBlue,
        colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryBlue,
            primary: kPrimaryBlue,
            secondary: const Color(0xFF64B5F6),
            surface: Colors.white),
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      // 2. 修改：App 启动时先进入登录页面
      home: const LoginPage(), 
    );
  }
}

class MainEntryPage extends StatefulWidget {
  const MainEntryPage({super.key});

  @override
  State<MainEntryPage> createState() => MainEntryPageState();
}

class MainEntryPageState extends State<MainEntryPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const AcademicPage(),
    const ScanPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  // 3. 新增：注销方法
  // 这个方法会清空所有的页面路由栈，并跳转回登录页
  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // 这行代码负责清空所有历史路由，让用户无法通过“返回”回到主页
    );
  }

  // 切换 Tab 的公开方法
  void switchToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 如果选中扫码（Index 2），全屏显示 ScanPage
    if (_selectedIndex == 2) {
      return const ScanPage();
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      // 悬浮扫码按钮
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(2),
          backgroundColor: kPrimaryBlue,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.menu_book, 'Academic', 1),
            const SizedBox(width: 40), // 为悬浮按钮留出的空间
            _buildNavItem(Icons.notifications_none, 'Notification', 3),
            _buildNavItem(Icons.person_outline, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    Color color = isSelected ? kPrimaryBlue : Colors.grey;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal))
            ]),
      ),
    );
  }
}