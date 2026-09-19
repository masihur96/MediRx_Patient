import 'package:flutter/material.dart';

// ─── Doctor Profile Model ───────────────────────────────────────────────────

class DoctorProfile {
  final String id;
  final String name;
  final String qualification;
  final String specialization;
  final String regNo;
  final String hospital;
  final String experience;
  final double rating;
  final int totalPatients;
  final String phone;
  final String email;
  final String bio;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.regNo,
    required this.hospital,
    required this.experience,
    required this.rating,
    required this.totalPatients,
    required this.phone,
    required this.email,
    required this.bio,
  });
}

// ─── Patient Model ──────────────────────────────────────────────────────────

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final List<String> conditions;
  final String phone;
  final String address;
  final DateTime lastVisit;
  final double adherencePercent;
  final String avatarInitials;

  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.conditions,
    required this.phone,
    required this.address,
    required this.lastVisit,
    required this.adherencePercent,
    required this.avatarInitials,
  });
}

// ─── Medicine Model ─────────────────────────────────────────────────────────

class MedicineModel {
  final String id;
  final String name;
  final String genericName;
  final String strength;
  final String form; // tablet, capsule, syrup, injection
  final String manufacturer;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.genericName,
    required this.strength,
    required this.form,
    required this.manufacturer,
  });
}

// ─── Prescription Item ───────────────────────────────────────────────────────

class PrescriptionItem {
  final String medicineId;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const PrescriptionItem({
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });
}

// ─── Prescription Model ──────────────────────────────────────────────────────

class PrescriptionModel {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime date;
  final List<PrescriptionItem> items;
  final String notes;
  final String voiceInstructions;
  final List<String> testAttachments;
  final String status; // active, completed, draft

  const PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.items,
    required this.notes,
    required this.voiceInstructions,
    required this.testAttachments,
    required this.status,
  });
}

// ─── Clinical Note Model ─────────────────────────────────────────────────────

class ClinicalNote {
  final String id;
  final String patientId;
  final DateTime date;
  final String title;
  final String content;
  final bool isPrivate;

  const ClinicalNote({
    required this.id,
    required this.patientId,
    required this.date,
    required this.title,
    required this.content,
    required this.isPrivate,
  });
}

// ─── Adherence Data ──────────────────────────────────────────────────────────

enum AdherenceStatus { taken, missed, noData }

class AdherenceDay {
  final DateTime date;
  final AdherenceStatus status;

  const AdherenceDay({required this.date, required this.status});

  Color get color {
    switch (status) {
      case AdherenceStatus.taken:
        return const Color(0xFF009688);
      case AdherenceStatus.missed:
        return const Color(0xFFE57373);
      case AdherenceStatus.noData:
        return const Color(0xFFE0E0E0);
    }
  }
}

// ─── Analytics Model ─────────────────────────────────────────────────────────

class MedicineUsageStat {
  final String medicineName;
  final int prescriptionCount;
  final Color color;

  const MedicineUsageStat({
    required this.medicineName,
    required this.prescriptionCount,
    required this.color,
  });
}

class DoctorAnalytics {
  final int totalPrescriptions;
  final int activePatients;
  final int thisMonthPrescriptions;
  final double avgAdherence;
  final List<MedicineUsageStat> topMedicines;
  final Map<String, int> prescriptionsByMonth;

  const DoctorAnalytics({
    required this.totalPrescriptions,
    required this.activePatients,
    required this.thisMonthPrescriptions,
    required this.avgAdherence,
    required this.topMedicines,
    required this.prescriptionsByMonth,
  });
}

// ─── Notification Setting Model ───────────────────────────────────────────────

class NotificationSetting {
  final String id;
  final String title;
  final String subtitle;
  bool isEnabled;

  NotificationSetting({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });
}
