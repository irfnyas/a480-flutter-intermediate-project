import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/service/api_service.dart';
import '../../util/modal.dart';
import '../../util/route.dart';
import '../../util/view_result_state.dart';

class RegisterProvider extends ChangeNotifier {
  RegisterProvider(this.apiService);

  final ApiService apiService;

  ViewResultState _resultState = ViewNoneState();
  ViewResultState get resultState => _resultState;
  set resultState(ViewResultState value) {
    _resultState = value;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    try {
      showProgressDialog(context);
      final result = await apiService.register(
        nameController.text,
        userController.text,
        passController.text,
      );
      if (result.error == true) throw Exception(result.message);
      if (!context.mounted) return;
      closeDialog(context);
      navToLogin(context, result.message ?? '');
      return;
    } on Exception catch (e) {
      final message = '$e'.replaceFirst('Exception: ', '');
      if (!context.mounted) return;
      closeDialog(context);
      showErrorSnackbar(context, message);
    }
  }

  void navToLogin(BuildContext context, String message) {
    showSnackbar(context, message);
    context.go(RouteEnum.login.name);
  }

  void formClear() {
    nameController.clear();
    userController.clear();
    passController.clear();
  }
}
