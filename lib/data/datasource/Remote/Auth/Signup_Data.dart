import 'package:silaaty_desktop/LinkApi.dart';
import 'package:silaaty_desktop/core/class/Crud.dart';

class SignupData {
  Crud crud;
  SignupData(this.crud);

  postdata(String username, String password, String email, String phone,
      String confermPassword, String hallname) async {
    var response = await crud.postData(Applink.linkSignup, {
      "name": username,
      "password": password,
      "password_confirmation": confermPassword,
      'family_name': hallname, // mapping hallname to family_name as per previous API
      "email": email,
      "phone_number": phone,
    });
    return response.fold((l) => l, (r) => r);
  }
}
