import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';
import 'doctor_prescription_pdf_screen.dart';

class DoctorPrescriptionSummaryScreen extends StatelessWidget {
  final PrescriptionModel prescription;
  const DoctorPrescriptionSummaryScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorDummyData.currentDoctor;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Prescription Summary'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: () => _sharePrescription(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.printer),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorPrescriptionPdfScreen(prescription: prescription),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRxCard(context, doctor),
            const SizedBox(height: 16),
            _buildMedicinesSection(context),
            const SizedBox(height: 16),
            if (prescription.notes.isNotEmpty) _buildNotesSection(context),
            const SizedBox(height: 16),
            if (prescription.voiceInstructions.isNotEmpty) _buildVoiceSection(context),
            const SizedBox(height: 16),
            if (prescription.testAttachments.isNotEmpty) _buildAttachmentsSection(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRxCard(BuildContext context, DoctorProfile doctor) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryTeal, Color(0xFF00796B)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.heartPulse, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MediRx', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Digital Prescription', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rx #${prescription.id.split('-').last}',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatDate(prescription.date),
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doctor', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(doctor.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(doctor.qualification, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          Text(doctor.regNo, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Patient', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(prescription.patientName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Builder(builder: (context) {
                            final patient = DoctorDummyData.patients.where((p) => p.id == prescription.patientId).toList();
                            if (patient.isEmpty) return const SizedBox();
                            return Text('${patient.first.age}y • ${patient.first.gender}', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12));
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.checkCircle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                const Text('Prescription Generated', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prescription.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicinesSection(BuildContext context) {
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
              const Icon(LucideIcons.pill, size: 18, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              const Text('Medicines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text('${prescription.items.length} items', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...prescription.items.asMap().entries.map((e) => _buildMedicineItem(e.key + 1, e.value, context)),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(int num, PrescriptionItem item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$num', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.medicineName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                _rxDetailRow(LucideIcons.hash, 'Dosage: ${item.dosage}'),
                _rxDetailRow(LucideIcons.repeat, 'Frequency: ${item.frequency}'),
                _rxDetailRow(LucideIcons.clock, 'Duration: ${item.duration}'),
                if (item.instructions.isNotEmpty)
                  _rxDetailRow(LucideIcons.info, item.instructions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rxDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey[500]),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
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
          const Row(
            children: [
              Icon(LucideIcons.stickyNote, size: 18, color: AppColors.primaryTeal),
              SizedBox(width: 8),
              Text('Doctor Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(prescription.notes, style: const TextStyle(fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildVoiceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.primaryTeal.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(LucideIcons.volume2, color: AppColors.primaryTeal, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Voice Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(prescription.voiceInstructions, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
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
          const Row(
            children: [
              Icon(LucideIcons.paperclip, size: 18, color: AppColors.primaryTeal),
              SizedBox(width: 8),
              Text('Attachments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ...prescription.testAttachments.map((file) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(LucideIcons.fileImage, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Text(file, style: const TextStyle(fontSize: 13)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorPrescriptionPdfScreen(prescription: prescription),
                  ),
                ),
                icon: const Icon(LucideIcons.fileDown, color: Colors.white, size: 18),
                label: const Text('View PDF', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size.zero,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _sharePrescription(context),
                icon: const Icon(LucideIcons.share2, size: 18),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTeal,
                  side: const BorderSide(color: AppColors.primaryTeal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size.zero,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _sharePrescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Share Prescription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _shareOption(ctx, LucideIcons.messageSquare, 'Send via WhatsApp', Colors.green),
            _shareOption(ctx, LucideIcons.mail, 'Send via Email', Colors.blue),
            _shareOption(ctx, LucideIcons.smartphone, 'Send via SMS', Colors.orange),
            _shareOption(ctx, LucideIcons.copy, 'Copy Link', AppColors.primaryTeal),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(BuildContext context, IconData icon, String label, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label),
      trailing: const Icon(LucideIcons.chevronRight, size: 16),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label - Prescription shared!')),
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }
}
