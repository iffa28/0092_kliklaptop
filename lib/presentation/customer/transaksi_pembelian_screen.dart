import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:kliklaptop/presentation/customer/bloc/camera/camera_bloc.dart';
import 'package:kliklaptop/presentation/customer/bloc/transaksipembelian/transaksipembelian_bloc.dart';

class TransaksiPembelianScreen extends StatefulWidget {
  final int productId;

  const TransaksiPembelianScreen({super.key, required this.productId});

  @override
  State<TransaksiPembelianScreen> createState() =>
      _TransaksiPembelianScreenState();
}

class _TransaksiPembelianScreenState extends State<TransaksiPembelianScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedMetode;
  File? imageFile;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = Data(
        productId: widget.productId,
        metodePembayaran: selectedMetode,
        status: 'menunggu penjemputan',
      );

      context.read<TransaksiPembelianBloc>().add(
            TransaksiPembelianRequested(
              dataTransaksi: data,
              buktiPembayaran: selectedMetode == 'Transfer' ? imageFile : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff1F509A);
    const Color secondaryColor = Color(0xff81BFDA);
    const Color backgroundColor = Color(0xffF4F6F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Transaksi Pembelian"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child:
                BlocConsumer<TransaksiPembelianBloc, TransaksiPembelianState>(
              listener: (context, state) {
                if (state is TransaksiPembelianSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Transaksi berhasil!")),
                  );
                  Navigator.pop(context);
                } else if (state is TransaksiPembelianFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ ${state.error}")),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is TransaksiPembelianLoading;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Metode Pembayaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedMetode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Transfer",
                            child: Text("Transfer"),
                          ),
                          DropdownMenuItem(
                            value: "Bayar Ditempat",
                            child: Text("Bayar di Tempat"),
                          ),
                        ],
                        validator: (val) =>
                            val == null ? 'Pilih metode pembayaran' : null,
                        onChanged: (val) {
                          setState(() {
                            selectedMetode = val;
                            if (val != "Transfer") {
                              imageFile = null;
                              context.read<CameraBloc>().add(ClearCameraImage());
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Upload Bukti
                      if (selectedMetode == "Transfer")
                        BlocBuilder<CameraBloc, CameraState>(
                          builder: (context, camState) {
                            if (camState is CameraImagePicked &&
                                imageFile?.path != camState.imageFile.path) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  imageFile = camState.imageFile;
                                });
                              });
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Bukti Pembayaran",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          context
                                              .read<CameraBloc>()
                                              .add(TakePhotoFromCamera());
                                        },
                                        icon: const Icon(Icons.camera_alt),
                                        label: const Text("Kamera"),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: primaryColor,
                                          side: const BorderSide(
                                              color: primaryColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          context
                                              .read<CameraBloc>()
                                              .add(PickPhotoFromGallery());
                                        },
                                        icon: const Icon(Icons.photo_library),
                                        label: const Text("Galeri"),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: primaryColor,
                                          side: const BorderSide(
                                              color: primaryColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (imageFile != null)
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          imageFile!,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            context
                                                .read<CameraBloc>()
                                                .add(ClearCameraImage());
                                            setState(() {
                                              imageFile = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                if (selectedMetode == "Transfer" &&
                                    imageFile == null)
                                  const Text(
                                    "* Bukti pembayaran wajib diunggah.",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                              ],
                            );
                          },
                        ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ||
                                  selectedMetode == null ||
                                  (selectedMetode == "Transfer" &&
                                      imageFile == null)
                              ? null
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: primaryColor,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Kirim Transaksi",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
