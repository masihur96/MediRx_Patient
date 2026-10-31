import 'package:flutter_test/flutter_test.dart';
import 'package:medirx_patient/features/auth/domain/usecases/login_usecase.dart';

void main() {
  test('LoginParams holds identifier and password correctly', () {
    const params = LoginParams(
      identifier: 'abusalah01diu@gmail.com',
      password: '12345678',
    );

    expect(params.identifier, 'abusalah01diu@gmail.com');
    expect(params.email, 'abusalah01diu@gmail.com');
    expect(params.password, '12345678');
  });
}
