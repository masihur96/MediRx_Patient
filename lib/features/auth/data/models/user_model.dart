import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
    super.profileImage,
    super.dateOfBirth,
    super.gender,
    super.bloodGroup,
    super.uuid,
    super.status,
    super.createdAt,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['FirstName'] ?? json['first_name'] ?? '';
    final lastName = json['LastName'] ?? json['last_name'] ?? '';
    final nameFromParts = '$firstName $lastName'.trim();

    String? role;
    if (json['role'] != null && json['role'].toString().isNotEmpty) {
      role = json['role'].toString();
    } else if (json['isDoctor'] == true) {
      role = 'Doctor';
    } else if (json['isPatient'] == false) {
      // Backend returns isPatient: false for doctor accounts
      role = 'Doctor';
    } else if (json['isPatient'] == true) {
      role = 'Patient';
    } else if (json['registration_type'] != null &&
        json['registration_type'].toString().isNotEmpty) {
      role = json['registration_type'].toString();
    } else if (json['registrationType'] != null &&
        json['registrationType'].toString().isNotEmpty) {
      role = json['registrationType'].toString();
    } else if (json['bmdc_number'] != null &&
        json['bmdc_number'].toString().isNotEmpty) {
      role = 'Doctor';
    } else if (json['user_type'] != null) {
      role = json['user_type'].toString();
    } else if (json['type'] != null) {
      role = json['type'].toString();
    }

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      fullName: json['name'] ??
          json['fullName'] ??
          (nameFromParts.isNotEmpty ? nameFromParts : ''),
      email: json['email'] ?? '',
      phone: json['mobile'] ?? json['phone'],
      profileImage: json['profile_image_url'] ??
          json['profile_image'] ??
          json['profileImage'] ??
          json['avatar'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      uuid: json['uuid']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'uuid': uuid,
      'status': status,
      'createdAt': createdAt,
      'role': role,
      'isDoctor': isDoctor,
      'isPatient': isPatient,
    };
  }
}
