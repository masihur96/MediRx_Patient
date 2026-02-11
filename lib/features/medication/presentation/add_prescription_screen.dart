import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class Medication {
  String name;
  String dosage;
  String form;
  String frequency;
  String duration;
  String instructions;

  Medication({
    this.name = '',
    this.dosage = '',
    this.form = 'Tablet',
    this.frequency = '',
    this.duration = '',
    this.instructions = '',
  });
}

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Patient Information
  final _patientNameController = TextEditingController();
  final _patientAgeController = TextEditingController();
  String _patientGender = 'Male';
  final _patientContactController = TextEditingController();

  // Doctor Information
  final _doctorNameController = TextEditingController();
  final _doctorSpecializationController = TextEditingController();
  final _doctorLicenseController = TextEditingController();

  // Prescription Details
  DateTime _prescriptionDate = DateTime.now();
  final _diagnosisController = TextEditingController();
  final _adviceController = TextEditingController();
  DateTime? _followUpDate;

  // Medications
  List<Medication> _medications = [Medication()];

  final List<String> _medicineFormOptions = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Cream',
    'Ointment',
    'Inhaler',
    'Patch',
  ];

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _patientContactController.dispose();
    _doctorNameController.dispose();
    _doctorSpecializationController.dispose();
    _doctorLicenseController.dispose();
    _diagnosisController.dispose();
    _adviceController.dispose();
    super.dispose();
  }

  void _addMedication() {
    setState(() {
      _medications.add(Medication());
    });
  }

  void _removeMedication(int index) {
    if (_medications.length > 1) {
      setState(() {
        _medications.removeAt(index);
      });
    }
  }

  void _savePrescription() {
    if (_formKey.currentState!.validate()) {
      // Logic to save prescription
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(
      BuildContext context, bool isPrescriptionDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPrescriptionDate ? _prescriptionDate : (DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isPrescriptionDate) {
          _prescriptionDate = picked;
        } else {
          _followUpDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
        actions: [
          TextButton.icon(
            onPressed: _savePrescription,
            icon: const Icon(LucideIcons.save, color: AppColors.primaryTeal),
            label: const Text('Save',
                style: TextStyle(color: AppColors.primaryTeal)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Patient Information Section
              _buildSectionHeader('Patient Information', LucideIcons.user),
              const SizedBox(height: 16),
              _buildCard([
                TextFormField(
                  controller: _patientNameController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name *',
                    hintText: 'Enter patient name',
                    prefixIcon: const Icon(LucideIcons.user),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _patientAgeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age *',
                          hintText: 'Age',
                          prefixIcon: const Icon(LucideIcons.calendar),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _patientGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: const Icon(LucideIcons.users),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Male', 'Female', 'Other']
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _patientGender = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _patientContactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    hintText: 'Enter contact number',
                    prefixIcon: const Icon(LucideIcons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // Doctor Information Section
              _buildSectionHeader(
                  'Doctor Information', LucideIcons.stethoscope),
              const SizedBox(height: 16),
              _buildCard([
                TextFormField(
                  controller: _doctorNameController,
                  decoration: InputDecoration(
                    labelText: 'Doctor Name *',
                    hintText: 'Enter doctor name',
                    prefixIcon: const Icon(LucideIcons.userCheck),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _doctorSpecializationController,
                  decoration: InputDecoration(
                    labelText: 'Specialization',
                    hintText: 'e.g. General Physician',
                    prefixIcon: const Icon(LucideIcons.braces),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _doctorLicenseController,
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    hintText: 'Enter license number',
                    prefixIcon: const Icon(LucideIcons.badgeCheck),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // Prescription Details Section
              _buildSectionHeader('Prescription Details', LucideIcons.fileText),
              const SizedBox(height: 16),
              _buildCard([
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Prescription Date *',
                      prefixIcon: const Icon(LucideIcons.calendar),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                        DateFormat('dd MMM yyyy').format(_prescriptionDate)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _diagnosisController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Chief Complaint / Diagnosis *',
                    hintText: 'Enter diagnosis or symptoms',
                    prefixIcon: const Icon(LucideIcons.clipboardList),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ]),

              const SizedBox(height: 24),

              // Medications Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Medications', LucideIcons.pill),
                  IconButton(
                    onPressed: _addMedication,
                    icon: const Icon(LucideIcons.plus,
                        color: AppColors.primaryTeal),
                    tooltip: 'Add Medication',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._medications.asMap().entries.map((entry) {
                int index = entry.key;
                Medication med = entry.value;
                return _buildMedicationCard(index, med);
              }),

              const SizedBox(height: 24),

              // Additional Advice Section
              _buildSectionHeader(
                  'Additional Advice', LucideIcons.messageSquare),
              const SizedBox(height: 16),
              _buildCard([
                TextFormField(
                  controller: _adviceController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Advice / Notes',
                    hintText: 'Enter any additional advice or instructions',
                    prefixIcon: const Icon(LucideIcons.fileText),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Follow-up Date',
                      prefixIcon: const Icon(LucideIcons.calendarCheck),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _followUpDate == null
                          ? 'Select follow-up date'
                          : DateFormat('dd MMM yyyy').format(_followUpDate!),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryTeal, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMedicationCard(int index, Medication med) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medicine ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (_medications.length > 1)
                  IconButton(
                    onPressed: () => _removeMedication(index),
                    icon: const Icon(LucideIcons.x, size: 20),
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: med.name,
              decoration: InputDecoration(
                labelText: 'Medicine Name *',
                hintText: 'e.g. Paracetamol',
                prefixIcon: const Icon(LucideIcons.pill),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => med.name = value,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: med.dosage,
                    decoration: InputDecoration(
                      labelText: 'Dosage *',
                      hintText: 'e.g. 500mg',
                      prefixIcon: const Icon(LucideIcons.activity),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => med.dosage = value,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: med.form,
                    decoration: InputDecoration(
                      labelText: 'Form',
                      prefixIcon: const Icon(LucideIcons.package),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _medicineFormOptions
                        .map((form) =>
                            DropdownMenuItem(value: form, child: Text(form)))
                        .toList(),
                    onChanged: (value) => setState(() => med.form = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: med.frequency,
                    decoration: InputDecoration(
                      labelText: 'Frequency *',
                      hintText: 'e.g. 3 times/day',
                      prefixIcon: const Icon(LucideIcons.clock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => med.frequency = value,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: med.duration,
                    decoration: InputDecoration(
                      labelText: 'Duration *',
                      hintText: 'e.g. 7 days',
                      prefixIcon: const Icon(LucideIcons.calendarDays),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => med.duration = value,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: med.instructions,
              decoration: InputDecoration(
                labelText: 'Instructions',
                hintText: 'e.g. After meal',
                prefixIcon: const Icon(LucideIcons.info),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => med.instructions = value,
            ),
          ],
        ),
      ),
    );
  }
}
