import 'package:flutter/material.dart';

// Blood group enum
enum BloodGroup { aPos, aNeg, bPos, bNeg, abPos, abNeg, oPos, oNeg }

extension BloodGroupExtension on BloodGroup {
  String get label {
    switch (this) {
      case BloodGroup.aPos: return 'A+';
      case BloodGroup.aNeg: return 'A-';
      case BloodGroup.bPos: return 'B+';
      case BloodGroup.bNeg: return 'B-';
      case BloodGroup.abPos: return 'AB+';
      case BloodGroup.abNeg: return 'AB-';
      case BloodGroup.oPos: return 'O+';
      case BloodGroup.oNeg: return 'O-';
    }
  }

  Color get color {
    switch (this) {
      case BloodGroup.aPos:
      case BloodGroup.aNeg: return const Color(0xFFE53935);
      case BloodGroup.bPos:
      case BloodGroup.bNeg: return const Color(0xFF1E88E5);
      case BloodGroup.abPos:
      case BloodGroup.abNeg: return const Color(0xFF8E24AA);
      case BloodGroup.oPos:
      case BloodGroup.oNeg: return const Color(0xFF43A047);
    }
  }
}

// Availability level
enum StockLevel { critical, low, moderate, high }

extension StockLevelExtension on StockLevel {
  String get label {
    switch (this) {
      case StockLevel.critical: return 'Critical';
      case StockLevel.low: return 'Low';
      case StockLevel.moderate: return 'Moderate';
      case StockLevel.high: return 'Available';
    }
  }

  Color get color {
    switch (this) {
      case StockLevel.critical: return const Color(0xFFE53935);
      case StockLevel.low: return const Color(0xFFFF7043);
      case StockLevel.moderate: return const Color(0xFFFFA000);
      case StockLevel.high: return const Color(0xFF43A047);
    }
  }
}

// Blood availability entry inside a blood bank
class BloodAvailability {
  final BloodGroup group;
  final int units;
  final StockLevel level;

  const BloodAvailability({
    required this.group,
    required this.units,
    required this.level,
  });
}

// Blood Bank / Hospital
class BloodBank {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final double lat;
  final double lng;
  final double distanceKm;
  final bool isOpen24h;
  final List<BloodAvailability> availability;

  const BloodBank({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.isOpen24h,
    required this.availability,
  });

  bool hasGroup(BloodGroup group) =>
      availability.any((a) => a.group == group);

  StockLevel? stockFor(BloodGroup group) =>
      availability.where((a) => a.group == group).isNotEmpty
          ? availability.firstWhere((a) => a.group == group).level
          : null;
}

// Donor profile (embedded in user profile)
class DonorProfile {
  final String userId;
  final String name;
  final String phone;
  final BloodGroup bloodGroup;
  final DateTime lastDonationDate;
  final bool isAvailable;
  final String city;
  final double lat;
  final double lng;
  final int totalDonations;

  const DonorProfile({
    required this.userId,
    required this.name,
    required this.phone,
    required this.bloodGroup,
    required this.lastDonationDate,
    required this.isAvailable,
    required this.city,
    required this.lat,
    required this.lng,
    required this.totalDonations,
  });

  // Can donate again (90-day rule)
  bool get canDonateNow =>
      DateTime.now().difference(lastDonationDate).inDays >= 90;

  String get lastDonationLabel {
    final days = DateTime.now().difference(lastDonationDate).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 30) return '$days days ago';
    final months = (days / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  }

  double get distanceKm => 0.0; // computed at runtime
}

// Emergency blood request
class BloodRequest {
  final String id;
  final String requesterName;
  final String requesterPhone;
  final BloodGroup bloodGroup;
  final int unitsNeeded;
  final String hospital;
  final String city;
  final DateTime requestedAt;
  final bool isUrgent;
  final String note;

  const BloodRequest({
    required this.id,
    required this.requesterName,
    required this.requesterPhone,
    required this.bloodGroup,
    required this.unitsNeeded,
    required this.hospital,
    required this.city,
    required this.requestedAt,
    required this.isUrgent,
    required this.note,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(requestedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
