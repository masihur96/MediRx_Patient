import 'package:flutter/material.dart';
import 'doctor_models.dart';

class DoctorDummyData {
  // ─── Doctor Profile ─────────────────────────────────────────────────────────

  static const DoctorProfile currentDoctor = DoctorProfile(
    id: 'doc-001',
    name: 'Dr. Arif Rahman',
    qualification: 'MBBS, FCPS (Medicine)',
    specialization: 'Internal Medicine',
    regNo: 'BMDC-12345',
    hospital: 'Dhaka Medical College & Hospital',
    experience: '12 years',
    rating: 4.8,
    totalPatients: 320,
    phone: '+880 1711-234567',
    email: 'doctor@medirx.com',
    bio:
        'Dr. Arif Rahman is a highly experienced Internal Medicine specialist with over 12 years of clinical practice. He completed his FCPS from BCPS and has been serving at Dhaka Medical College & Hospital, contributing to patient care and medical research.',
  );

  // ─── Patients ────────────────────────────────────────────────────────────────

  static final List<PatientModel> patients = [
    PatientModel(
      id: 'pat-001',
      name: 'Rahim Ahmed',
      age: 45,
      gender: 'Male',
      bloodGroup: 'B+',
      conditions: ['Hypertension', 'Diabetes Type 2'],
      phone: '+880 1712-345678',
      address: 'Mirpur-10, Dhaka',
      lastVisit: DateTime(2026, 9, 10),
      adherencePercent: 78.0,
      avatarInitials: 'RA',
    ),
    PatientModel(
      id: 'pat-002',
      name: 'Fatima Begum',
      age: 32,
      gender: 'Female',
      bloodGroup: 'A+',
      conditions: ['Anemia', 'Hypothyroidism'],
      phone: '+880 1713-456789',
      address: 'Dhanmondi, Dhaka',
      lastVisit: DateTime(2026, 9, 15),
      adherencePercent: 92.0,
      avatarInitials: 'FB',
    ),
    PatientModel(
      id: 'pat-003',
      name: 'Karim Khan',
      age: 67,
      gender: 'Male',
      bloodGroup: 'O+',
      conditions: ['COPD', 'Ischemic Heart Disease'],
      phone: '+880 1714-567890',
      address: 'Gulshan-2, Dhaka',
      lastVisit: DateTime(2026, 9, 5),
      adherencePercent: 61.0,
      avatarInitials: 'KK',
    ),
    PatientModel(
      id: 'pat-004',
      name: 'Sara Islam',
      age: 28,
      gender: 'Female',
      bloodGroup: 'AB+',
      conditions: ['Chronic Migraine'],
      phone: '+880 1715-678901',
      address: 'Uttara, Dhaka',
      lastVisit: DateTime(2026, 9, 18),
      adherencePercent: 85.0,
      avatarInitials: 'SI',
    ),
    PatientModel(
      id: 'pat-005',
      name: 'Nabil Hassan',
      age: 52,
      gender: 'Male',
      bloodGroup: 'B-',
      conditions: ['Diabetes Type 2', 'Chronic Kidney Disease Stage 3'],
      phone: '+880 1716-789012',
      address: 'Banani, Dhaka',
      lastVisit: DateTime(2026, 9, 12),
      adherencePercent: 54.0,
      avatarInitials: 'NH',
    ),
  ];

  // ─── Medicines List ──────────────────────────────────────────────────────────

