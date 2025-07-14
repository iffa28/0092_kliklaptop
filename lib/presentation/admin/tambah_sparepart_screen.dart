import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahSparepartScreen extends StatefulWidget {
  final int serviceByAdminId;

  const TambahSparepartScreen({super.key, required this.serviceByAdminId});

  @override
  State<TambahSparepartScreen> createState() => _TambahSparepartScreenState();
}

class _TambahSparepartScreenState extends State<TambahSparepartScreen> {
  List<Map<String, dynamic>> sparepartList = [];
  List<int?> selectedSpareparts = [null];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSpareparts();
  }

  Future<void> fetchSpareparts() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/spareparts'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        setState(() {
          sparepartList = data.cast<Map<String, dynamic>>();
        });
      } else {
        debugPrint("❌ Gagal load sparepart: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('❌ Error fetch spareparts: $e');
    }
  }

  void addSparepartField() {
    setState(() {
      selectedSpareparts.add(null);
    });
  }

  void removeSparepartField(int index) {
    setState(() {
      selectedSpareparts.removeAt(index);
    });
  }

  Future<void> submit() async {
    final isValid = selectedSpareparts.every((id) => id != null);
    if (!isValid || selectedSpareparts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Semua pilihan harus diisi.")),
      );
      return;
    }

    final List<Map<String, dynamic>> payload = selectedSpareparts.map((id) {
      return {
        "service_by_admin_id": widget.serviceByAdminId,
        "sparepart_id": id,
      };
    }).toList();

    debugPrint("➡️ Payload: ${jsonEncode(payload)}");

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/service-spareparts/bulk'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      setState(() => isLoading = false);

      final decoded = jsonDecode(response.body);
      debugPrint("⬅️ Response: ${response.statusCode} => $decoded");

      if (response.statusCode == 200) {
        final failedItems = decoded['failed_items'] as List;
        final successCount = decoded['success_count'];

        if (failedItems.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Semua sparepart berhasil ditambahkan")),
          );
          Navigator.pop(context);
        } else {
          String failedMessages = failedItems
              .map((f) => "Baris ${f['index'] + 1}: ${f['errors'].join(', ')}")
              .join('\n');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ $successCount tersimpan.\n❌ Beberapa gagal:\n$failedMessages"),
              duration: const Duration(seconds: 6),
            ),
          );
        }
      } else {
        final msg = decoded['message'] ?? 'Gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ $msg")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("❌ Submit Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Sparepart"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: sparepartList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Pilih Sparepart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedSpareparts.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: selectedSpareparts[index],
                                items: sparepartList.map((sparepart) {
                                  return DropdownMenuItem<int>(
                                    value: sparepart['id'],
                                    child: Text(
                                      "${sparepart['nama_sparepart']} - Rp${sparepart['harga_satuan']}",
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSpareparts[index] = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (selectedSpareparts.length > 1)
                              IconButton(
                                onPressed: () => removeSparepartField(index),
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: addSparepartField,
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Sparepart"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : submit,
                    icon: const Icon(Icons.save),
                    label: Text(isLoading ? "Menyimpan..." : "Simpan Semua"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F509A),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
