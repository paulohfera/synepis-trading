import '../../../../components/alert.dart';
import '../../../../components/navigation_helper.dart';
import '../../../../containers.dart';
import '../../../../core/valueObjects/email_value_object.dart';
import '../../../../route.dart';
import '../../domain/usecases/login.dart';

class LoginPageController {
  String login;
  String password;

  String loginValidation(String value) {
    if (value.isEmpty) return "Informe o e-mail.";
    if (!EmailValueObject(value).isValid()) return "E-mail inválido.";

    return null;
  }

  String passwordValidation(String value) {
    if (value.isEmpty) return "Informe a senha.";

    return null;
  }

  Future<void> submit() async {
    var loginUseCase = sl.get<Login>();
    var result = await loginUseCase(login, password);
    result.fold(
      (l) => {
        Alert.alert("Erro", l.message),
      },
      (r) => {
        sl.get<NavigationHelper>().pushReplacementNamed(tabsRoute),
      },
    );
  }
}
