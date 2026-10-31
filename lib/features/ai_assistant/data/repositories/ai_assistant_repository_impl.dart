import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../datasources/ai_assistant_remote_datasource.dart';

class AiAssistantRepositoryImpl implements AiAssistantRepository {
  final AiAssistantRemoteDataSource _remoteDataSource;

  AiAssistantRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<String>> chat(String message) async {
    try {
      final data = await _remoteDataSource.chat(message);
      // Extract reply from various possible response shapes
      String reply = '';
      if (data['data'] is Map) {
        final d = data['data'] as Map;
        reply = d['reply']?.toString() ??
            d['message']?.toString() ??
            d['response']?.toString() ??
            '';
      } else if (data['data'] is String) {
        reply = data['data'] as String;
      } else {
        reply = data['message']?.toString() ?? '';
      }
      if (reply.isEmpty) {
        return Error('Empty response from AI assistant');
      }
      return Success(reply);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
