import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/api_response_model.dart';
import '../../data/service/api_service.dart';
import '../../data/service/cache_service.dart';
import '../../util/modal.dart';
import '../../util/route.dart';
import '../../util/view_result_state.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider(this.apiService, this.cacheService);

  final ApiService apiService;
  final CacheService cacheService;

  ViewResultState _resultState = ViewNoneState();
  ViewResultState get resultState => _resultState;
  set resultState(ViewResultState value) {
    _resultState = value;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    try {
      showProgressDialog(context);
      final result = await apiService.login(
        userController.text,
        passController.text,
      );

      if (result.error == true) throw Exception(result.message);
      await saveLoginResult(result);
      if (context.mounted) navToHome(context);
    } on Exception catch (e) {
      final message = '$e'.replaceFirst('Exception: ', '');
      if (context.mounted) showErrorSnackbar(context, message);
    }

    if (context.mounted) closeDialog(context);
  }

  void navToRegister(BuildContext context) {
    context.push(RouteEnum.register.name);
  }

  Future<void> saveLoginResult(ApiResponse result) async {
    await cacheService.setString(
      CacheService.kCacheUserId,
      result.loginResult?.userId ?? '',
    );
    await cacheService.setString(
      CacheService.kCacheName,
      result.loginResult?.name ?? '',
    );
    await cacheService.setString(
      CacheService.kCacheToken,
      result.loginResult?.token ?? '',
    );
  }

  void navToHome(BuildContext context) {
    context.go(RouteEnum.home.name);
  }
}
