
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final pathDB = join(dbPath, filePath);

    return await openDatabase(
      pathDB,
      version: 2,

      onCreate: _createDB,

      // Upgrade database lama tanpa menghapus data barang
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE kategori (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama TEXT NOT NULL UNIQUE
            )
          ''');
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabel barang
    await db.execute('''
      CREATE TABLE barang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode TEXT NOT NULL,
        nama TEXT NOT NULL,
        kategori TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        harga REAL NOT NULL,
        lokasi TEXT,
        tanggal TEXT
      )
    ''');

    // Tabel kategori
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL UNIQUE
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
