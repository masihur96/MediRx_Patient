import 'package:flutter/material.dart';

// ─── Doctor Profile Model ───────────────────────────────────────────────────

class DoctorEducation {
  final int? id;
  final int? doctorId;
  final String degree;
  final String institute;
  final String year;
  final String country;

  const DoctorEducation({
    this.id,
    this.doctorId,
    required this.degree,
    required this.institute,
    required this.year,
    required this.country,
  });

  factory DoctorEducation.fromJson(Map<String, dynamic> json) {
    return DoctorEducation(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      doctorId: json['doctor_id'] is int
          ? json['doctor_id'] as int
          : int.tryParse(json['doctor_id']?.toString() ?? ''),
      degree: json['degree']?.toString() ?? '',
      institute: json['institute']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctorId,
        'degree': degree,
        'institute': institute,
        'year': year,
        'country': country,
      };
}

class DoctorExperience {
  final int? id;
  final int? doctorId;
  final String hospitalName;
  final String position;
  final String fromYear;
  final String toYear;
  final String? description;

  const DoctorExperience({
    this.id,
    this.doctorId,
    required this.hospitalName,
    required this.position,
    required this.fromYear,
    required this.toYear,
    this.description,
  });

  factory DoctorExperience.fromJson(Map<String, dynamic> json) {
    return DoctorExperience(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      doctorId: json['doctor_id'] is int
          ? json['doctor_id'] as int
          : int.tryParse(json['doctor_id']?.toString() ?? ''),
      hospitalName: json['hospital_name']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
      fromYear: json['from_year']?.toString() ?? '',
      toYear: json['to_year']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctorId,
        'hospital_name': hospitalName,
        'position': position,
        'from_year': fromYear,
        'to_year': toYear,
        'description': description,
      };
}

class DoctorSocial {
  final String? facebook;
  final String? linkedin;
  final String? youtube;

  const DoctorSocial({
    this.facebook,
    this.linkedin,
    this.youtube,
  });

  factory DoctorSocial.fromJson(Map<String, dynamic> json) {
    return DoctorSocial(
      facebook: json['facebook']?.toString(),
      linkedin: json['linkedin']?.toString(),
      youtube: json['youtube']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'facebook': facebook,
        'linkedin': linkedin,
        'youtube': youtube,
      };
}

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
  final String designation;

  // Rich API Fields
  final String? uuid;
  final String? firstName;
  final String? lastName;
  final bool? status;
  final bool? isActive;
  final String? gender;
  final String? dob;
  final int? experienceYears;
  final bool? featured;
  final String? profileImage;
  final int? reviewCount;
  final List<int>? ratingDistribution;
  final List<DoctorEducation> educations;
  final List<DoctorExperience> experiences;
  final DoctorSocial? social;
  final List<dynamic>? doctorReviews;

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
    this.designation = '',
    this.uuid,
    this.firstName,
    this.lastName,
    this.status,
    this.isActive,
    this.gender,
    this.dob,
    this.experienceYears,
    this.featured,
    this.profileImage,
    this.reviewCount,
    this.ratingDistribution,
    this.educations = const [],
    this.experiences = const [],
    this.social,
    this.doctorReviews,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    final firstName = json['FirstName']?.toString() ?? json['first_name']?.toString() ?? '';
    final lastName = json['LastName']?.toString() ?? json['last_name']?.toString() ?? '';
    final nameFromParts = '$firstName $lastName'.trim();
    final rawName = json['name']?.toString() ?? (nameFromParts.isNotEmpty ? nameFromParts : '');

    final expYears = json['experience_years'] is int
        ? json['experience_years'] as int
        : int.tryParse(json['experience_years']?.toString() ?? '');

    final educationsRaw = json['educations'];
    final educations = educationsRaw is List
        ? educationsRaw
            .whereType<Map<String, dynamic>>()
            .map((e) => DoctorEducation.fromJson(e))
            .toList()
        : <DoctorEducation>[];

    final experiencesRaw = json['experiences'];
    final experiences = experiencesRaw is List
        ? experiencesRaw
            .whereType<Map<String, dynamic>>()
            .map((e) => DoctorExperience.fromJson(e))
            .toList()
        : <DoctorExperience>[];

