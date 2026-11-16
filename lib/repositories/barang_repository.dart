
import '../database/database_helper.dart';
import '../models/barang.dart';

class BarangRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Menampilkan semua barang
  Future<List<Barang>> getAllBarang() async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'barang',
      orderBy: 'id DESC',
    );

    return result.map((map) => Barang.fromMap(map)).toList();
  }

  // Menambahkan barang
  Future<int> tambahBarang(Barang barang) async {
    final db = await _databaseHelper.database;

    return await db.insert(
      'barang',
      barang.toMap(),
    );
  }

  // Mengubah data barang
  Future<int> updateBarang(Barang barang) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'barang',
      barang.toMap(),
      where: 'id = ?',
      whereArgs: [barang.id],
    );
  }

  // Menghapus barang
  Future<int> hapusBarang(int id) async {
    final db = await _databaseHelper.database;

    return await db.delete(
      'barang',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mencari barang
  Future<List<Barang>> cariBarang(String keyword) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'barang',
      where: 'nama LIKE ? OR kode LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'nama ASC',
    );

    return result.map((map) => Barang.fromMap(map)).toList();
  }
}
