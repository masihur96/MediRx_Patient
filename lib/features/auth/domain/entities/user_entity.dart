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

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
  });
}
