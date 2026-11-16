
import 'package:flutter/material.dart';
import '../models/barang.dart';
import '../repositories/barang_repository.dart';

class BarangViewModel extends ChangeNotifier {
  final BarangRepository _repository = BarangRepository();

  List<Barang> _daftarBarang = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Barang> get daftarBarang => _daftarBarang;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadBarang() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _daftarBarang = await _repository.getAllBarang();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> tambahBarang(Barang barang) async {
    try {
      await _repository.tambahBarang(barang);
      await loadBarang();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan barang: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBarang(Barang barang) async {
    try {
      await _repository.updateBarang(barang);
      await loadBarang();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengubah barang: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> hapusBarang(int id) async {
    try {
      await _repository.hapusBarang(id);
      await loadBarang();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus barang: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> cariBarang(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      _daftarBarang = keyword.trim().isEmpty
          ? await _repository.getAllBarang()
          : await _repository.cariBarang(keyword);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Pencarian gagal: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