  static const List<MedicineModel> medicines = [
    MedicineModel(id: 'm-01', name: 'Metformin', genericName: 'Metformin HCl', strength: '500mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-02', name: 'Atorvastatin', genericName: 'Atorvastatin Calcium', strength: '10mg', form: 'Tablet', manufacturer: 'Beximco'),
    MedicineModel(id: 'm-03', name: 'Amlodipine', genericName: 'Amlodipine Besylate', strength: '5mg', form: 'Tablet', manufacturer: 'Renata'),
    MedicineModel(id: 'm-04', name: 'Losartan', genericName: 'Losartan Potassium', strength: '50mg', form: 'Tablet', manufacturer: 'ACI'),
    MedicineModel(id: 'm-05', name: 'Omeprazole', genericName: 'Omeprazole', strength: '20mg', form: 'Capsule', manufacturer: 'Square'),
    MedicineModel(id: 'm-06', name: 'Aspirin', genericName: 'Acetylsalicylic Acid', strength: '75mg', form: 'Tablet', manufacturer: 'Globe'),
    MedicineModel(id: 'm-07', name: 'Lisinopril', genericName: 'Lisinopril', strength: '10mg', form: 'Tablet', manufacturer: 'Incepta'),
    MedicineModel(id: 'm-08', name: 'Glibenclamide', genericName: 'Glibenclamide', strength: '5mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-09', name: 'Insulin Glargine', genericName: 'Insulin Glargine', strength: '100 IU/mL', form: 'Injection', manufacturer: 'Novo Nordisk'),
    MedicineModel(id: 'm-10', name: 'Levothyroxine', genericName: 'Levothyroxine Sodium', strength: '50mcg', form: 'Tablet', manufacturer: 'Opsonin'),
    MedicineModel(id: 'm-11', name: 'Ferrous Sulfate', genericName: 'Ferrous Sulfate', strength: '200mg', form: 'Tablet', manufacturer: 'Beximco'),
    MedicineModel(id: 'm-12', name: 'Folic Acid', genericName: 'Folic Acid', strength: '5mg', form: 'Tablet', manufacturer: 'ACI'),
    MedicineModel(id: 'm-13', name: 'Salbutamol', genericName: 'Salbutamol Sulfate', strength: '2mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-14', name: 'Tiotropium', genericName: 'Tiotropium Bromide', strength: '18mcg', form: 'Inhaler', manufacturer: 'Boehringer'),
    MedicineModel(id: 'm-15', name: 'Pantoprazole', genericName: 'Pantoprazole Sodium', strength: '40mg', form: 'Tablet', manufacturer: 'Renata'),
    MedicineModel(id: 'm-16', name: 'Cetirizine', genericName: 'Cetirizine HCl', strength: '10mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-17', name: 'Amoxicillin', genericName: 'Amoxicillin Trihydrate', strength: '500mg', form: 'Capsule', manufacturer: 'Incepta'),
    MedicineModel(id: 'm-18', name: 'Azithromycin', genericName: 'Azithromycin Dihydrate', strength: '500mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-19', name: 'Ceftriaxone', genericName: 'Ceftriaxone Sodium', strength: '1g', form: 'Injection', manufacturer: 'Beximco'),
    MedicineModel(id: 'm-20', name: 'Metronidazole', genericName: 'Metronidazole', strength: '400mg', form: 'Tablet', manufacturer: 'Globe'),
    MedicineModel(id: 'm-21', name: 'Nifedipine', genericName: 'Nifedipine', strength: '10mg', form: 'Capsule', manufacturer: 'Renata'),
    MedicineModel(id: 'm-22', name: 'Bisoprolol', genericName: 'Bisoprolol Fumarate', strength: '5mg', form: 'Tablet', manufacturer: 'Opsonin'),
    MedicineModel(id: 'm-23', name: 'Spironolactone', genericName: 'Spironolactone', strength: '25mg', form: 'Tablet', manufacturer: 'ACI'),
    MedicineModel(id: 'm-24', name: 'Furosemide', genericName: 'Furosemide', strength: '40mg', form: 'Tablet', manufacturer: 'Square'),
    MedicineModel(id: 'm-25', name: 'Warfarin', genericName: 'Warfarin Sodium', strength: '5mg', form: 'Tablet', manufacturer: 'Beximco'),
    MedicineModel(id: 'm-26', name: 'Allopurinol', genericName: 'Allopurinol', strength: '100mg', form: 'Tablet', manufacturer: 'Incepta'),
    MedicineModel(id: 'm-27', name: 'Gabapentin', genericName: 'Gabapentin', strength: '300mg', form: 'Capsule', manufacturer: 'Square'),
    MedicineModel(id: 'm-28', name: 'Tramadol', genericName: 'Tramadol HCl', strength: '50mg', form: 'Capsule', manufacturer: 'Renata'),
    MedicineModel(id: 'm-29', name: 'Vitamin D3', genericName: 'Cholecalciferol', strength: '2000 IU', form: 'Tablet', manufacturer: 'Globe'),
    MedicineModel(id: 'm-30', name: 'Calcium Carbonate', genericName: 'Calcium Carbonate', strength: '500mg', form: 'Tablet', manufacturer: 'ACI'),
  ];

