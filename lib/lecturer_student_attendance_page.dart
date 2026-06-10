import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentAttendanceContent extends StatefulWidget {
  const StudentAttendanceContent({super.key});

  @override
  State<StudentAttendanceContent> createState() =>
      _StudentAttendanceContentState();
}

class _StudentAttendanceContentState extends State<StudentAttendanceContent> {
  static const Color _primaryBlue = Color(0xFF0422A7);
  static const Color _accentBlue = Color(0xFF006BFF);
  static const Color _softBlueGrey = Color(0xFFB8C7DE);
  static const Color _background = Color(0xFFF5F8FE);
  static const Color _textDark = Color(0xFF071A52);
  static const Color _textMuted = Color(0xFF718096);
  static const int _pageSize = 6;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromController =
      TextEditingController(text: '70');
  final TextEditingController _toController =
      TextEditingController(text: '100');

  String _selectedMonth = 'May 2025';
  String _searchQuery = '';
  String? _filterErrorText;
  double? _fromPercent = 70;
  double? _toPercent = 100;
  int _currentPage = 0;

  static const List<_MonthlyAttendance> _monthlyData = [
    _MonthlyAttendance(
      month: 'May 2025',
      averagePercent: 76.8,
      presentPercent: 76.8,
      absentPercent: 23.2,
      presentCount: 26,
      absentCount: 8,
      totalStudents: 34,
    ),
    _MonthlyAttendance(
      month: 'April 2025',
      averagePercent: 82.4,
      presentPercent: 82.4,
      absentPercent: 17.6,
      presentCount: 28,
      absentCount: 6,
      totalStudents: 34,
    ),
    _MonthlyAttendance(
      month: 'March 2025',
      averagePercent: 88.2,
      presentPercent: 88.2,
      absentPercent: 11.8,
      presentCount: 30,
      absentCount: 4,
      totalStudents: 34,
    ),
  ];

  static const List<_StudentAttendanceRecord> _students = [
    _StudentAttendanceRecord(
      name: 'Rahmi',
      matricNo: 'A21EC001',
      attendancePercent: 100,
    ),
    _StudentAttendanceRecord(
      name: 'Faradila',
      matricNo: 'A21EC004',
      attendancePercent: 94,
    ),
    _StudentAttendanceRecord(
      name: 'Nayef',
      matricNo: 'A21EC003',
      attendancePercent: 89,
    ),
    _StudentAttendanceRecord(
      name: 'Zana',
      matricNo: 'A21EC002',
      attendancePercent: 81,
    ),
    _StudentAttendanceRecord(
      name: 'Azma',
      matricNo: 'A21EC006',
      attendancePercent: 76,
    ),
    _StudentAttendanceRecord(
      name: 'Ziadh',
      matricNo: 'A21EC005',
      attendancePercent: 72,
    ),
  ];

  _MonthlyAttendance get _currentMonthData {
    return _monthlyData.firstWhere((data) => data.month == _selectedMonth);
  }

  List<_StudentAttendanceRecord> get _filteredStudents {
    final query = _searchQuery.trim().toLowerCase();

    return _students.where((student) {
      final matchesSearch = query.isEmpty ||
          student.name.toLowerCase().contains(query) ||
          student.matricNo.toLowerCase().contains(query);
      final matchesFrom = _fromPercent == null ||
          student.attendancePercent >= _fromPercent!.clamp(0, 100);
      final matchesTo = _toPercent == null ||
          student.attendancePercent <= _toPercent!.clamp(0, 100);

      return matchesSearch && matchesFrom && matchesTo;
    }).toList();
  }

