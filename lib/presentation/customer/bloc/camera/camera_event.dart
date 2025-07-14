part of 'camera_bloc.dart';

sealed class CameraEvent {}

class TakePhotoFromCamera extends CameraEvent {}

class PickPhotoFromGallery extends CameraEvent {}

class ClearCameraImage extends CameraEvent {}
