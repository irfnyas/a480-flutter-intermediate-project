import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
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

  bool _withLocation = false;
  bool get withLocation => _withLocation;
  set withLocation(bool value) {
    _withLocation = value;
    notifyListeners();
  }

  String? locationName;
  String? locationAddress;
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  set latLng(LatLng? value) {
    _latLng = value;
    notifyListeners();
  }

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
        lat: latLng?.latitude.toDouble(),
        lon: latLng?.longitude.toDouble(),
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
    withLocation = false;
    latLng = null;
    locationName = null;
    locationAddress = null;
  }

  void switchLocationStatus(BuildContext context) {
    withLocation = !withLocation;
    if (!withLocation) latLng = null;
    if (withLocation && latLng == null) getMyLocation(context);
  }

  Future<void> getMyLocation(BuildContext context) async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (context.mounted) showLocationErrorSnackbar(context);
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (context.mounted) showLocationErrorSnackbar(context);
        return;
      }
    }

    locationData = await location.getLocation();

    final reverseResult = await apiService.reverseGeo(
      locationData.latitude ?? 0.0,
      locationData.longitude ?? 0.0,
    );
    locationName = reverseResult.name != null && reverseResult.name != ''
        ? reverseResult.name
        : null;
    locationAddress =
        reverseResult.displayName != null && reverseResult.displayName != ''
            ? reverseResult.displayName
            : null;
    latLng = LatLng(
      locationData.latitude ?? 0.0,
      locationData.longitude ?? 0.0,
    );
  }

  void showLocationErrorSnackbar(BuildContext context) {
    showErrorSnackbar(
      context,
      'Location services is not available',
    );
    withLocation = false;
  }
}