  List<_StudentAttendanceRecord> get _visibleStudents {
    final filtered = _filteredStudents;
    final start = (_currentPage * _pageSize).clamp(0, filtered.length);
    final end = (start + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  int get _totalPages {
    final filteredCount = _filteredStudents.length;
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final fromText = _fromController.text.trim();
    final toText = _toController.text.trim();
    final fromValue = double.tryParse(fromText);
    final toValue = double.tryParse(toText);

    String? errorText;
    if (fromText.isEmpty || toText.isEmpty) {
      errorText = 'Min and Max attendance are required.';
    } else if (fromValue == null || toValue == null) {
      errorText = 'Attendance filter must be numeric.';
    } else if (fromValue < 0 || fromValue > 100) {
      errorText = 'Min attendance must be between 0 and 100.';
    } else if (toValue < 0 || toValue > 100) {
      errorText = 'Max attendance must be between 0 and 100.';
    } else if (fromValue >= toValue) {
      errorText = 'Min attendance must be smaller than Max attendance.';
    }

    if (errorText != null) {
      setState(() => _filterErrorText = errorText);
      return;
    }

    setState(() {
      _searchQuery = _searchController.text;
      _fromPercent = fromValue;
      _toPercent = toValue;
      _filterErrorText = null;
      _currentPage = 0;
    });
  }

  void _goToPreviousPage() {
    if (_currentPage == 0) return;
    setState(() => _currentPage--);
  }

  void _goToNextPage() {
    if (_currentPage >= _totalPages - 1) return;
    setState(() => _currentPage++);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildOverviewCard(),
          const SizedBox(height: 18),
          _buildSummaryCards(),
          const SizedBox(height: 18),
          _buildRecordsCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Attendance',
          style: GoogleFonts.poppins(
            color: _textDark,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track and analyze attendance for this class.',
          style: GoogleFonts.poppins(
            color: _textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    final data = _currentMonthData;

    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Monthly Attendance Overview',
                  style: GoogleFonts.poppins(
                    color: _textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _MonthDropdown(
                selectedMonth: _selectedMonth,
                months: _monthlyData.map((data) => data.month).toList(),
                onChanged: (month) {
                  if (month == null) return;
                  setState(() => _selectedMonth = month);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 680;

              final chart = _AttendanceDoughnutChart(
                averagePercent: data.averagePercent,
                presentPercent: data.presentPercent,
                absentPercent: data.absentPercent,
              );
              final legend = _AttendanceLegend(data: data);

              if (isCompact) {
                return Column(
                  children: [
                    chart,
                    const SizedBox(height: 22),
                    legend,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 3, child: chart),
                  const SizedBox(width: 28),
                  Expanded(flex: 2, child: legend),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final data = _currentMonthData;
    final cards = [
      _SummaryItem(
        title: 'Average Attendance',
        value: '${data.averagePercent.toStringAsFixed(1)}%',
        icon: Icons.analytics_outlined,
        tint: _primaryBlue,
      ),
      _SummaryItem(
        title: 'Present',
        value: data.presentCount.toString(),
        icon: Icons.check_circle_outline,
        tint: _accentBlue,
      ),
      _SummaryItem(
        title: 'Absent',
        value: data.absentCount.toString(),
        icon: Icons.cancel_outlined,
        tint: _softBlueGrey,
      ),
      _SummaryItem(
        title: 'Total Students',
        value: data.totalStudents.toString(),
        icon: Icons.groups_outlined,
        tint: const Color(0xFF4D5E80),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 520 ? 2 : 4;
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: _SummaryCard(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRecordsCard() {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Attendance Records',
            style: GoogleFonts.poppins(
              color: _textDark,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 18),
          _FilterRow(
            searchController: _searchController,
            fromController: _fromController,
            toController: _toController,
            errorText: _filterErrorText,
            onApply: _applyFilter,
          ),
          const SizedBox(height: 18),
          _AttendanceTable(
            students: _visibleStudents,
            absoluteStartIndex: _currentPage * _pageSize,
          ),
          const SizedBox(height: 18),
          _PaginationFooter(
            currentPage: _currentPage,
            totalPages: _totalPages,
            filteredCount: _filteredStudents.length,
            visibleCount: _visibleStudents.length,
            pageSize: _pageSize,
            onPrevious: _goToPreviousPage,
            onNext: _goToNextPage,
          ),
        ],
      ),
    );
  }
}

class _MonthlyAttendance {
  final String month;
  final double averagePercent;
  final double presentPercent;
  final double absentPercent;
  final int presentCount;
  final int absentCount;
  final int totalStudents;

  const _MonthlyAttendance({
    required this.month,
    required this.averagePercent,
    required this.presentPercent,
    required this.absentPercent,
    required this.presentCount,
    required this.absentCount,
    required this.totalStudents,
  });
}

class _StudentAttendanceRecord {
  final String name;
  final String matricNo;
  final int attendancePercent;

  const _StudentAttendanceRecord({
    required this.name,
    required this.matricNo,
    required this.attendancePercent,
  });
}

class _SummaryItem {
  final String title;
  final String value;
  final IconData icon;
  final Color tint;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.tint,
  });
}

class _SoftCard extends StatelessWidget {
  final Widget child;

  const _SoftCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EEF8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MonthDropdown extends StatelessWidget {
  final String selectedMonth;
  final List<String> months;
  final ValueChanged<String?> onChanged;

  const _MonthDropdown({
    required this.selectedMonth,
    required this.months,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _StudentAttendanceContentState._background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE6F6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _StudentAttendanceContentState._primaryBlue,
          ),
          items: months
              .map(
                (month) => DropdownMenuItem<String>(
                  value: month,
                  child: Text(
                    month,
                    style: GoogleFonts.poppins(
                      color: _StudentAttendanceContentState._textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _AttendanceDoughnutChart extends StatelessWidget {
  final double averagePercent;
  final double presentPercent;
  final double absentPercent;

  const _AttendanceDoughnutChart({
    required this.averagePercent,
    required this.presentPercent,
    required this.absentPercent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Center(
        child: SizedBox(
          width: 230,
          height: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(230),
                painter: _DoughnutPainter(
                  presentPercent: presentPercent,
                  absentPercent: absentPercent,
                  presentColor: _StudentAttendanceContentState._primaryBlue,
                  absentColor: _StudentAttendanceContentState._softBlueGrey,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${averagePercent.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      color: _StudentAttendanceContentState._textDark,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Average Attendance',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: _StudentAttendanceContentState._textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoughnutPainter extends CustomPainter {
  final double presentPercent;
  final double absentPercent;
  final Color presentColor;
  final Color absentColor;

  const _DoughnutPainter({
    required this.presentPercent,
    required this.absentPercent,
    required this.presentColor,
    required this.absentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.24;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - (strokeWidth / 2),
    );

    final backgroundPaint = Paint()
      ..color = const Color(0xFFEAF0FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final presentPaint = Paint()
      ..color = presentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final absentPaint = Paint()
      ..color = absentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    final total = math.max(1, presentPercent + absentPercent);
    const gap = 0.06;
    final presentSweep = (presentPercent / total) * math.pi * 2;
    final absentSweep = (absentPercent / total) * math.pi * 2;
    const startAngle = -math.pi / 2;

    canvas.drawArc(
      rect,
      startAngle,
      math.max(0, presentSweep - gap),
      false,
      presentPaint,
    );
    canvas.drawArc(
      rect,
      startAngle + presentSweep,
      math.max(0, absentSweep - gap),
      false,
      absentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DoughnutPainter oldDelegate) {
    return oldDelegate.presentPercent != presentPercent ||
        oldDelegate.absentPercent != absentPercent ||
        oldDelegate.presentColor != presentColor ||
        oldDelegate.absentColor != absentColor;
  }
}

class _AttendanceLegend extends StatelessWidget {
  final _MonthlyAttendance data;

  const _AttendanceLegend({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EEF8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(
            color: _StudentAttendanceContentState._primaryBlue,
            label: 'Present',
            value:
                '${data.presentPercent.toStringAsFixed(1)}% (${data.presentCount})',
          ),
          const SizedBox(height: 14),
          _LegendRow(
            color: _StudentAttendanceContentState._softBlueGrey,
            label: 'Absent',
            value:
                '${data.absentPercent.toStringAsFixed(1)}% (${data.absentCount})',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE0E8F5), height: 1),
          ),
          Row(
            children: [
              const Icon(
                Icons.groups_outlined,
                color: _StudentAttendanceContentState._primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Total Students',
                  style: GoogleFonts.poppins(
                    color: _StudentAttendanceContentState._textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                data.totalStudents.toString(),
                style: GoogleFonts.poppins(
                  color: _StudentAttendanceContentState._textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: _StudentAttendanceContentState._textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textDark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final _SummaryItem item;

  const _SummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 118),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EEF8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.tint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.tint, size: 21),
          ),
          const SizedBox(height: 14),
          Text(
            item.value,
            style: GoogleFonts.poppins(
              color: _StudentAttendanceContentState._textDark,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: _StudentAttendanceContentState._textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final TextEditingController searchController;
  final TextEditingController fromController;
  final TextEditingController toController;
  final String? errorText;
  final VoidCallback onApply;

  const _FilterRow({
    required this.searchController,
    required this.fromController,
    required this.toController,
    required this.errorText,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 760;
        final search = _SearchField(controller: searchController);
        final range = Row(
          children: [
            Expanded(
              child: _PercentField(
                label: 'Min',
                controller: fromController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PercentField(
                label: 'Max',
                controller: toController,
              ),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4EBF8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _StudentAttendanceContentState._primaryBlue
                          .withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: _StudentAttendanceContentState._primaryBlue,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Filter Students',
                      style: GoogleFonts.poppins(
                        color: _StudentAttendanceContentState._textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (!isCompact) _ApplyButton(onPressed: onApply),
                ],
              ),
              const SizedBox(height: 12),
              if (isCompact) ...[
                search,
                const SizedBox(height: 10),
                range,
                const SizedBox(height: 10),
                _ApplyButton(onPressed: onApply),
              ] else
                Row(
                  children: [
                    Expanded(flex: 3, child: search),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: range),
                  ],
                ),
              if (errorText != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFE53935),
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE53935),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _InputFrame(
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search student',
          hintStyle: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textMuted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: _StudentAttendanceContentState._textMuted,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

class _PercentField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _PercentField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _InputFrame(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          hintText: '0',
          hintStyle: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textMuted,
            fontSize: 13,
          ),
          suffixText: '%',
          suffixStyle: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textMuted,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

class _InputFrame extends StatelessWidget {
  final Widget child;

  const _InputFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE6F6)),
      ),
      child: child,
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ApplyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.tune, size: 18),
        label: Text(
          'Apply Filter',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _StudentAttendanceContentState._primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _AttendanceTable extends StatelessWidget {
  final List<_StudentAttendanceRecord> students;
  final int absoluteStartIndex;

  const _AttendanceTable({
    required this.students,
    required this.absoluteStartIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 34),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EEF8)),
        ),
        child: Column(
          children: [
            Icon(Icons.search_off, color: Colors.grey.shade400, size: 34),
            const SizedBox(height: 10),
            Text(
              'No students found',
              style: GoogleFonts.poppins(
                color: _StudentAttendanceContentState._textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) {
          return Column(
            children: students.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AttendanceStudentCard(
                  index: absoluteStartIndex + entry.key + 1,
                  student: entry.value,
                ),
              );
            }).toList(),
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EEF8)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(620, constraints.maxWidth),
                child: Column(
                  children: [
                    const _TableHeader(),
                    ...students.asMap().entries.map(
                          (entry) => _AttendanceTableRow(
                            index: absoluteStartIndex + entry.key + 1,
                            student: entry.value,
                            isEven: entry.key.isEven,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AttendanceStudentCard extends StatelessWidget {
  final int index;
  final _StudentAttendanceRecord student;

  const _AttendanceStudentCard({
    required this.index,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EEF8)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              index.toString(),
              style: GoogleFonts.poppins(
                color: _StudentAttendanceContentState._primaryBlue,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: _StudentAttendanceContentState._textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  student.matricNo,
                  style: GoogleFonts.poppins(
                    color: _StudentAttendanceContentState._textMuted,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _AttendancePercentBadge(percent: student.attendancePercent),
        ],
      ),
    );
  }
}

class _AttendancePercentBadge extends StatelessWidget {
  final int percent;

  const _AttendancePercentBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color:
            _StudentAttendanceContentState._primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$percent%',
        style: GoogleFonts.poppins(
          color: _StudentAttendanceContentState._primaryBlue,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F5FF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: const Row(
        children: [
          _HeaderCell('#', width: 56),
          _HeaderCell('Student Name', flex: 3),
          _HeaderCell('Matric No.', flex: 2),
          _HeaderCell('Attendance %', flex: 2, alignRight: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final double? width;
  final bool alignRight;

  const _HeaderCell(
    this.text, {
    this.flex = 1,
    this.width,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: GoogleFonts.poppins(
        color: _StudentAttendanceContentState._textDark,
        fontWeight: FontWeight.w700,
        fontSize: 12.5,
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: label);
    }
    return Expanded(flex: flex, child: label);
  }
}

class _AttendanceTableRow extends StatelessWidget {
  final int index;
  final _StudentAttendanceRecord student;
  final bool isEven;

  const _AttendanceTableRow({
    required this.index,
    required this.student,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? Colors.white : const Color(0xFFF9FBFF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              index.toString(),
              style: _rowStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              student.name,
              style: _rowStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              student.matricNo,
              style:
                  _rowStyle(color: _StudentAttendanceContentState._textMuted),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  _AttendancePercentBadge(percent: student.attendancePercent),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _rowStyle({
    Color color = _StudentAttendanceContentState._textDark,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      color: color,
      fontWeight: fontWeight,
      fontSize: 13,
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int filteredCount;
  final int visibleCount;
  final int pageSize;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PaginationFooter({
    required this.currentPage,
    required this.totalPages,
    required this.filteredCount,
    required this.visibleCount,
    required this.pageSize,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final start = filteredCount == 0 ? 0 : (currentPage * pageSize) + 1;
    final end = filteredCount == 0 ? 0 : start + visibleCount - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final text = Text(
          'Showing $start to $end of $filteredCount students',
          style: GoogleFonts.poppins(
            color: _StudentAttendanceContentState._textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        );
        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PageButton(
              icon: Icons.chevron_left,
              enabled: currentPage > 0,
              onTap: onPrevious,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${currentPage + 1} / $totalPages',
                style: GoogleFonts.poppins(
                  color: _StudentAttendanceContentState._textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
            _PageButton(
              icon: Icons.chevron_right,
              enabled: currentPage < totalPages - 1,
              onTap: onNext,
            ),
          ],
        );

        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text,
              const SizedBox(height: 12),
              controls,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: text),
            controls,
          ],
        );
      },
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled
              ? _StudentAttendanceContentState._primaryBlue
              : const Color(0xFFE9EEF8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : const Color(0xFF9AA8BE),
          size: 22,
        ),
      ),
    );
  }
}
