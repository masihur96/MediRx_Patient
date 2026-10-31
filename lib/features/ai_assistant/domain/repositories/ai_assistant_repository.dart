import '../../../../core/utils/result.dart';

abstract class AiAssistantRepository {
  Future<Result<String>> chat(String message);
}
