import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/presentation/admin/bloc/servicebyadmin/servicebyadmin_bloc.dart';
import 'package:kliklaptop/presentation/customer/bloc/camera/camera_bloc.dart';

class PembayaranServiceAdmin extends StatefulWidget {
  final int serviceId;

  const PembayaranServiceAdmin({super.key, required this.serviceId});

  @override
  State<PembayaranServiceAdmin> createState() => _PembayaranServiceAdminState();
}

class _PembayaranServiceAdminState extends State<PembayaranServiceAdmin> {
  bool _isSubmitting = false;

  void _submitPembayaran(File? bukti) {
    if (bukti == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Silakan pilih bukti pembayaran terlebih dahulu')),
      );
      return;
    }

    final ext = bukti.path.split('.').last.toLowerCase();
    if (!(ext == 'jpg' || ext == 'jpeg' || ext == 'png')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Format tidak didukung. Gunakan JPG, JPEG, atau PNG')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    context.read<ServicebyadminBloc>().add(
      UpdatePembayaranServiceByAdmin(
        serviceId: widget.serviceId,
        buktiPembayaran: bukti,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicebyadminBloc, ServiceByAdminState>(
      listener: (context, state) {
        if (state is UpdatePembayaranSuccess && _isSubmitting) {
          setState(() => _isSubmitting = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Bukti pembayaran berhasil dikirim')),
          );

          context.read<CameraBloc>().add(ClearCameraImage());
          Navigator.pop(context);
        } else if (state is ServiceByAdminFailure) {
          setState(() => _isSubmitting = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ ${state.error}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Bukti Pembayaran"),
          backgroundColor: const Color(0xff1F509A),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              File? imageFile;
              if (state is CameraImagePicked) {
                imageFile = state.imageFile;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Unggah Bukti Pembayaran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<CameraBloc>().add(TakePhotoFromCamera()),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Kamera"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<CameraBloc>().add(PickPhotoFromGallery()),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Galeri"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                            onPressed: () =>
                                context.read<CameraBloc>().add(ClearCameraImage()),
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () => _submitPembayaran(imageFile),
                    icon: const Icon(Icons.send),
                    label: _isSubmitting
                        ? const Text("Mengirim...")
                        : const Text("Kirim Bukti Pembayaran"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F509A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
