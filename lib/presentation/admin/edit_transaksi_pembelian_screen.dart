import 'package:flutter/material.dart';

class EditTransaksiPembelianScreen extends StatefulWidget {
  final int transaksiId;
  final String initialStatus;
  final String initialMetode;

  const EditTransaksiPembelianScreen({
    super.key,
    required this.transaksiId,
    required this.initialStatus,
    required this.initialMetode,
  });

  @override
  State<EditTransaksiPembelianScreen> createState() =>
      _EditTransaksiPembelianScreenState();
}

class _EditTransaksiPembelianScreenState
    extends State<EditTransaksiPembelianScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedStatus;
  late String _selectedMetode;

  final List<String> _statusList = [
    'transaksi berhasil',
    'transaksi batal',
    'menunggu penjemputan',
  ];

  final List<String> _metodeList = [
    'Transfer',
    'Bayar Ditempat',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedMetode = widget.initialMetode;
  }

  void _submitEdit() {
    if (_formKey.currentState!.validate()) {
      // Simulasi simpan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Transaksi berhasil diperbarui")),
      );
      Navigator.pop(context); // Kembali ke layar sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaksi"),
        backgroundColor: const Color(0xff1F509A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Status Transaksi",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: _statusList
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedStatus = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              const Text("Metode Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMetode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: _metodeList
                    .map((metode) =>
                        DropdownMenuItem(value: metode, child: Text(metode)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedMetode = val;
                    });
                  }
                },
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1F509A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
