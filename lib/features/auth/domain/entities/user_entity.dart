/// Domain User Entity representing an authenticated MediRx Patient
class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? uuid;
  final String? status;
  final String? createdAt;
  final String? role;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.uuid,
    this.status,
    this.createdAt,
    this.role,
  });

  bool get isDoctor {
    final r = (role ?? '').toLowerCase().trim();
    return r == 'doctor' || r.contains('doctor');
  }

  bool get isPatient => !isDoctor;
}
