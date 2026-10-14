import '../../data/database/app_database.dart';
import '../../data/repositories/trip_packing_repository.dart';
import '../../data/repositories/trips_repository.dart';

/// Utilitas untuk memformat data bawaan perjalanan menjadi teks yang rapi,
/// berstruktur Markdown, mudah dibaca manusia, dan mudah diproses oleh AI.
class TripTextFormatter {
  /// Format daftar bawaan perjalanan menjadi teks terstruktur
  static String formatTrip({
    required TripEntry trip,
    required List<TripStopEntry> stops,
    required List<TripItemWithDetails> items,
    TripPackingSummary? summary,
    List<TripBagEntry>? bags,
  }) {
    final buffer = StringBuffer();
    final stopsStr = stops.isNotEmpty
        ? stops.map((s) => s.label).join(' ➔ ')
        : 'Tujuan belum diatur';
    final dateStr = trip.endDate != null && trip.endDate!.isNotEmpty
        ? '${trip.startDate} s/d ${trip.endDate}'
        : '${trip.startDate} (Fleksibel)';

    buffer.writeln('# 🎒 DAFTAR BAWAAN PERJALANAN: ${trip.name.toUpperCase()}');
    buffer.writeln('📅 Jadwal  : $dateStr');
    buffer.writeln('📍 Rute    : $stopsStr');
    buffer.writeln('🏷️ Status  : ${_formatStatus(trip.status)}');
    if (summary != null) {
      final percent = (summary.progress * 100).toInt();
      buffer.writeln(
          '📊 Kesiapan: ${summary.completedRows}/${summary.totalCarriedRows} jenis barang ($percent% siap) • ${summary.totalPackedUnits}/${summary.totalPlannedUnits} unit terkemas');
    }
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('');

    if (items.isEmpty) {
      buffer.writeln('*(Belum ada barang yang dipilih untuk perjalanan ini)*');
      buffer.writeln('');
    } else {
      // 1. Bagian: Barang Penting (Dokumen & Obat)
      final essentialItems = items.where((i) => i.isImportant).toList();
      if (essentialItems.isNotEmpty) {
        buffer.writeln('### ⚠️ BARANG PENTING (DOKUMEN & OBAT):');
        for (final item in essentialItems) {
          buffer.writeln(_formatItemLine(item));
        }
        buffer.writeln('');
      }

      // 2. Bagian: Disiapkan Terakhir (PACK-01)
      final packedLastItems = items.where((i) => i.isPackedLast).toList();
      if (packedLastItems.isNotEmpty) {
        buffer.writeln('### ⏳ DISIAPKAN TERAKHIR (MENIT TERAKHIR SEBELUM BERANGKAT):');
        for (final item in packedLastItems) {
          buffer.writeln(_formatItemLine(item));
        }
        buffer.writeln('');
      }

      // 3. Bagian: Seluruh Rencana Bawaan
      buffer.writeln('### 📋 DAFTAR LENGKAP SEMUA BARANG:');
      for (final item in items) {
        buffer.writeln(_formatItemLine(item));
      }
      buffer.writeln('');
    }

    buffer.writeln('--------------------------------------------------');
    buffer.writeln(
        '💡 Catatan: Checklist Markdown [x] sudah terkemas, [-] sedang dipakai, [ ] belum dikemas.');
    buffer.writeln('📦 Dihasilkan secara offline oleh aplikasi Siapkan Tas.');

    return buffer.toString();
  }

  static String _formatItemLine(TripItemWithDetails item) {
    final ti = item.tripItem;
    final isDone = ti.packedQuantity >= ti.plannedQuantity;
    final check = isDone ? '[x]' : (ti.inUseQuantity > 0 ? '[-]' : '[ ]');
    final statusText = isDone
        ? 'SUDAH DIKEMAS'
        : (ti.inUseQuantity > 0 ? 'SEDANG DIPAKAI' : 'BELUM DIKEMAS');

    final location = item.displayLocation;
    final bag = item.allocationSummary;
    final unit = item.item?.unit ?? 'buah';
    final notes = ti.notes != null && ti.notes!.trim().isNotEmpty
        ? ' • Catatan: ${ti.notes!.trim()}'
        : '';
    final lastPacked = ti.isPackedLast ? ' • [Disiapkan Terakhir]' : '';

    return '- $check **${item.displayName}** (${ti.packedQuantity}/${ti.plannedQuantity} $unit) [$statusText]\n'
        '    Asal: $location | Wadah: $bag$lastPacked$notes';
  }

  static String _formatStatus(String status) {
    switch (status) {
      case 'planning':
        return 'PERSIAPAN';
      case 'ongoing':
        return 'SEDANG BERJALAN';
      case 'completed':
        return 'SELESAI (ARSIP)';
      case 'cancelled':
        return 'DIBATALKAN';
      default:
        return status.toUpperCase();
    }
  }
}
