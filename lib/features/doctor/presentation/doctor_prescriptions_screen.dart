import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';
import 'doctor_prescription_summary_screen.dart';
import 'doctor_create_prescription_screen.dart';

class DoctorPrescriptionsScreen extends StatefulWidget {
  const DoctorPrescriptionsScreen({super.key});

  @override
  State<DoctorPrescriptionsScreen> createState() => _DoctorPrescriptionsScreenState();
}

class _DoctorPrescriptionsScreenState extends State<DoctorPrescriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<PrescriptionModel> _getFiltered(String status) {
    return DoctorDummyData.prescriptions.where((rx) {
      final matchStatus = status == 'all' || rx.status == status;
      final matchSearch = rx.patientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rx.items.any((i) => i.medicineName.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Prescriptions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by patient or medicine...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryTeal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryTeal,
                tabs: [
                  Tab(text: 'All (${_getFiltered("all").length})'),
                  Tab(text: 'Active (${_getFiltered("active").length})'),
                  Tab(text: 'Done (${_getFiltered("completed").length})'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PrescriptionList(prescriptions: _getFiltered('all')),
          _PrescriptionList(prescriptions: _getFiltered('active')),
          _PrescriptionList(prescriptions: _getFiltered('completed')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorCreatePrescriptionScreen()),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(LucideIcons.filePlus),
        label: const Text('New Rx'),
      ),
    );
  }
}

class _PrescriptionList extends StatelessWidget {
  final List<PrescriptionModel> prescriptions;
  const _PrescriptionList({required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.fileX, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No prescriptions found', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: prescriptions.length,
      itemBuilder: (ctx, i) => _buildRxCard(ctx, prescriptions[i]),
    );
  }

  Widget _buildRxCard(BuildContext context, PrescriptionModel rx) {
    final isActive = rx.status == 'active';
    final statusColor = isActive ? Colors.green : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DoctorPrescriptionSummaryScreen(prescription: rx)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryTeal.withOpacity(0.12),
                    child: Text(
                      rx.patientName.isNotEmpty ? rx.patientName[0] : 'P',
                      style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rx.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(_formatDate(rx.date), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isActive ? 'Active' : 'Completed',
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: rx.items.map((item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${item.medicineName} ${item.dosage}',
                    style: const TextStyle(color: AppColors.primaryTeal, fontSize: 11),
                  ),
                )).toList(),
              ),
              if (rx.notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(LucideIcons.stickyNote, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        rx.notes,
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionChip(context, LucideIcons.eye, 'View', () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DoctorPrescriptionSummaryScreen(prescription: rx)),
                  )),
                  const SizedBox(width: 8),
                  _actionChip(context, LucideIcons.share2, 'Share', () =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sharing prescription...')))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primaryTeal),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}
