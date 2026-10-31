import 'package:flutter_test/flutter_test.dart';
import 'package:medirx_patient/core/utils/result.dart';
import 'package:medirx_patient/features/doctor/data/doctor_models.dart';
import 'package:medirx_patient/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:medirx_patient/features/doctor/presentation/viewmodels/doctor_profile_viewmodel.dart';

class MockDoctorRepository implements DoctorRepository {
  DoctorProfile? profileToReturn;
  String? errorToReturn;

  @override
  Future<Result<DoctorProfile>> getDoctorDetails(String doctorId, {String? token}) async {
    if (errorToReturn != null) {
      return Error(errorToReturn!);
    }
    return Success(profileToReturn!);
  }

  @override
  Future<Result<List<DoctorProfile>>> getDoctors({String? specialty, String? token}) async {
    return const Success([]);
  }

  @override
  Future<Result<DoctorProfile>> updateDoctorProfile(
    String doctorId,
    Map<String, dynamic> data, {
    String? token,
    String? imagePath,
  }) async {
    if (errorToReturn != null) {
      return Error(errorToReturn!);
    }
    return Success(profileToReturn!);
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getSpecialties({String? token}) async {
    return const Success([
      {
        'label': 'Medicine',
        'options': [
          {'value': 16, 'label': 'Cardiology'},
        ]
      }
    ]);
  }
}

void main() {
  group('DoctorProfile.fromJson', () {
    test('correctly parses Doctor 38 API payload', () {
      final json38 = {
        "id": 14,
        "uuid": "5a3b09c3-ccdf-4c3c-b710-743b9048dbb6",
        "name": "Haydar Ali",
        "FirstName": "Haydar",
        "LastName": "Ali",
        "email": "haydar@gmail.com",
        "status": true,
        "mobile": "01756483925",
        "isActive": true,
        "registration_no": "AC-54254",
        "gender": null,
        "dob": null,
        "specialization": null,
        "working_institute": null,
        "designation": null,
        "qualification": null,
        "experience_years": null,
        "bio": null,
        "social": null,
        "featured": false,
        "educations": [],
        "experiences": [],
        "profile_image": null,
        "doctorreviews": [],
        "average_rating": 0,
        "review_count": 0,
        "rating_distribution": [0, 0, 0, 0, 0]
      };

      final profile = DoctorProfile.fromJson(json38);

      expect(profile.id, '14');
      expect(profile.uuid, '5a3b09c3-ccdf-4c3c-b710-743b9048dbb6');
      expect(profile.name, 'Haydar Ali');
      expect(profile.firstName, 'Haydar');
      expect(profile.lastName, 'Ali');
      expect(profile.email, 'haydar@gmail.com');
      expect(profile.phone, '01756483925');
      expect(profile.regNo, 'AC-54254');
      expect(profile.status, true);
      expect(profile.isActive, true);
      expect(profile.educations, isEmpty);
      expect(profile.experiences, isEmpty);
      expect(profile.rating, 0.0);
      expect(profile.reviewCount, 0);
    });

    test('correctly parses updated Doctor payload with all curl form fields', () {
      final jsonUpdated = {
        "id": 14,
        "uuid": "5a3b09c3-ccdf-4c3c-b710-743b9048dbb6",
        "name": "Haydar Ali",
        "FirstName": "Haydar",
        "LastName": "Ali",
        "email": "haydar@gmail.com",
        "status": true,
        "mobile": "01714774003",
        "isActive": true,
        "registration_no": "A-12345",
        "gender": "male",
        "dob": "1985-05-15",
        "specialization": "Cardiology",
        "working_institute": "Dhaka Medical College Hospital",
        "designation": "Consultant Cardiologist",
        "qualification": "MBBS, FCPS (Medicine), MD (Cardiology)",
        "experience_years": 10,
        "bio": "Experienced cardiologist specializing in cardiovascular diseases.",
        "social": {
          "facebook": "https://facebook.com/doctor",
          "linkedin": "https://linkedin.com/in/doctor",
          "twitter": "https://twitter.com/doctor"
        },
        "featured": false,
        "educations": [],
        "experiences": [],
        "profile_image": null,
        "doctorreviews": [],
        "average_rating": 0,
        "review_count": 0,
        "rating_distribution": [0, 0, 0, 0, 0]
      };

      final profile = DoctorProfile.fromJson(jsonUpdated);

      expect(profile.phone, '01714774003');
      expect(profile.gender, 'male');
      expect(profile.dob, '1985-05-15');
      expect(profile.specialization, 'Cardiology');
      expect(profile.hospital, 'Dhaka Medical College Hospital');
      expect(profile.designation, 'Consultant Cardiologist');
      expect(profile.qualification, 'MBBS, FCPS (Medicine), MD (Cardiology)');
      expect(profile.regNo, 'A-12345');
      expect(profile.experienceYears, 10);
      expect(profile.bio, 'Experienced cardiologist specializing in cardiovascular diseases.');
      expect(profile.social?.facebook, 'https://facebook.com/doctor');
      expect(profile.social?.linkedin, 'https://linkedin.com/in/doctor');
      expect(profile.social?.twitter, 'https://twitter.com/doctor');
    });
  });

  group('DoctorProfileViewModel updateDoctorProfile', () {
    test('updates doctor profile successfully', () async {
      final mockRepo = MockDoctorRepository();
      mockRepo.profileToReturn = const DoctorProfile(
        id: '14',
        name: 'Haydar Ali',
        qualification: 'MBBS, FCPS (Medicine), MD (Cardiology)',
        specialization: 'Cardiology',
        regNo: 'A-12345',
        hospital: 'Dhaka Medical College Hospital',
        experience: '10 Years',
        experienceYears: 10,
        rating: 5.0,
        totalPatients: 100,
        phone: '01714774003',
        email: 'haydar@gmail.com',
        bio: 'Experienced cardiologist',
      );

      final viewModel = DoctorProfileViewModel(mockRepo);

      final success = await viewModel.updateDoctorProfile(
        doctorId: '38',
        data: {
          'phone': '01714774003',
          'gender': 'male',
          'dob': '1985-05-15',
          'specialization': 'Cardiology',
          'working_institute': 'Dhaka Medical College Hospital',
          'designation': 'Consultant Cardiologist',
          'qualification': 'MBBS, FCPS (Medicine), MD (Cardiology)',
          'registration_no': 'A-12345',
          'experience_years': '10',
          'bio': 'Experienced cardiologist specializing in cardiovascular diseases.',
          'specialization_ids': ['50', '48'],
        },
      );

      expect(success, true);
      expect(viewModel.isUpdating, false);
      expect(viewModel.updateErrorMessage, isNull);
      expect(viewModel.doctorProfile?.phone, '01714774003');
      expect(viewModel.doctorProfile?.regNo, 'A-12345');
    });

    test('handles update failure gracefully', () async {
      final mockRepo = MockDoctorRepository();
      mockRepo.errorToReturn = 'Validation error occurred';

      final viewModel = DoctorProfileViewModel(mockRepo);

      final success = await viewModel.updateDoctorProfile(
        doctorId: '38',
        data: {},
      );

      expect(success, false);
      expect(viewModel.isUpdating, false);
      expect(viewModel.updateErrorMessage, 'Validation error occurred');
    });
  });
}
