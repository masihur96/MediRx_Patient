import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';
import 'doctor_create_prescription_screen.dart';
import 'doctor_prescription_summary_screen.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final PatientModel patient;
  const DoctorPatientDetailScreen({super.key, required this.patient});

  @override
  State<DoctorPatientDetailScreen> createState() => _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PrescriptionModel> get _patientPrescriptions =>
      DoctorDummyData.prescriptions.where((rx) => rx.patientId == widget.patient.id).toList();

  List<ClinicalNote> get _patientNotes =>
      DoctorDummyData.clinicalNotes.where((n) => n.patientId == widget.patient.id).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxScrolled) => [
          _buildSliverAppBar(ctx),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.primaryTeal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryTeal,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Medications'),
                  Tab(text: 'Prescriptions'),
                  Tab(text: 'Adherence'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(patient: widget.patient),
            _MedicationsTab(patient: widget.patient, prescriptions: _patientPrescriptions),
            _PrescriptionsTab(prescriptions: _patientPrescriptions),
            _AdherenceTab(patient: widget.patient),
            _NotesTab(patient: widget.patient, notes: _patientNotes),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorCreatePrescriptionScreen(preselectedPatient: widget.patient),
          ),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(LucideIcons.filePlus),
        label: const Text('New Prescription'),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final adherenceColor = widget.patient.adherencePercent >= 80
        ? Colors.green
        : widget.patient.adherencePercent >= 60
            ? Colors.orange
            : Colors.red;

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryTeal,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryTeal, Color(0xFF00796B)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  widget.patient.avatarInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.patient.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.patient.age}y • ${widget.patient.gender} • ${widget.patient.bloodGroup}',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(LucideIcons.trendingUp, size: 14, color: adherenceColor),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.patient.adherencePercent.toInt()}% adherence',
                          style: TextStyle(color: adherenceColor, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tab Bar Delegate ────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

// ─── Overview Tab ─────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final PatientModel patient;
  const _OverviewTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
            context,
            title: 'Patient Information',
            icon: LucideIcons.user,
            children: [
              _infoRow('Phone', patient.phone),
              _infoRow('Address', patient.address),
              _infoRow('Blood Group', patient.bloodGroup),
              _infoRow('Last Visit', _formatDate(patient.lastVisit)),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            context,
            title: 'Medical Conditions',
            icon: LucideIcons.activity,
            children: patient.conditions.map((c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(c, style: const TextStyle(fontSize: 14)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            context,
            title: 'Adherence Overview',
            icon: LucideIcons.trendingUp,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _adherenceBadge(patient.adherencePercent),
                        const SizedBox(height: 8),
                        const Text('Overall', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _adherenceRow('Taken', (patient.adherencePercent).toInt(), Colors.green),
                        const SizedBox(height: 8),
                        _adherenceRow('Missed', (100 - patient.adherencePercent).toInt(), AppColors.errorRed),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _adherenceBadge(double percent) {
    final color = percent >= 80 ? Colors.green : percent >= 60 ? Colors.orange : Colors.red;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: 8,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text(
          '${percent.toInt()}%',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _adherenceRow(String label, int percent, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label: $percent%', style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _sectionCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}

// ─── Medications Tab ─────────────────────────────────────────────────────────

class _MedicationsTab extends StatelessWidget {
  final PatientModel patient;
  final List<PrescriptionModel> prescriptions;
  const _MedicationsTab({required this.patient, required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    final activePrescriptions = prescriptions.where((rx) => rx.status == 'active').toList();
    final allItems = activePrescriptions.expand((rx) => rx.items).toList();

    if (allItems.isEmpty) {
      return const Center(child: Text('No active medications'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length,
      itemBuilder: (ctx, i) {
        final item = allItems[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.pill, color: AppColors.primaryTeal, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.medicineName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${item.dosage} • ${item.frequency}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('Duration: ${item.duration}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    if (item.instructions.isNotEmpty)
                      Text(item.instructions, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Prescriptions Tab ───────────────────────────────────────────────────────

class _PrescriptionsTab extends StatelessWidget {
  final List<PrescriptionModel> prescriptions;
  const _PrescriptionsTab({required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return const Center(child: Text('No prescriptions found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prescriptions.length,
      itemBuilder: (ctx, i) {
        final rx = prescriptions[i];
        final isActive = rx.status == 'active';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Completed',
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(rx.date),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${rx.items.length} medicines prescribed',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rx.items.map((i) => i.medicineName).join(', '),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (rx.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(LucideIcons.stickyNote, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DoctorPrescriptionSummaryScreen(prescription: rx)),
                        ),
                        icon: const Icon(LucideIcons.eye, size: 14),
                        label: const Text('View', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primaryTeal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}

// ─── Adherence Tab ───────────────────────────────────────────────────────────

class _AdherenceTab extends StatelessWidget {
  final PatientModel patient;
  const _AdherenceTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final adherenceData = DoctorDummyData.getAdherenceData(patient.id);
    final taken = adherenceData.where((d) => d.status == AdherenceStatus.taken).length;
    final missed = adherenceData.where((d) => d.status == AdherenceStatus.missed).length;
    final total = taken + missed;
    final percent = total > 0 ? (taken / total * 100).toInt() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _adherenceStatCard(context, '${patient.adherencePercent.toInt()}%', 'Overall Rate', AppColors.primaryTeal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _adherenceStatCard(context, '$taken', 'Doses Taken', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _adherenceStatCard(context, '$missed', 'Doses Missed', AppColors.errorRed),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Heatmap
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Adherence Heatmap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Row(
                      children: [
                        _legendDot(Colors.green),
                        const SizedBox(width: 4),
                        const Text('Taken', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(width: 8),
                        _legendDot(AppColors.errorRed),
                        const SizedBox(width: 4),
                        const Text('Missed', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(width: 8),
                        _legendDot(Colors.grey[300]!),
                        const SizedBox(width: 4),
                        const Text('No data', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Weekday headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) =>
                    Text(d, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                  ).toList(),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: adherenceData.length,
                  itemBuilder: (ctx, i) {
                    final day = adherenceData[i];
                    return GestureDetector(
                      onTap: () => _showDayDetail(context, day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: day.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${day.date.day}',
                            style: TextStyle(
                              fontSize: 9,
                              color: day.status == AdherenceStatus.noData ? Colors.grey[600] : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _adherenceStatCard(BuildContext context, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 8, height: 8,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }

  void _showDayDetail(BuildContext context, AdherenceDay day) {
    final statusText = day.status == AdherenceStatus.taken ? 'Taken' :
                       day.status == AdherenceStatus.missed ? 'Missed' : 'No data';
    final statusColor = day.color;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_monthName(day.date.month)} ${day.date.day}, ${day.date.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

// ─── Notes Tab ───────────────────────────────────────────────────────────────

class _NotesTab extends StatefulWidget {
  final PatientModel patient;
  final List<ClinicalNote> notes;
  const _NotesTab({required this.patient, required this.notes});

  @override
  State<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<_NotesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: () => _showAddNoteDialog(context),
        child: const Icon(LucideIcons.plus),
      ),
      body: widget.notes.isEmpty
          ? const Center(child: Text('No clinical notes yet'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: widget.notes.length,
              itemBuilder: (ctx, i) => _buildNoteCard(ctx, widget.notes[i]),
            ),
    );
  }

  Widget _buildNoteCard(BuildContext context, ClinicalNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              if (note.isPrivate)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.lock, size: 10, color: Colors.orange),
                      SizedBox(width: 3),
                      Text('Private', style: TextStyle(color: Colors.orange, fontSize: 10)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(note.date),
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
          const SizedBox(height: 10),
          Text(note.content, style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isPrivate = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Clinical Note', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Clinical Note',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: isPrivate,
                    activeColor: AppColors.primaryTeal,
                    onChanged: (v) => setModalState(() => isPrivate = v),
                  ),
                  const SizedBox(width: 8),
                  const Text('Private note'),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clinical note saved')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                  child: const Text('Save Note', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}
