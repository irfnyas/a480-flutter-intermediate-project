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
      if (context.mounted) navToLogin(context, result.message ?? '');
      return;
    } on Exception catch (e) {
      final message = '$e'.replaceFirst('Exception: ', '');
      if (context.mounted) showErrorSnackbar(context, message);
    }

    if (context.mounted) closeDialog(context);
  }

  void navToLogin(BuildContext context, String message) {
    context.go(RouteEnum.login.name);
    showSnackbar(context, message);
  }

  void formClear() {
    nameController.clear();
    userController.clear();
    passController.clear();
  }
}
