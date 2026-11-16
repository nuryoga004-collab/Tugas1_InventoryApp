import '../database/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../viewmodels/barang_viewmodel.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  final BarangViewModel _viewModel = BarangViewModel();
  final TextEditingController _searchController =
      TextEditingController();

  static const Color warnaUtama = Color(0xFF153E75);

  @override
  void initState() {
    super.initState();
    _viewModel.loadBarang();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _pesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  Future<void> _tampilkanForm({Barang? barang}) async {
    final formKey = GlobalKey<FormState>();

    final kode = TextEditingController(text: barang?.kode ?? '');
    final nama = TextEditingController(text: barang?.nama ?? '');
    final kategori =
        TextEditingController(text: barang?.kategori ?? '');
    final jumlah =
        TextEditingController(text: barang?.jumlah.toString() ?? '');
    final harga =
        TextEditingController(text: barang?.harga.toString() ?? '');
    final lokasi =
        TextEditingController(text: barang?.lokasi ?? '');

final db = await DatabaseHelper.instance.database;

final dataKategori = await db.query(
  'kategori',
  orderBy: 'nama ASC',
);

final daftarKategori = dataKategori
    .map((item) => item['nama'] as String)
    .toList();

// Mempertahankan kategori lama saat edit barang
if (barang != null &&
    barang.kategori.isNotEmpty &&
    !daftarKategori.contains(barang.kategori)) {
  daftarKategori.add(barang.kategori);
}

if (!mounted) return;

    try {
      final hasil = await showDialog<Barang>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              barang == null ? 'Tambah Barang' : 'Edit Barang',
            ),
            content: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _field(kode, 'Kode Barang'),
                      

_field(nama, 'Nama Barang'),

DropdownButtonFormField<String>(
  initialValue: daftarKategori.contains(kategori.text)
      ? kategori.text
      : null,
  decoration: const InputDecoration(
    labelText: 'Kategori',
    border: OutlineInputBorder(),
  ),
  hint: const Text('Pilih Kategori'),
  items: daftarKategori.map((namaKategori) {
    return DropdownMenuItem<String>(
      value: namaKategori,
      child: Text(namaKategori),
    );
  }).toList(),
  onChanged: (value) {
    kategori.text = value ?? '';
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Kategori wajib dipilih';
    }
    return null;
  },
),

_field(
  jumlah,
  'Jumlah Stok',
  angka: true,
),

_field(
  harga,
  'Harga Barang',
  angka: true,
),

_field(lokasi, 'Lokasi Penyimpanan'),

                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaUtama,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  final jumlahValue = int.tryParse(jumlah.text);
                  final hargaValue =
                      double.tryParse(harga.text.replaceAll(',', '.'));

                  if (jumlahValue == null || hargaValue == null) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    Barang(
                      id: barang?.id,
                      kode: kode.text.trim(),
                      nama: nama.text.trim(),
                      kategori: kategori.text.trim(),
                      jumlah: jumlahValue,
                      harga: hargaValue,
                      lokasi: lokasi.text.trim(),
                      tanggal: barang?.tanggal ??
                          DateTime.now().toIso8601String(),
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );

      if (hasil == null || !mounted) return;

      final berhasil = barang == null
          ? await _viewModel.tambahBarang(hasil)
          : await _viewModel.updateBarang(hasil);

      if (!mounted) return;

      _pesan(
        berhasil
            ? 'Data barang berhasil disimpan'
            : _viewModel.errorMessage,
      );
    } finally {
      kode.dispose();
      nama.dispose();
      kategori.dispose();
      jumlah.dispose();
      harga.dispose();
      lokasi.dispose();
    }
  }

  
Widget _field(
  TextEditingController controller,
  String label, {
  bool angka = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: angka
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label wajib diisi';
        }

        if (angka) {
          if (label == 'Jumlah Stok') {
            final nilai = int.tryParse(value);

            if (nilai == null) {
              return 'Masukkan jumlah yang valid';
            }

            if (nilai < 0) {
              return 'Jumlah tidak boleh negatif';
            }
          } else {
            final nilai = double.tryParse(
              value.replaceAll(',', '.'),
            );

            if (nilai == null) {
              return 'Masukkan angka yang valid';
            }

            if (nilai <= 0) {
              return 'Harga harus lebih besar dari 0';
            }
          }
        }

        return null;
      },
    ),
  );
}

  Future<void> _hapusBarang(Barang barang) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barang'),
        content: Text(
          'Apakah kamu yakin ingin menghapus ${barang.nama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || barang.id == null) return;

    final berhasil = await _viewModel.hapusBarang(barang.id!);

    if (!mounted) return;

    _pesan(
      berhasil
          ? 'Barang berhasil dihapus'
          : _viewModel.errorMessage,
    );
  }

  Widget _kartuBarang(Barang barang) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    barang.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () => _tampilkanForm(barang: barang),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: () => _hapusBarang(barang),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('Kode: ${barang.kode}'),
            Text('Kategori: ${barang.kategori}'),
            Text('Jumlah: ${barang.jumlah}'),
            Text(
              'Harga: Rp ${barang.harga.toStringAsFixed(0)}',
            ),
            if (barang.lokasi != null &&
                barang.lokasi!.isNotEmpty)
              Text('Lokasi: ${barang.lokasi}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barang'),
        backgroundColor: warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          final daftar = _viewModel.daftarBarang;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _viewModel.cariBarang,
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau kode barang...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _viewModel.cariBarang('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.inventory_2,
                      color: warnaUtama,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total Barang: ${daftar.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _viewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _viewModel.errorMessage.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(_viewModel.errorMessage),
                            ),
                          )
                        : daftar.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada data barang',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _viewModel.loadBarang,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: daftar.length,
                                  itemBuilder: (context, index) {
                                    return _kartuBarang(daftar[index]);
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tampilkanForm(),
        backgroundColor: warnaUtama,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Barang'),
      ),
    );
  }
}