    final ratingDistRaw = json['rating_distribution'];
    List<int>? ratingDistribution;
    if (ratingDistRaw is List) {
      ratingDistribution = ratingDistRaw
          .map((e) => (e is num) ? e.toInt() : int.tryParse(e.toString()) ?? 0)
          .toList();
    } else if (ratingDistRaw is Map) {
      ratingDistribution = ratingDistRaw.values
          .map((e) => (e is num) ? e.toInt() : int.tryParse(e.toString()) ?? 0)
          .toList();
    }

    final numAvgRating = (json['average_rating'] as num?)?.toDouble() ??
        (json['rating'] as num?)?.toDouble() ??
        0.0;

    final numReviews = (json['review_count'] as num?)?.toInt() ??
        (json['reviews_count'] as num?)?.toInt() ??
        0;

    final qual = json['qualification']?.toString() ?? '';
    final spec = json['specialization']?.toString() ?? '';
    final hosp = json['working_institute']?.toString() ?? json['hospital']?.toString() ?? '';
    final desig = json['designation']?.toString() ?? '';

    return DoctorProfile(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString(),
      name: rawName,
      firstName: firstName.isNotEmpty ? firstName : null,
      lastName: lastName.isNotEmpty ? lastName : null,
      email: json['email']?.toString() ?? '',
      phone: json['mobile']?.toString() ?? json['phone']?.toString() ?? '',
      regNo: json['registration_no']?.toString() ?? json['regNo']?.toString() ?? '',
      qualification: qual,
      specialization: spec,
      hospital: hosp,
      designation: desig,
      experienceYears: expYears,
      experience: expYears != null
          ? '$expYears Years'
          : (json['experience']?.toString() ?? ''),
      bio: json['bio']?.toString() ?? '',
      rating: numAvgRating,
      reviewCount: numReviews,
      totalPatients: (json['totalPatients'] as num?)?.toInt() ?? 0,
      status: json['status'] == true ||
          json['status'] == 'active' ||
          json['status'] == 'true' ||
          json['status'] == 1,
      isActive: json['isActive'] == true ||
          json['isActive'] == 'true' ||
          json['isActive'] == 1,
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      featured: json['featured'] == true || json['featured'] == 1,
      profileImage: json['profile_image']?.toString() ?? json['profile_image_url']?.toString(),
      educations: educations,
      experiences: experiences,
      social: json['social'] is Map<String, dynamic>
          ? DoctorSocial.fromJson(json['social'] as Map<String, dynamic>)
          : null,
      ratingDistribution: ratingDistribution,
      doctorReviews: json['doctorreviews'] is List ? json['doctorreviews'] as List : null,
    );
  }

  DoctorProfile copyWith({
    String? id,
    String? name,
    String? qualification,
    String? specialization,
    String? regNo,
    String? hospital,
    String? experience,
    double? rating,
    int? totalPatients,
    String? phone,
    String? email,
    String? bio,
    String? uuid,
    String? firstName,
    String? lastName,
    bool? status,
    bool? isActive,
    String? gender,
    String? dob,
    String? designation,
    int? experienceYears,
    bool? featured,
    String? profileImage,
    int? reviewCount,
    List<int>? ratingDistribution,
    List<DoctorEducation>? educations,
    List<DoctorExperience>? experiences,
    DoctorSocial? social,
    List<dynamic>? doctorReviews,
  }) {
    return DoctorProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      qualification: qualification ?? this.qualification,
      specialization: specialization ?? this.specialization,
      regNo: regNo ?? this.regNo,
      hospital: hospital ?? this.hospital,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
      totalPatients: totalPatients ?? this.totalPatients,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      designation: designation ?? this.designation,
      experienceYears: experienceYears ?? this.experienceYears,
      featured: featured ?? this.featured,
      profileImage: profileImage ?? this.profileImage,
      reviewCount: reviewCount ?? this.reviewCount,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
      educations: educations ?? this.educations,
      experiences: experiences ?? this.experiences,
      social: social ?? this.social,
      doctorReviews: doctorReviews ?? this.doctorReviews,
    );
  }
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
