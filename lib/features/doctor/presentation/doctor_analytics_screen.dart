import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';

class DoctorAnalyticsScreen extends StatelessWidget {
  const DoctorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = DoctorDummyData.analytics;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exporting as $v...')),
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'PDF', child: Row(children: [Icon(LucideIcons.fileDown, size: 16), SizedBox(width: 8), Text('Export PDF')])),
              const PopupMenuItem(value: 'CSV', child: Row(children: [Icon(LucideIcons.fileSpreadsheet, size: 16), SizedBox(width: 8), Text('Export CSV')])),
            ],
            icon: const Icon(LucideIcons.download),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(context, analytics),
            const SizedBox(height: 24),
            _buildPrescriptionChart(context, analytics),
            const SizedBox(height: 24),
            _buildTopMedicinesChart(context, analytics),
            const SizedBox(height: 24),
            _buildAdherenceDonut(context, analytics),
            const SizedBox(height: 24),
            _buildRecentRxList(context),
            const SizedBox(height: 24),
            _buildExportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, DoctorAnalytics analytics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _AnalyticsCard(
          label: 'Total Prescriptions',
          value: '${analytics.totalPrescriptions}',
          icon: LucideIcons.fileText,
          color: AppColors.primaryTeal,
          change: '+12%',
          isPositive: true,
        ),
        _AnalyticsCard(
          label: 'Active Patients',
          value: '${analytics.activePatients}',
          icon: LucideIcons.users,
          color: const Color(0xFF5C6BC0),
          change: '+5%',
          isPositive: true,
        ),
        _AnalyticsCard(
          label: 'This Month',
          value: '${analytics.thisMonthPrescriptions} Rx',
          icon: LucideIcons.calendar,
          color: const Color(0xFF26A69A),
          change: '+8%',
          isPositive: true,
        ),
        _AnalyticsCard(
          label: 'Avg Adherence',
          value: '${analytics.avgAdherence.toInt()}%',
          icon: LucideIcons.activity,
          color: const Color(0xFF66BB6A),
          change: '-2%',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildPrescriptionChart(BuildContext context, DoctorAnalytics analytics) {
    final maxVal = analytics.prescriptionsByMonth.values.reduce((a, b) => a > b ? a : b).toDouble();

    return _ChartCard(
      title: 'Prescriptions per Month',
      icon: LucideIcons.barChart3,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: analytics.prescriptionsByMonth.entries.map((entry) {
                final barHeight = (entry.value / maxVal) * 120;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.value}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF4DB6AC), AppColors.primaryTeal],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(entry.key, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMedicinesChart(BuildContext context, DoctorAnalytics analytics) {
    final maxCount = analytics.topMedicines.map((m) => m.prescriptionCount).reduce((a, b) => a > b ? a : b);

    return _ChartCard(
      title: 'Top Prescribed Medicines',
      icon: LucideIcons.pill,
      child: Column(
        children: analytics.topMedicines.map((med) {
          final barRatio = med.prescriptionCount / maxCount;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(med.medicineName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    Text(
                      '${med.prescriptionCount} Rx',
                      style: TextStyle(fontSize: 11, color: med.color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: barRatio,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: med.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdherenceDonut(BuildContext context, DoctorAnalytics analytics) {
    return _ChartCard(
      title: 'Patient Adherence Overview',
      icon: LucideIcons.pieChart,
      child: Row(
        children: [
          // Donut chart (custom painter)
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _DonutPainter(
                adherence: analytics.avgAdherence / 100,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${analytics.avgAdherence.toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const Text('Avg Rate', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _adherenceLegend('Adherent (>80%)', '${DoctorDummyData.patients.where((p) => p.adherencePercent >= 80).length} patients', Colors.green),
                const SizedBox(height: 12),
                _adherenceLegend('Moderate (60-79%)', '${DoctorDummyData.patients.where((p) => p.adherencePercent >= 60 && p.adherencePercent < 80).length} patients', Colors.orange),
                const SizedBox(height: 12),
                _adherenceLegend('Low (<60%)', '${DoctorDummyData.patients.where((p) => p.adherencePercent < 60).length} patients', AppColors.errorRed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adherenceLegend(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRxList(BuildContext context) {
    final recent = DoctorDummyData.prescriptions.take(3).toList();

    return _ChartCard(
      title: 'Recent Prescriptions',
      icon: LucideIcons.clock,
      child: Column(
        children: recent.map((rx) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    rx.patientName[0],
                    style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rx.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${rx.items.length} medicines • ${_formatDate(rx.date)}', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: rx.status == 'active' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rx.status == 'active' ? 'Active' : 'Done',
                  style: TextStyle(
                    color: rx.status == 'active' ? Colors.green : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildExportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryTeal, Color(0xFF00897B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Export Analytics Report',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Download a comprehensive report of your practice statistics',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF report exported successfully')),
                  ),
                  icon: const Icon(LucideIcons.fileDown, size: 16, color: Colors.white),
                  label: const Text('PDF Report', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV file exported successfully')),
                  ),
                  icon: const Icon(LucideIcons.fileSpreadsheet, size: 16, color: Colors.white),
                  label: const Text('CSV Export', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }
}

// ─── Analytics Card ──────────────────────────────────────────────────────────

class _AnalyticsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final bool isPositive;

  const _AnalyticsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : AppColors.errorRed).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                      size: 10,
                      color: isPositive ? Colors.green : AppColors.errorRed,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: isPositive ? Colors.green : AppColors.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// ─── Chart Card ───────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ChartCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─── Donut Chart Painter ─────────────────────────────────────────────────────

class _DonutPainter extends CustomPainter {
  final double adherence;
  _DonutPainter({required this.adherence});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    // Background arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey[200]!;
    canvas.drawCircle(center, radius, bgPaint);

    // Adherence arc
    final adherencePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryTeal;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * adherence,
      false,
      adherencePaint,
    );

    // Missed arc (orange)
    if (adherence < 0.8) {
      final missedPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = Colors.orange.withOpacity(0.4);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2 + 2 * 3.14159 * adherence,
        2 * 3.14159 * (0.8 - adherence),
        false,
        missedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
