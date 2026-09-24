import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';
import 'doctor_prescription_summary_screen.dart';

class _MedicineEntry {
  String medicineName;
  String dosage;
  String frequency;
  String duration;
  String instructions;
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController instructionsController;
  bool showSuggestions;
  List<MedicineModel> suggestions;

  _MedicineEntry()
      : medicineName = '',
        dosage = '',
        frequency = DoctorDummyData.frequencies.first,
        duration = DoctorDummyData.durations[4],
        instructions = '',
        nameController = TextEditingController(),
        dosageController = TextEditingController(),
        instructionsController = TextEditingController(),
        showSuggestions = false,
        suggestions = [];

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    instructionsController.dispose();
  }

  PrescriptionItem toPrescriptionItem() => PrescriptionItem(
    medicineId: 'm-custom',
    medicineName: medicineName,
    dosage: dosage,
    frequency: frequency,
    duration: duration,
    instructions: instructions,
  );
}

class DoctorCreatePrescriptionScreen extends StatefulWidget {
  final PatientModel? preselectedPatient;
  const DoctorCreatePrescriptionScreen({super.key, this.preselectedPatient});

  @override
  State<DoctorCreatePrescriptionScreen> createState() => _DoctorCreatePrescriptionScreenState();
}

class _DoctorCreatePrescriptionScreenState extends State<DoctorCreatePrescriptionScreen> {
  PatientModel? _selectedPatient;
  final List<_MedicineEntry> _medicines = [_MedicineEntry()];
  final _notesController = TextEditingController();
  bool _isRecording = false;
  String _voiceInstructions = '';
  final List<String> _attachments = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedPatient = widget.preselectedPatient;
  }

  @override
  void dispose() {
    _notesController.dispose();
    for (final m in _medicines) m.dispose();
    super.dispose();
  }

  void _onMedicineNameChanged(_MedicineEntry entry, String query) {
    setState(() {
      entry.medicineName = query;
      if (query.length >= 2) {
        entry.suggestions = DoctorDummyData.medicines
            .where((m) =>
                m.name.toLowerCase().contains(query.toLowerCase()) ||
                m.genericName.toLowerCase().contains(query.toLowerCase()))
            .take(5)
            .toList();
        entry.showSuggestions = entry.suggestions.isNotEmpty;
      } else {
        entry.showSuggestions = false;
        entry.suggestions = [];
      }
    });
  }

  void _selectMedicine(_MedicineEntry entry, MedicineModel medicine) {
    setState(() {
      entry.medicineName = medicine.name;
      entry.dosage = medicine.strength;
      entry.nameController.text = medicine.name;
      entry.dosageController.text = medicine.strength;
      entry.showSuggestions = false;
      entry.suggestions = [];
    });
  }

  void _addMedicine() {
    setState(() => _medicines.add(_MedicineEntry()));
  }

  void _removeMedicine(int index) {
    if (_medicines.length > 1) {
      _medicines[index].dispose();
      setState(() => _medicines.removeAt(index));
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (!_isRecording) {
        _voiceInstructions = 'Take medications as prescribed. Avoid missing doses. Contact doctor if side effects occur.';
      }
    });
  }

  Future<void> _pickAttachment() async {
    final result = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() => _attachments.add(result.name));
    }
  }

  void _generatePrescription() {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient first')),
      );
      return;
    }
    final validMedicines = _medicines.where((m) => m.medicineName.isNotEmpty).toList();
    if (validMedicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medicine')),
      );
      return;
    }

    final prescription = PrescriptionModel(
      id: 'rx-new-${DateTime.now().millisecondsSinceEpoch}',
      patientId: _selectedPatient!.id,
      patientName: _selectedPatient!.name,
      date: DateTime.now(),
      items: validMedicines.map((m) => m.toPrescriptionItem()).toList(),
      notes: _notesController.text,
      voiceInstructions: _voiceInstructions,
      testAttachments: _attachments,
      status: 'active',
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DoctorPrescriptionSummaryScreen(prescription: prescription)),
    );
  }

  void _saveAsDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prescription saved as draft')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('New Prescription'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveAsDraft,
            child: const Text('Save Draft', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientSelector(),
            const SizedBox(height: 20),
            _buildSectionHeader('Medicines', icon: LucideIcons.pill),
            const SizedBox(height: 12),
            ..._medicines.asMap().entries.map((e) => _buildMedicineCard(e.key, e.value)),
            _buildAddMedicineButton(),
            const SizedBox(height: 20),
            _buildSectionHeader('Doctor Notes', icon: LucideIcons.stickyNote),
            const SizedBox(height: 12),
            _buildNotesField(),
            const SizedBox(height: 20),
            _buildSectionHeader('Voice Instructions', icon: LucideIcons.mic),
            const SizedBox(height: 12),
            _buildVoiceInstructions(),
            const SizedBox(height: 20),
            _buildSectionHeader('Test Attachments', icon: LucideIcons.paperclip),
            const SizedBox(height: 12),
            _buildAttachments(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryTeal),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPatientSelector() {
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
              const Icon(LucideIcons.user, size: 18, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              const Text('Patient', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PatientModel>(
            value: _selectedPatient,
            hint: const Text('Select patient'),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            items: DoctorDummyData.patients.map((p) => DropdownMenuItem(
              value: p,
              child: Text('${p.name} • ${p.age}y ${p.gender}', style: const TextStyle(fontSize: 14)),
            )).toList(),
            onChanged: (p) => setState(() => _selectedPatient = p),
          ),
          if (_selectedPatient != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: _selectedPatient!.conditions.map((c) => Chip(
                label: Text(c, style: const TextStyle(fontSize: 11)),
                backgroundColor: AppColors.primaryTeal.withOpacity(0.08),
                labelStyle: const TextStyle(color: AppColors.primaryTeal),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicineCard(int index, _MedicineEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Medicine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              if (_medicines.length > 1)
                InkWell(
                  onTap: () => _removeMedicine(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(LucideIcons.trash2, size: 16, color: AppColors.errorRed),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Medicine Name with auto-suggest
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: entry.nameController,
                onChanged: (v) => _onMedicineNameChanged(entry, v),
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  hintText: 'Type to search...',
                  prefixIcon: const Icon(LucideIcons.search, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              if (entry.showSuggestions)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: entry.suggestions.map((med) => ListTile(
                      dense: true,
                      title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${med.genericName} • ${med.strength} • ${med.form}', style: const TextStyle(fontSize: 11)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(med.form, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 10)),
                      ),
                      onTap: () => _selectMedicine(entry, med),
                    )).toList(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Dosage & Frequency
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: entry.dosageController,
                  onChanged: (v) => entry.dosage = v,
                  decoration: InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g. 500mg',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: entry.frequency,
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  isExpanded: true,
                  items: DoctorDummyData.frequencies.map((f) => DropdownMenuItem(
                    value: f,
                    child: Text(f, style: const TextStyle(fontSize: 12)),
                  )).toList(),
                  onChanged: (v) => setState(() => entry.frequency = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Duration
          DropdownButtonFormField<String>(
            value: entry.duration,
            decoration: InputDecoration(
              labelText: 'Duration',
              prefixIcon: const Icon(LucideIcons.clock, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            items: DoctorDummyData.durations.map((d) => DropdownMenuItem(
              value: d,
              child: Text(d, style: const TextStyle(fontSize: 14)),
            )).toList(),
            onChanged: (v) => setState(() => entry.duration = v!),
          ),
          const SizedBox(height: 10),
          // Instructions
          TextField(
            controller: entry.instructionsController,
            onChanged: (v) => entry.instructions = v,
            decoration: InputDecoration(
              labelText: 'Instructions (optional)',
              hintText: 'e.g. Take after meals',
              prefixIcon: const Icon(LucideIcons.info, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMedicineButton() {
    return InkWell(
      onTap: _addMedicine,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryTeal, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(14),
          color: AppColors.primaryTeal.withOpacity(0.04),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, color: AppColors.primaryTeal, size: 18),
            SizedBox(width: 8),
            Text('Add Another Medicine', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: _notesController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Write doctor notes, follow-up instructions, diet recommendations...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildVoiceInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? AppColors.errorRed : AppColors.primaryTeal,
                    boxShadow: _isRecording
                        ? [BoxShadow(color: AppColors.errorRed.withOpacity(0.4), blurRadius: 16, spreadRadius: 4)]
                        : [],
                  ),
                  child: Icon(
                    _isRecording ? LucideIcons.square : LucideIcons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRecording ? 'Recording...' : 'Voice Instruction',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isRecording ? AppColors.errorRed : null,
                      ),
                    ),
                    Text(
                      _isRecording ? 'Tap to stop recording' : 'Tap mic to record instructions for patient',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_voiceInstructions.isNotEmpty && !_isRecording) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.volume2, size: 16, color: AppColors.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_voiceInstructions, style: const TextStyle(fontSize: 12, color: AppColors.primaryTeal)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachments() {
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
          ..._attachments.map((file) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(LucideIcons.file, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Expanded(child: Text(file, style: const TextStyle(fontSize: 13))),
                InkWell(
                  onTap: () => setState(() => _attachments.remove(file)),
                  child: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                ),
              ],
            ),
          )),
          InkWell(
            onTap: _pickAttachment,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryTeal.withOpacity(0.4), style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryTeal.withOpacity(0.04),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.upload, color: AppColors.primaryTeal, size: 18),
                  SizedBox(width: 8),
                  Text('Attach Test Results', style: TextStyle(color: AppColors.primaryTeal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _generatePrescription,
            icon: const Icon(LucideIcons.fileCheck, color: Colors.white),
            label: const Text('Generate Prescription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _saveAsDraft,
            icon: const Icon(LucideIcons.save),
            label: const Text('Save as Draft'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTeal,
              side: const BorderSide(color: AppColors.primaryTeal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}
