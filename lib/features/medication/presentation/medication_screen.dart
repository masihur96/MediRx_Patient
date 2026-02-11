import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'scan_prescription_screen.dart';
import 'e_prescription_screen.dart';
import 'add_prescription_screen.dart';

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
                    color: AppColors.primaryTeal.withOpacity(0.1),
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
                    color: AppColors.surfaceDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(LucideIcons.fileDigit,
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
                    color: Colors.green.withOpacity(0.1),
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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader('Current Medications'),
        const SizedBox(height: 16),
        _buildMedicationCard(
          'Atorvastatin',
          '10mg - Once daily',
          'Before Bed',
          LucideIcons.pill,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildMedicationCard(
          'Metformin',
          '500mg - Twice daily',
          'After Meal',
          LucideIcons.tablet,
          Colors.green,
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Refills Needed'),
        const SizedBox(height: 16),
        _buildMedicationCard(
          'Vitamin D3',
          '2000 IU',
          '2 days left',
          LucideIcons.pill,
          Colors.orange,
          isWarning: true,
        ),
      ],
    );
  }

  Widget _buildPrescriptionsTab() {
    // Mock prescription data
    final prescriptions = [
      {
        'doctor': 'Dr. Sarah Ahmed',
        'date': '05 Feb 2026',
        'diagnosis': 'Hypertension',
        'medications': 3,
      },
      {
        'doctor': 'Dr. John Smith',
        'date': '28 Jan 2026',
        'diagnosis': 'Type 2 Diabetes',
        'medications': 2,
      },
      {
        'doctor': 'Dr. Sarah Ahmed',
        'date': '15 Jan 2026',
        'diagnosis': 'Vitamin Deficiency',
        'medications': 1,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: prescriptions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSectionHeader('Prescription History'),
          );
        }

        final prescription = prescriptions[index - 1];
        return _buildPrescriptionCard(
          prescription['doctor'] as String,
          prescription['date'] as String,
          prescription['diagnosis'] as String,
          prescription['medications'] as int,
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
      color: isWarning ? AppColors.errorRed.withOpacity(0.05) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isWarning
                ? AppColors.errorRed.withOpacity(0.2)
                : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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
          // Navigate to prescription details
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription details coming soon')),
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
                  color: AppColors.primaryTeal.withOpacity(0.1),
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