  // ─── Prescriptions ───────────────────────────────────────────────────────────

  static final List<PrescriptionModel> prescriptions = [
    PrescriptionModel(
      id: 'rx-001',
      patientId: 'pat-001',
      patientName: 'Rahim Ahmed',
      date: DateTime(2026, 9, 10),
      items: const [
        PrescriptionItem(medicineId: 'm-01', medicineName: 'Metformin', dosage: '500mg', frequency: 'Twice daily', duration: '1 month', instructions: 'Take after meals'),
        PrescriptionItem(medicineId: 'm-03', medicineName: 'Amlodipine', dosage: '5mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take in the morning'),
        PrescriptionItem(medicineId: 'm-06', medicineName: 'Aspirin', dosage: '75mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take with food'),
      ],
      notes: 'Monitor blood pressure daily. Reduce salt intake. Follow up in 4 weeks.',
      voiceInstructions: 'Take Metformin with meals twice a day. Never skip Amlodipine.',
      testAttachments: [],
      status: 'active',
    ),
    PrescriptionModel(
      id: 'rx-002',
      patientId: 'pat-001',
      patientName: 'Rahim Ahmed',
      date: DateTime(2026, 8, 10),
      items: const [
        PrescriptionItem(medicineId: 'm-01', medicineName: 'Metformin', dosage: '500mg', frequency: 'Twice daily', duration: '1 month', instructions: 'Take after meals'),
        PrescriptionItem(medicineId: 'm-04', medicineName: 'Losartan', dosage: '50mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take in morning'),
      ],
      notes: 'BP still elevated. Increased Losartan dose.',
      voiceInstructions: '',
      testAttachments: [],
      status: 'completed',
    ),
    PrescriptionModel(
      id: 'rx-003',
      patientId: 'pat-002',
      patientName: 'Fatima Begum',
      date: DateTime(2026, 9, 15),
      items: const [
        PrescriptionItem(medicineId: 'm-11', medicineName: 'Ferrous Sulfate', dosage: '200mg', frequency: 'Twice daily', duration: '3 months', instructions: 'Take with Vitamin C'),
        PrescriptionItem(medicineId: 'm-12', medicineName: 'Folic Acid', dosage: '5mg', frequency: 'Once daily', duration: '3 months', instructions: 'Take in the morning'),
        PrescriptionItem(medicineId: 'm-10', medicineName: 'Levothyroxine', dosage: '50mcg', frequency: 'Once daily', duration: '3 months', instructions: 'Take 30 min before breakfast'),
      ],
      notes: 'Hemoglobin level 9.2 g/dL. TSH 8.5 mIU/L. Recheck in 6 weeks.',
      voiceInstructions: 'Take iron tablet with orange juice for better absorption.',
      testAttachments: ['CBC_Report.jpg'],
      status: 'active',
    ),
    PrescriptionModel(
      id: 'rx-004',
      patientId: 'pat-003',
      patientName: 'Karim Khan',
      date: DateTime(2026, 9, 5),
      items: const [
        PrescriptionItem(medicineId: 'm-13', medicineName: 'Salbutamol', dosage: '2mg', frequency: 'Three times daily', duration: '14 days', instructions: 'Use during breathing difficulty'),
        PrescriptionItem(medicineId: 'm-14', medicineName: 'Tiotropium', dosage: '18mcg', frequency: 'Once daily', duration: '1 month', instructions: 'Inhale once daily'),
        PrescriptionItem(medicineId: 'm-22', medicineName: 'Bisoprolol', dosage: '5mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take in the morning'),
        PrescriptionItem(medicineId: 'm-24', medicineName: 'Furosemide', dosage: '40mg', frequency: 'Once daily', duration: '14 days', instructions: 'Take in morning, monitor urine output'),
      ],
      notes: 'Oxygen saturation 88% at rest. Admit if worsens. Low salt diet.',
      voiceInstructions: 'Do NOT use inhaler more than prescribed. Call emergency if breathing worsens.',
      testAttachments: ['Chest_Xray.jpg', 'ECG_Report.pdf'],
      status: 'active',
    ),
    PrescriptionModel(
      id: 'rx-005',
      patientId: 'pat-004',
      patientName: 'Sara Islam',
      date: DateTime(2026, 9, 18),
      items: const [
        PrescriptionItem(medicineId: 'm-27', medicineName: 'Gabapentin', dosage: '300mg', frequency: 'Twice daily', duration: '1 month', instructions: 'Take with food'),
        PrescriptionItem(medicineId: 'm-16', medicineName: 'Cetirizine', dosage: '10mg', frequency: 'Once daily at night', duration: '14 days', instructions: 'Take at bedtime'),
      ],
      notes: 'Migraine frequency: 3 attacks/month. Keep headache diary. Avoid triggers.',
      voiceInstructions: 'Rest in dark quiet room during attacks. Stay hydrated.',
      testAttachments: [],
      status: 'active',
    ),
    PrescriptionModel(
      id: 'rx-006',
      patientId: 'pat-005',
      patientName: 'Nabil Hassan',
      date: DateTime(2026, 9, 12),
      items: const [
        PrescriptionItem(medicineId: 'm-08', medicineName: 'Glibenclamide', dosage: '5mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take before breakfast'),
        PrescriptionItem(medicineId: 'm-26', medicineName: 'Allopurinol', dosage: '100mg', frequency: 'Once daily', duration: '1 month', instructions: 'Take with plenty of water'),
        PrescriptionItem(medicineId: 'm-23', medicineName: 'Spironolactone', dosage: '25mg', frequency: 'Once daily', duration: '1 month', instructions: 'Monitor potassium levels'),
      ],
      notes: 'eGFR 42 mL/min. Creatinine 1.8 mg/dL. Avoid NSAIDs. Protein restriction diet.',
      voiceInstructions: 'Drink at least 2 liters of water daily. Avoid painkiller tablets.',
      testAttachments: ['Kidney_Function_Test.pdf'],
      status: 'active',
    ),
  ];

