/// Base UseCase contract
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use when a usecase does not require parameters
class NoParams {
  const NoParams();
}
