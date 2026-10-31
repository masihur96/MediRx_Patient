import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import 'scan_prescription_screen.dart';
import 'e_prescription_screen.dart';
import 'add_prescription_screen.dart';
import 'viewmodels/medication_viewmodel.dart';

class MedicationScreen extends StatefulWidget {
  final bool isTab;
  const MedicationScreen({super.key, this.isTab = false});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();

  static void showAddPrescriptionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Prescription',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.scanLine,
                      color: AppColors.primaryTeal),
                ),
                title: const Text('Scan Prescription'),
                subtitle: const Text('Take a photo of your prescription'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanPrescriptionScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.fileDigit,
                      color: AppColors.surfaceDark),
                ),
                title: const Text('E-Prescription'),
                subtitle: const Text('Enter code from your doctor'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EPrescriptionScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.filePlus, color: Colors.green),
                ),
                title: const Text('Create Prescription'),
                subtitle: const Text('Enter medication details manually'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPrescriptionScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _MedicationScreenState extends State<MedicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationViewModel>().init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTab) {
      return Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryTeal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryTeal,
            tabs: const [
              Tab(text: 'Medications'),
              Tab(text: 'Prescriptions'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMedicationsTab(),
                _buildPrescriptionsTab(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication'),
        actions: [
          IconButton(
            onPressed: () => MedicationScreen.showAddPrescriptionOptions(context),
            icon: const Icon(LucideIcons.plus),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryTeal,
          tabs: const [
            Tab(text: 'Medications'),
            Tab(text: 'Prescriptions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicationsTab(),
          _buildPrescriptionsTab(),
        ],
      ),
    );
  }

  Widget _buildMedicationsTab() {
    return Consumer<MedicationViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final meds = vm.medications;

        return RefreshIndicator(
          onRefresh: () => vm.fetchMedications(),
          child: meds.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.pill,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No active medications',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your prescribed medications will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                MedicationScreen.showAddPrescriptionOptions(
                                    context),
                            icon: const Icon(LucideIcons.plus, size: 18),
                            label: const Text('Add Prescription'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: meds.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSectionHeader(
                            'Current Medications (${meds.length})'),
                      );
                    }
                    final med = meds[index - 1] as Map<String, dynamic>;
                    final name = med['medicine_name']?.toString() ??
                        med['name']?.toString() ??
                        'Medication';
                    final dosage = med['dosage']?.toString() ??
                        med['instructions']?.toString() ??
                        '';
                    final frequency = med['frequency']?.toString() ??
                        med['duration']?.toString() ??
                        'Daily';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMedicationCard(
                        name,
                        dosage.isNotEmpty ? dosage : frequency,
                        frequency,
                        LucideIcons.pill,
                        AppColors.primaryTeal,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildPrescriptionsTab() {
    return Consumer<MedicationViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final prescriptions = vm.prescriptions;

        return RefreshIndicator(
          onRefresh: () => vm.fetchPrescriptions(),
          child: prescriptions.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.fileText,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No prescriptions found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a prescription by scanning or entering code.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                MedicationScreen.showAddPrescriptionOptions(
                                    context),
                            icon: const Icon(LucideIcons.plus, size: 18),
                            label: const Text('Add Prescription'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: prescriptions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSectionHeader(
                            'Prescription History (${prescriptions.length})'),
                      );
                    }

                    final prescription =
                        prescriptions[index - 1] as Map<String, dynamic>;
                    final doctor = prescription['doctor_name']?.toString() ??
                        prescription['doctor']?.toString() ??
                        'Dr. Verified';
                    final date = prescription['created_at']?.toString() ??
                        prescription['date']?.toString() ??
                        '';
                    final diagnosis =
                        prescription['diagnosis']?.toString() ??
                            prescription['chief_complaint']?.toString() ??
                            'General Consultation';
                    final medCount = (prescription['medications'] is List)
                        ? (prescription['medications'] as List).length
                        : (prescription['items_count'] ?? 1) as int;

                    return _buildPrescriptionCard(
                      doctor,
                      date.length > 10 ? date.substring(0, 10) : date,
                      diagnosis,
                      medCount,
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMedicationCard(
      String name, String dosage, String time, IconData icon, Color color,
      {bool isWarning = false}) {
    return Card(
      elevation: 0,
      color: isWarning
          ? AppColors.errorRed.withValues(alpha: 0.05)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isWarning
                ? AppColors.errorRed.withValues(alpha: 0.2)
                : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(dosage,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isWarning ? AppColors.errorRed : AppColors.primaryTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionCard(
      String doctor, String date, String diagnosis, int medications) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription details')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.fileText,
                    color: AppColors.primaryTeal, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(diagnosis,
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('$medications medication(s)',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(LucideIcons.chevronRight,
                      size: 20, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