  // ─── Clinical Notes ──────────────────────────────────────────────────────────

  static final List<ClinicalNote> clinicalNotes = [
    ClinicalNote(
      id: 'cn-001',
      patientId: 'pat-001',
      date: DateTime(2026, 9, 10),
      title: 'Blood Pressure Follow-up',
      content: 'Patient presented with BP 150/95. Started Amlodipine 5mg. Patient cooperative and understanding of medication regimen. Wife accompanies for support.',
      isPrivate: true,
    ),
    ClinicalNote(
      id: 'cn-002',
      patientId: 'pat-001',
      date: DateTime(2026, 8, 10),
      title: 'Diabetes Control Review',
      content: 'HbA1c: 8.2%. Needs better diet control. Patient admits to irregular meals. Referred to dietician. Metformin dose maintained.',
      isPrivate: true,
    ),
    ClinicalNote(
      id: 'cn-003',
      patientId: 'pat-002',
      date: DateTime(2026, 9, 15),
      title: 'Anemia Evaluation',
      content: 'CBC shows Hb 9.2, MCV low - suggesting iron deficiency anemia. Thyroid panel: TSH elevated. Iron + Levothyroxine started. Very compliant patient.',
      isPrivate: true,
    ),
    ClinicalNote(
      id: 'cn-004',
      patientId: 'pat-003',
      date: DateTime(2026, 9, 5),
      title: 'COPD Exacerbation',
      content: 'Severe COPD exacerbation. O2 sat 88%. Crepitations bilaterally. Admitted for 3 days. Discharged stable with revised medication. Family educated on emergency signs.',
      isPrivate: true,
    ),
    ClinicalNote(
      id: 'cn-005',
      patientId: 'pat-004',
      date: DateTime(2026, 9, 18),
      title: 'Migraine Pattern Analysis',
      content: 'Patient has perimenstrual migraine pattern. 3 attacks last month. Triggers: stress, bright lights, irregular sleep. Started Gabapentin as prophylaxis.',
      isPrivate: false,
    ),
    ClinicalNote(
      id: 'cn-006',
      patientId: 'pat-005',
      date: DateTime(2026, 9, 12),
      title: 'CKD Progression Monitoring',
      content: 'eGFR declining from 58 (3 months ago) to 42 now. Stage 3 CKD. Nephrology referral made. Strict protein restriction. BP well controlled.',
      isPrivate: true,
    ),
  ];

