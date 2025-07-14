import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final ImagePicker _picker = ImagePicker();
  CameraBloc() : super(CameraInitial()) {
    on<TakePhotoFromCamera>(_takePhotoFromCamera);
    on<PickPhotoFromGallery>(_pickFromGallery);
    on<ClearCameraImage>((event, emit) => emit(CameraInitial()));
  }

  Future<void> _takePhotoFromCamera(
    TakePhotoFromCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (file != null) {
        final image = File(file.path);
        final base64 = base64Encode(await image.readAsBytes());
        emit(CameraImagePicked(imageFile: image, base64Image: base64));
      } else {
        emit(CameraInitial());
      }
    } catch (e) {
      emit(CameraError(message: "Gagal membuka kamera: $e"));
    }
  }

  Future<void> _pickFromGallery(
    PickPhotoFromGallery event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        final image = File(file.path);
        final base64 = base64Encode(await image.readAsBytes());
        emit(CameraImagePicked(imageFile: image, base64Image: base64));
      } else {
        emit(CameraInitial());
      }
    } catch (e) {
      emit(CameraError(message: "Gagal memilih gambar: $e"));
    }
  }
}
