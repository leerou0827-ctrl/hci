import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// 1. Import url_launcher to enable website navigation
import 'package:url_launcher/url_launcher.dart';
// --- 注入：引入 main.dart 以使用全局 Key ---
import 'main.dart'; 

// Color Constants
const Color kPrimaryBlue = Color(0xFF0422A7);
const Color kBackgroundColor = Color(0xFFF4F6FC);
const Color kTextBlack = Colors.black87;
const Color kTextGrey = Colors.grey;
const Color kBorderColor = Color(0xFFEEEEEE);

// =======================================================
//           CLASS 1: PROFILE PAGE (Main Tab)
// =======================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // 2. Helper function to open the website
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      // mode: LaunchMode.externalApplication opens it in Chrome/Safari instead of inside the app
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      // --- Body Content ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // 1. Profile Header (Photo & Name)
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/me.jpg'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "LEE ROU",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlue,
                    ),
                  ),
                  Text(
                    "Matric No: AI248888",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. Student Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Student Details"),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _buildCardDecoration(),
                    child: Column(
                      children: [
                        // --- 3. Faculty Row with Click Action ---
                        _buildInfoRow(
                          Icons.domain,
                          "Faculty",
                          "FSKTM",
                          onTap: () => _launchURL(
                              "https://fsktm.uthm.edu.my/"), // Opens the website
                        ),

                        const Divider(height: 30, color: kBorderColor),
                        _buildInfoRow(Icons.school, "Course",
                            "Bachelor of Computer Science (Multimedia Computing)"),
                        const Divider(height: 30, color: kBorderColor),
                        _buildInfoRow(Icons.email_outlined, "Email",
                            "ai248888@student.uthm.edu.my"),
                        const Divider(height: 30, color: kBorderColor),
                        _buildInfoRow(
                            Icons.phone_iphone, "Phone", "+60 12-345 6789"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Contact Us (Expandable List)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: _buildCardDecoration(),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: const Icon(Icons.support_agent,
                        color: kPrimaryBlue, size: 28),
                    title: Text(
                      "Contact Us",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    children: [
                      const Divider(height: 1, color: kBorderColor),
                      const SizedBox(height: 20),
                      _buildContactCard(
                        deptName: "Universiti Tun Hussein Onn Malaysia (UTHM)",
                        address: "86400 Parit Raja Batu Pahat Johor\nMalaysia",
                        phone: "+607-453 7000",
                        fax: "+607-453 6337",
                        email: "pro@uthm.edu.my",
                        web: "http://www.uthm.edu.my",
                      ),
                      const SizedBox(height: 16),
                      _buildSectionSubLabel("Postgraduate (Master & PhD)"),
                      _buildContactCard(
                        deptName: "Centre for Graduate Studies",
                        address: "86400 Parit Raja Batu Pahat Johor",
                        phone: "+607-453 7757 / 7509",
                        fax: "+607-453 6111",
                        email: "ps@uthm.edu.my",
                        web: "http://cgs.uthm.edu.my",
                      ),
                      const SizedBox(height: 16),
                      _buildSectionSubLabel("Undergraduate (Diploma & Degree)"),
                      _buildContactCard(
                        deptName: "Academic Management Office",
                        address: "86400 Parit Raja Batu Pahat Johor",
                        phone: "+607-453 7696",
                        fax: "+607-453 6085",
                        email: "pa@uthm.edu.my",
                        web: "http://ppa.uthm.edu.my",
                      ),
                      const SizedBox(height: 16),
                      _buildSectionSubLabel("International Student"),
                      _buildContactCard(
                        deptName: "International Office",
                        address: "86400 Parit Raja Batu Pahat Johor",
                        phone: "+607-453 8514 / 8515",
                        fax: "+607-453 8516",
                        email: "io@uthm.edu.my",
                        web: "http://io.uthm.edu.my",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Action Buttons Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // --- A. Academic Calendar Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AcademicCalendarPage()),
                        );
                      },
                      icon:
                          const Icon(Icons.calendar_month, color: kPrimaryBlue),
                      label: Text(
                        "Academic Calendar",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: kPrimaryBlue,
                            fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimaryBlue,
                        side: const BorderSide(color: kPrimaryBlue, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- B. My Virtual ID Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VirtualIdPage()),
                        );
                      },
                      icon: const Icon(Icons.badge, color: Colors.white),
                      label: Text(
                        "My Virtual ID",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- C. Log Out Button ---
                  // --- C. Log Out Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // --- 这里注入确认弹窗逻辑 ---
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Do you want to quit this app?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // 选 No 关掉弹窗
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 选 Yes 先关弹窗
                                    // 然后再执行你原有的注销逻辑
                                    mainGlobalKey.currentState?.logout();
                                  },
                                  child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        "Log Out",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828), // Red
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods (以下内容全部保留) ---
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4))
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryBlue)),
    );
  }

  Widget _buildSectionSubLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w600, color: kPrimaryBlue),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {VoidCallback? onTap}) {
    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: kPrimaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: kPrimaryBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: onTap != null ? kPrimaryBlue : Colors.black87,
                    decoration: onTap != null ? TextDecoration.underline : null,
                    decorationColor: kPrimaryBlue,
                  )),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(Icons.open_in_new, size: 16, color: kPrimaryBlue),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: row,
      );
    }
    return row;
  }

  Widget _buildContactCard(
      {required String deptName,
      required String address,
      required String phone,
      required String fax,
      required String email,
      required String web}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(deptName,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 8),
        _buildContactRow(Icons.location_on, address),
        const SizedBox(height: 8),
        _buildContactRow(Icons.phone, phone),
        const SizedBox(height: 8),
        _buildContactRow(Icons.print, fax),
        const SizedBox(height: 8),
        _buildContactRow(Icons.email, email),
        const SizedBox(height: 8),
        _buildContactRow(Icons.language, web),
      ]),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF3F51B5)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.black87, height: 1.4)),
        ),
      ],
    );
  }
}

// =======================================================
//           VIRTUAL ID PAGE & ACADEMIC CALENDAR PAGE (保持原样)
// =======================================================
class VirtualIdPage extends StatelessWidget {
  const VirtualIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Virtual ID",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFF90CAF9),
                  Color(0xFF42A5F5)
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.network(
                            "https://seeklogo.com/images/K/kementerian-pengajian-tinggi-malaysia-logo-5095893796-seeklogo.com.png",
                            height: 40,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.account_balance,
                              size: 40,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/UTHM_Logo.png/1200px-UTHM_Logo.png",
                            height: 50,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.school,
                              size: 50,
                              color: kPrimaryBlue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(flex: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/me.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "MySISWA",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1A237E),
                                shadows: [
                                  const Shadow(
                                    color: Colors.white,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "AI240160",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "LEE ROU",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFD4AF37),
                              Color(0xFFF7EF8A),
                              Color(0xFFD4AF37)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.memory, color: Colors.black54),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(4),
                        color: Colors.white,
                        child: const Icon(
                          Icons.qr_code_2,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AcademicCalendarPage extends StatelessWidget {
  const AcademicCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Academic Calendar",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.asset(
            'assets/image.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image, color: Colors.white, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    "Image not found.\nPlease ensure 'assets/image.png' exists.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}