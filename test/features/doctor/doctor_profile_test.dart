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

    test('correctly parses populated Doctor 7 API payload with educations and experiences', () {
      final json7 = {
        "id": 1,
        "uuid": "99726127-67ee-4fae-9159-c8e9ead00f9f",
        "name": "Ayesha Rahman",
        "FirstName": "Ayesha",
        "LastName": "Rahman",
        "email": "cardiologist@demo.com",
        "status": true,
        "mobile": "+8801712000001",
        "isActive": true,
        "registration_no": "BMDC-4471",
        "gender": "female",
        "dob": "1984-03-12",
        "specialization": "Cardiology",
        "working_institute": "National Institute of Cardiovascular Diseases",
        "designation": "Consultant Cardiologist",
        "qualification": "MBBS, FCPS (Medicine), MD (Cardiology)",
        "experience_years": 14,
        "bio": "Interventional cardiologist with 14 years of experience.",
        "social": {
          "facebook": "fb.com/dr.ayesha",
          "linkedin": "linkedin.com/in/ayesha",
          "youtube": null
        },
        "featured": true,
        "educations": [
          {
            "id": 12,
            "doctor_id": 1,
            "degree": "MBBS",
            "institute": "Dhaka Medical College",
            "year": "2006",
            "country": "Bangladesh"
          },
          {
            "id": 13,
            "doctor_id": 1,
            "degree": "FCPS (Medicine)",
            "institute": "BCPS",
            "year": "2011",
            "country": "Bangladesh"
          }
        ],
        "experiences": [
          {
            "id": 9,
            "doctor_id": 1,
            "hospital_name": "National Institute of Cardiovascular Diseases",
            "position": "Consultant Cardiologist",
            "from_year": "2015",
            "to_year": "Present",
            "description": "Leading interventional cardiology unit."
          }
        ],
        "profile_image": "https://medirx.unipexel.org/uploads/ayesha.jpg",
        "average_rating": 4.9,
        "review_count": 28,
        "rating_distribution": [0, 0, 1, 5, 22]
      };

      final profile = DoctorProfile.fromJson(json7);

      expect(profile.id, '1');
      expect(profile.name, 'Ayesha Rahman');
      expect(profile.specialization, 'Cardiology');
      expect(profile.designation, 'Consultant Cardiologist');
      expect(profile.hospital, 'National Institute of Cardiovascular Diseases');
      expect(profile.qualification, 'MBBS, FCPS (Medicine), MD (Cardiology)');
      expect(profile.regNo, 'BMDC-4471');
      expect(profile.experienceYears, 14);
      expect(profile.experience, '14 Years');
      expect(profile.rating, 4.9);
      expect(profile.reviewCount, 28);
      expect(profile.profileImage, 'https://medirx.unipexel.org/uploads/ayesha.jpg');
      expect(profile.educations.length, 2);
      expect(profile.educations[0].degree, 'MBBS');
      expect(profile.educations[0].institute, 'Dhaka Medical College');
      expect(profile.experiences.length, 1);
      expect(profile.experiences[0].hospitalName, 'National Institute of Cardiovascular Diseases');
      expect(profile.experiences[0].position, 'Consultant Cardiologist');
      expect(profile.experiences[0].fromYear, '2015');
      expect(profile.experiences[0].toYear, 'Present');
      expect(profile.social?.facebook, 'fb.com/dr.ayesha');
      expect(profile.social?.linkedin, 'linkedin.com/in/ayesha');
    });
  });

  group('DoctorProfileViewModel', () {
    test('fetches doctor profile successfully', () async {
      final mockRepo = MockDoctorRepository();
      mockRepo.profileToReturn = const DoctorProfile(
        id: '14',
        name: 'Haydar Ali',
        qualification: 'MBBS',
        specialization: 'General Medicine',
        regNo: 'AC-54254',
        hospital: 'City Clinic',
        experience: '5 Years',
        rating: 4.8,
        totalPatients: 100,
        phone: '01756483925',
        email: 'haydar@gmail.com',
        bio: 'Experienced physician',
      );

      final viewModel = DoctorProfileViewModel(mockRepo);
      expect(viewModel.isLoading, false);
      expect(viewModel.doctorProfile, isNull);

      await viewModel.fetchDoctorProfile(doctorId: '38');

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.doctorProfile?.name, 'Haydar Ali');
      expect(viewModel.doctorProfile?.regNo, 'AC-54254');
    });

    test('handles failure when repository returns error', () async {
      final mockRepo = MockDoctorRepository();
      mockRepo.errorToReturn = 'Network error occurred';

      final viewModel = DoctorProfileViewModel(mockRepo);
      await viewModel.fetchDoctorProfile(doctorId: '999');

      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'Network error occurred');
      expect(viewModel.doctorProfile, isNull);
    });
  });
}
