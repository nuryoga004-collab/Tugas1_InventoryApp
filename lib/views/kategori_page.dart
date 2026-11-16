
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List<Map<String, dynamic>> kategoriList = [];

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  Future<void> loadKategori() async {
    final db = await DatabaseHelper.instance.database;

    final data = await db.query(
      'kategori',
      orderBy: 'nama ASC',
    );

    if (!mounted) return;

    setState(() {
      kategoriList = data;
    });
  }

  Future<void> tambahKategori(String nama) async {
    final db = await DatabaseHelper.instance.database;

    try {
      await db.insert('kategori', {'nama': nama});
      await loadKategori();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil ditambahkan')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori sudah tersedia')),
      );
    }
  }

  Future<void> editKategori(int id, String nama) async {
    final db = await DatabaseHelper.instance.database;

    try {
      await db.update(
        'kategori',
        {'nama': nama},
        where: 'id = ?',
        whereArgs: [id],
      );

      await loadKategori();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori sudah tersedia')),
      );
    }
  }

  Future<void> hapusKategori(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'kategori',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadKategori();
  }

  void dialogKategori({int? id, String? namaLama}) {
    final controller = TextEditingController(text: namaLama);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(id == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama Kategori',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nama = controller.text.trim();

              if (nama.isEmpty) return;

              Navigator.pop(dialogContext);

              if (id == null) {
                await tambahKategori(nama);
              } else {
                await editKategori(id, nama);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void konfirmasiHapus(int id, String nama) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Yakin hapus kategori "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              hapusKategori(id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kategori'),
        backgroundColor: const Color(0xFF153E75),
        foregroundColor: Colors.white,
      ),
      body: kategoriList.isEmpty
          ? const Center(
              child: Text('Belum ada kategori'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: kategoriList.length,
              itemBuilder: (context, index) {
                final item = kategoriList[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.category,
                      color: Color(0xFF153E75),
                    ),
                    title: Text(item['nama']),
                    subtitle: Text('ID: ${item['id']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            dialogKategori(
                              id: item['id'],
                              namaLama: item['nama'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            konfirmasiHapus(
                              item['id'],
                              item['nama'],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF153E75),
        foregroundColor: Colors.white,
        onPressed: () => dialogKategori(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
