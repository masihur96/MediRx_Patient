import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../data/doctor_models.dart';
import '../repositories/doctor_repository.dart';

class GetDoctorsParams {
  final String? specialty;
  const GetDoctorsParams({this.specialty});
}

class GetDoctorsUseCase implements UseCase<Result<List<DoctorProfile>>, GetDoctorsParams> {
  final DoctorRepository _repository;

  GetDoctorsUseCase(this._repository);

  @override
  Future<Result<List<DoctorProfile>>> call(GetDoctorsParams params) {
    return _repository.getDoctors(specialty: params.specialty);
  }
}
