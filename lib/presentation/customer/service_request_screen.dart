import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/camera/camera_bloc.dart';
import 'package:kliklaptop/presentation/customer/bloc/servicer_request/service_request_bloc.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jenisLaptopController = TextEditingController();
  final _keluhanController = TextEditingController();

  @override
  void dispose() {
    _jenisLaptopController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cameraState = context.read<CameraBloc>().state;
      File? selectedPhoto;

      if (cameraState is CameraImagePicked) {
        selectedPhoto = cameraState.imageFile;
      }

      final dataService = Data(
        jenisLaptop: _jenisLaptopController.text,
        deskripsiKeluhan: _keluhanController.text,
        // Photo & status akan diproses di repository
      );

      context.read<ServiceRequestBloc>().add(
            ServiceRequestRequested(
              dataService: dataService,
              photo: selectedPhoto,
            ),
          );

      context.read<CameraBloc>().add(ClearCameraImage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permintaan Service"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Permintaan berhasil dikirim")),
            );
            Navigator.pop(context);
          } else if (state is ServiceRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ServiceRequestLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Jenis Laptop
                  TextFormField(
                    controller: _jenisLaptopController,
                    decoration: InputDecoration(
                      labelText: "Jenis Laptop",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Jenis laptop harus diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi Keluhan
                  TextFormField(
                    controller: _keluhanController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Deskripsi Keluhan",
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Keluhan harus diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // Upload Foto
                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, state) {
                      File? imageFile;
                      if (state is CameraImagePicked) {
                        imageFile = state.imageFile;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Upload Foto (opsional)",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<CameraBloc>().add(TakePhotoFromCamera());
                                },
                                icon: const Icon(Icons.camera_alt),
                                label: const Text("Kamera"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<CameraBloc>().add(PickPhotoFromGallery());
                                },
                                icon: const Icon(Icons.photo_library),
                                label: const Text("Galeri"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (imageFile != null)
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    imageFile,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      context.read<CameraBloc>().add(ClearCameraImage());
                                    },
                                  ),
                                )
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F509A),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Kirim Permintaan",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
