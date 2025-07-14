import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/data/model/response/product_response_model.dart';
import 'package:kliklaptop/presentation/admin/bloc/product/product_bloc.dart';
import 'package:kliklaptop/presentation/customer/bloc/camera/camera_bloc.dart';

class InsertProductScreen extends StatefulWidget {
  const InsertProductScreen({super.key});

  @override
  State<InsertProductScreen> createState() => _InsertProductScreenState();
}

class _InsertProductScreenState extends State<InsertProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaProdukController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      final cameraState = context.read<CameraBloc>().state;
      File? selectedPhoto;
      if (cameraState is CameraImagePicked) {
        selectedPhoto = cameraState.imageFile;
      }

      final dataProduk = Data(
        namaProduk: _namaProdukController.text,
        deskripsi: _deskripsiController.text,
        harga: int.tryParse(_hargaController.text),
        stok: int.tryParse(_stokController.text),
      );

      context.read<ProductBloc>().add(
        ProductRequested(
          dataProduk: dataProduk,
          fotoProduk: selectedPhoto,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Produk berhasil ditambahkan")),
            );
            Navigator.pop(context, true); // ✅ Memberi sinyal ke halaman sebelumnya
            context.read<CameraBloc>().add(ClearCameraImage());
          } else if (state is ProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaProdukController,
                    decoration: const InputDecoration(labelText: "Nama Produk"),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(labelText: "Harga"),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _stokController,
                    decoration: const InputDecoration(labelText: "Stok"),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CameraBloc, CameraState>(
                    builder: (context, state) {
                      File? imageFile;

                      if (state is CameraImagePicked) {
                        imageFile = state.imageFile;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Foto Produk (opsional)",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<CameraBloc>()
                                      .add(TakePhotoFromCamera());
                                },
                                icon: const Icon(Icons.camera_alt),
                                label: const Text("Kamera"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<CameraBloc>()
                                      .add(PickPhotoFromGallery());
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
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () => context
                                        .read<CameraBloc>()
                                        .add(ClearCameraImage()),
                                  ),
                                )
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F509A),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Simpan Produk"),
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