  // ─── Adherence Data Generator ────────────────────────────────────────────────

  static List<AdherenceDay> getAdherenceData(String patientId) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 2, 1);
    final List<AdherenceDay> days = [];

    final adherenceRates = {
      'pat-001': 0.78,
      'pat-002': 0.92,
      'pat-003': 0.61,
      'pat-004': 0.85,
      'pat-005': 0.54,
    };
    final rate = adherenceRates[patientId] ?? 0.7;

    for (int i = 0; i < 60; i++) {
      final date = startDate.add(Duration(days: i));
      if (date.isAfter(now)) break;

      final random = (i * 7 + patientId.hashCode) % 100;
      AdherenceStatus status;
      if (random < (rate * 100).toInt()) {
        status = AdherenceStatus.taken;
      } else if (random < 90) {
        status = AdherenceStatus.missed;
      } else {
        status = AdherenceStatus.noData;
      }
      days.add(AdherenceDay(date: date, status: status));
    }
    return days;
  }

  // ─── Analytics ───────────────────────────────────────────────────────────────

  static DoctorAnalytics get analytics => DoctorAnalytics(
    totalPrescriptions: 248,
    activePatients: 86,
    thisMonthPrescriptions: 32,
    avgAdherence: 74.0,
    topMedicines: [
      MedicineUsageStat(medicineName: 'Metformin', prescriptionCount: 48, color: const Color(0xFF009688)),
      MedicineUsageStat(medicineName: 'Amlodipine', prescriptionCount: 37, color: const Color(0xFF26A69A)),
      MedicineUsageStat(medicineName: 'Atorvastatin', prescriptionCount: 32, color: const Color(0xFF4DB6AC)),
      MedicineUsageStat(medicineName: 'Losartan', prescriptionCount: 28, color: const Color(0xFF80CBC4)),
      MedicineUsageStat(medicineName: 'Aspirin', prescriptionCount: 25, color: const Color(0xFFB2DFDB)),
      MedicineUsageStat(medicineName: 'Omeprazole', prescriptionCount: 20, color: const Color(0xFF00796B)),
    ],
    prescriptionsByMonth: {
      'Apr': 22,
      'May': 27,
      'Jun': 19,
      'Jul': 31,
      'Aug': 28,
      'Sep': 32,
    },
  );

  // ─── Frequency Options ───────────────────────────────────────────────────────

  static const List<String> frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Once daily at night',
    'Every 8 hours',
    'Every 12 hours',
    'Before meals',
    'After meals',
    'As needed (PRN)',
  ];

  static const List<String> durations = [
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
    '1 month',
    '2 months',
    '3 months',
    '6 months',
    'Ongoing',
  ];
}
