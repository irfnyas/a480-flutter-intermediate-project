import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/service/api_service.dart';
import '../../util/modal.dart';
import '../../util/route.dart';
import '../../util/view_result_state.dart';
import '../home/provider.dart';

class PostProvider extends ChangeNotifier {
  PostProvider(this.apiService);

  final ApiService apiService;

  ViewResultState _resultState = ViewNoneState();
  ViewResultState get resultState => _resultState;
  set resultState(ViewResultState value) {
    _resultState = value;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  final descController = TextEditingController();
  XFile? imageFile;

  Future<void> upload(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    try {
      showProgressDialog(context);
      final fileName = imageFile?.name ?? '';
      final fileBytes = await imageFile?.readAsBytes() ?? Uint8List(0);

      final result = await apiService.postStory(
        descController.text,
        fileName,
        fileBytes,
      );

      if (result.error == true) throw Exception(result.message);
      if (!context.mounted) return;
      closeDialog(context);
      navToHome(context);
      showSnackbar(context, result.message ?? '');
      formClear();
    } on Exception catch (e) {
      final message = '$e'.replaceFirst('Exception: ', '');
      if (!context.mounted) return;
      closeDialog(context);
      showErrorSnackbar(context, message);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file == null) return;

    imageFile = file;
    notifyListeners();
  }

  void navToHome(BuildContext context) {
    context.go(RouteEnum.home.name);
    context.read<HomeProvider>().fetchData(init: true);
  }

  void formClear() {
    imageFile = null;
    descController.clear();
  }
}
