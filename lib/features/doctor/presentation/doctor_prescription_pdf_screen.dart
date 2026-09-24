import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../data/doctor_dummy_data.dart';
import '../data/doctor_models.dart';

class DoctorPrescriptionPdfScreen extends StatelessWidget {
  final PrescriptionModel prescription;
  const DoctorPrescriptionPdfScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorDummyData.currentDoctor;
    final patient = DoctorDummyData.patients.where((p) => p.id == prescription.patientId).toList();
    final patientData = patient.isNotEmpty ? patient.first : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Prescription PDF Preview'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PDF downloaded to device storage')),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Prescription shared successfully')),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPdfHeader(context, doctor),
                _buildDivider(),
                _buildPatientDoctor(context, doctor, patientData),
                _buildDivider(),
                _buildMedicinesSection(context),
                _buildDivider(),
                if (prescription.notes.isNotEmpty) ...[
                  _buildNotesSection(context),
                  _buildDivider(),
                ],
                _buildSignatureSection(context, doctor),
                _buildPdfFooter(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildPdfHeader(BuildContext context, DoctorProfile doctor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryTeal, Color(0xFF00796B)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.heartPulse, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MediRx', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text('MEDICAL PRESCRIPTION', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, letterSpacing: 1.5)),
                const SizedBox(height: 6),
                Text(doctor.hospital, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Rx #${prescription.id.split("-").last}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(_formatDate(prescription.date), style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
              const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildPatientDoctor(BuildContext context, DoctorProfile doctor, PatientModel? patient) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pdfLabel('PHYSICIAN'),
                const SizedBox(height: 6),
                Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                Text(doctor.qualification, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text(doctor.specialization, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Text('BMDC Reg: ${doctor.regNo}', style: TextStyle(color: AppColors.primaryTeal, fontSize: 11, fontWeight: FontWeight.w600)),
                Text(doctor.phone, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
          Container(width: 1, height: 100, color: Colors.grey[200]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pdfLabel('PATIENT'),
                const SizedBox(height: 6),
                Text(prescription.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                if (patient != null) ...[
                  Text('${patient.age} years • ${patient.gender}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text('Blood Group: ${patient.bloodGroup}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: patient.conditions.map((c) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(c, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 9)),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicinesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.pill, size: 16, color: AppColors.primaryTeal),
              const SizedBox(width: 8),
              _pdfLabel('PRESCRIBED MEDICINES'),
            ],
          ),
          const SizedBox(height: 12),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                SizedBox(width: 24, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(flex: 3, child: Text('Medicine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(flex: 2, child: Text('Dosage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(flex: 2, child: Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(flex: 2, child: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...prescription.items.asMap().entries.map((e) {
            final item = e.value;
            final isEven = e.key % 2 == 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isEven ? Colors.grey[50] : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text('${e.key + 1}.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryTeal)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.medicineName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            if (item.instructions.isNotEmpty)
                              Text(item.instructions, style: TextStyle(color: Colors.grey[600], fontSize: 10, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(item.dosage, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 2, child: Text(item.frequency, style: const TextStyle(fontSize: 11))),
                      Expanded(flex: 2, child: Text(item.duration, style: const TextStyle(fontSize: 11))),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pdfLabel('DOCTOR\'S NOTES & INSTRUCTIONS'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Text(prescription.notes, style: const TextStyle(fontSize: 12, height: 1.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(BuildContext context, DoctorProfile doctor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pdfLabel('PATIENT\'S SIGNATURE'),
              const SizedBox(height: 30),
              Container(width: 140, height: 1, color: Colors.grey[400]),
              const SizedBox(height: 4),
              Text('Patient / Guardian', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _pdfLabel('DOCTOR\'S SIGNATURE'),
              const SizedBox(height: 10),
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 6),
              Container(width: 140, height: 1, color: Colors.grey[400]),
              const SizedBox(height: 4),
              Text(doctor.name, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
              Text(doctor.regNo, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPdfFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Text(
            'This is a digitally generated prescription from MediRx. Valid for 30 days from date of issue.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            'Generated on: ${_formatDateFull(prescription.date)}  |  MediRx Digital Health Platform',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prescription shared via WhatsApp')),
              ),
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
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF saved to Downloads folder')),
              ),
              icon: const Icon(LucideIcons.download, color: Colors.white, size: 18),
              label: const Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pdfLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTeal,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Colors.grey[200], height: 1),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }

  String _formatDateFull(DateTime d) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
