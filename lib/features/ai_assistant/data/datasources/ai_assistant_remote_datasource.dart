import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class AiAssistantRemoteDataSource {
  Future<Map<String, dynamic>> chat(String message);
}

class AiAssistantRemoteDataSourceImpl implements AiAssistantRemoteDataSource {
  final DataProvider _dataProvider;

  AiAssistantRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<Map<String, dynamic>> chat(String message) async {
    final response = await _dataProvider.post(
      APIPath.aiAssistantChat,
      data: {'message': message},
    );
    return response.data as Map<String, dynamic>;
  }
}
