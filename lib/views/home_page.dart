import 'barang_page.dart';
import 'kategori_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF153E75),
        foregroundColor: Colors.white,
        title: const Text('INVENTORY APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Admin!',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF153E75),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sistem Informasi Inventaris Barang',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFF153E75),
                  size: 40,
                ),
                title: const Text('Total Barang'),
                subtitle: const Text('Data inventaris tersimpan'),
                trailing: const Icon(Icons.arrow_forward_ios),

onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BarangPage(),
    ),
  );
},
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                  color: Colors.orange,
                  size: 40,
                ),
                title: const Text('Kategori Barang'),
                subtitle: const Text('Pengelompokan inventaris'),
                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const KategoriPage(),
    ),
  );
},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
