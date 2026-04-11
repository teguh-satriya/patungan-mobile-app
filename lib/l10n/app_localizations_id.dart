// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Patungan';

  @override
  String get tagline => 'Kelola keuangan bersama';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get delete => 'Hapus';

  @override
  String get save => 'Simpan';

  @override
  String get required => 'Wajib diisi';

  @override
  String get invalidNumber => 'Angka tidak valid';

  @override
  String get noData => 'Tidak ada data';

  @override
  String get areYouSure => 'Apakah Anda yakin?';

  @override
  String get language => 'Bahasa';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Masukkan email yang valid';

  @override
  String get password => 'Kata Sandi';

  @override
  String get passwordMin => 'Min 6 karakter';

  @override
  String get username => 'Nama Pengguna';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginFailed => 'Login gagal';

  @override
  String get noAccount => 'Belum punya akun? Daftar';

  @override
  String get registerTitle => 'Buat Akun';

  @override
  String get registerButton => 'Daftar';

  @override
  String get registerSuccess => 'Pendaftaran berhasil! Silakan masuk.';

  @override
  String get registerFailed => 'Pendaftaran gagal';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get navHome => 'Beranda';

  @override
  String get navTransactions => 'Transaksi';

  @override
  String get navAnalytics => 'Analitik';

  @override
  String get navTypes => 'Kategori';

  @override
  String welcomeBack(String name) {
    return 'Selamat datang, $name!';
  }

  @override
  String get currentBalance => 'Saldo Saat Ini';

  @override
  String get income => 'Pemasukan';

  @override
  String get expense => 'Pengeluaran';

  @override
  String get projectedEndBalance => 'Proyeksi Saldo Akhir';

  @override
  String get carriedOver => 'Saldo Pindahan';

  @override
  String get transactions => 'Transaksi';

  @override
  String get summaryTitle => 'Ringkasan';

  @override
  String thisMonth(String month, int year) {
    return 'Bulan Ini — $month $year';
  }

  @override
  String yearAllMonths(int year) {
    return 'Tahun $year — Semua Bulan';
  }

  @override
  String get startingBalance => 'Saldo Awal';

  @override
  String get totalIncome => 'Total Pemasukan';

  @override
  String get totalExpense => 'Total Pengeluaran';

  @override
  String get carryOverButton => 'Pindahkan ke Bulan Depan';

  @override
  String get carryOverTitle => 'Pindahkan Saldo';

  @override
  String carryOverContent(String month, int year) {
    return 'Pindahkan saldo akhir $month $year ke bulan depan?';
  }

  @override
  String get carriedOverSuccess => 'Saldo berhasil dipindahkan';

  @override
  String get budgetTitle => 'Anggaran';

  @override
  String overviewHeader(String month, int year) {
    return 'Ikhtisar – $month/$year';
  }

  @override
  String get spendingByCategory => 'Pengeluaran per Kategori';

  @override
  String get transactionsTitle => 'Transaksi';

  @override
  String get newTransaction => 'Transaksi Baru';

  @override
  String get editTransaction => 'Edit Transaksi';

  @override
  String get deleteTransaction => 'Hapus Transaksi';

  @override
  String get transactionType => 'Jenis Transaksi';

  @override
  String get amount => 'Jumlah';

  @override
  String get date => 'Tanggal';

  @override
  String get notes => 'Catatan';

  @override
  String get selectType => 'Pilih jenis transaksi terlebih dahulu';

  @override
  String get done => 'Selesai';

  @override
  String get typesTitle => 'Jenis Transaksi';

  @override
  String get newType => 'Jenis Baru';

  @override
  String get editType => 'Edit Jenis';

  @override
  String get deleteType => 'Hapus Jenis Transaksi';

  @override
  String deleteTypeConfirm(String name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String get thisType => 'jenis ini';

  @override
  String get noTypesYet => 'Belum ada jenis transaksi';

  @override
  String get typeDeleted => 'Jenis transaksi dihapus';

  @override
  String get reportsTitle => 'Laporan';

  @override
  String get tabCashFlow => 'Arus Kas';

  @override
  String get tabComparison => 'Perbandingan';

  @override
  String get tabTrend => 'Tren';

  @override
  String get tabCarryover => 'Pindahan';

  @override
  String get cashFlowSummary => 'Ringkasan Arus Kas';

  @override
  String get openingBalance => 'Saldo Awal';

  @override
  String get netCashFlow => 'Arus Kas Bersih';

  @override
  String get closingBalance => 'Saldo Akhir';

  @override
  String get incomeBreakdown => 'Rincian Pemasukan';

  @override
  String get incomeVsExpenseChart => 'Pemasukan vs Pengeluaran';

  @override
  String get selectDateRange => 'Pilih Rentang Tanggal';

  @override
  String get from => 'Dari';

  @override
  String get to => 'Sampai';

  @override
  String get show => 'Tampilkan';

  @override
  String get selectDateRangePrompt =>
      'Pilih rentang tanggal lalu tap Tampilkan';

  @override
  String get overallComparison => 'Perbandingan Keseluruhan';

  @override
  String get netAmount => 'Jumlah Bersih';

  @override
  String get monthlyBreakdown => 'Rincian Bulanan';

  @override
  String get incomeVsExpensePerMonth => 'Pemasukan vs Pengeluaran per Bulan';

  @override
  String trendAnalysis(int months) {
    return 'Analisis Tren ($months bulan)';
  }

  @override
  String get avgIncome => 'Rata-rata Pemasukan';

  @override
  String get avgExpense => 'Rata-rata Pengeluaran';

  @override
  String get avgNet => 'Rata-rata Bersih';

  @override
  String get trendDirection => 'Arah Tren';

  @override
  String get balanceHistory => 'Riwayat Saldo';

  @override
  String get monthlyTrends => 'Tren Bulanan';

  @override
  String get notesOptional => 'Catatan (opsional)';

  @override
  String get name => 'Nama';

  @override
  String get update => 'Perbarui';

  @override
  String get descriptionOptional => 'Deskripsi (opsional)';

  @override
  String get nature => 'Jenis';

  @override
  String get iconOptional => 'Ikon (opsional)';

  @override
  String get noTransactionsYet => 'Belum ada transaksi';

  @override
  String get dateLabel => 'Tanggal';

  @override
  String get error => 'Kesalahan';

  @override
  String get carryoverSummary => 'Ringkasan Pindahan';

  @override
  String get totalCarriedOver => 'Total Pindahan';

  @override
  String get avgCarryover => 'Rata-rata Pindahan';

  @override
  String get monthlyDetail => 'Rincian Bulanan';

  @override
  String get startLabel => 'Awal';

  @override
  String get endLabel => 'Akhir';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Agu';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Okt';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Des';

  @override
  String get monthJanFull => 'Januari';

  @override
  String get monthFebFull => 'Februari';

  @override
  String get monthMarFull => 'Maret';

  @override
  String get monthAprFull => 'April';

  @override
  String get monthMayFull => 'Mei';

  @override
  String get monthJunFull => 'Juni';

  @override
  String get monthJulFull => 'Juli';

  @override
  String get monthAugFull => 'Agustus';

  @override
  String get monthSepFull => 'September';

  @override
  String get monthOctFull => 'Oktober';

  @override
  String get monthNovFull => 'November';

  @override
  String get monthDecFull => 'Desember';
}
