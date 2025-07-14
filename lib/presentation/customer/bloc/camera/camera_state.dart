part of 'camera_bloc.dart';

sealed class CameraState {}

final class CameraInitial extends CameraState {}

final class CameraImagePicked extends CameraState {
  final File imageFile;
  final String base64Image;

  CameraImagePicked({required this.imageFile, required this.base64Image});
}

final class CameraError extends CameraState {
  final String message;

  CameraError({required this.message});
}
