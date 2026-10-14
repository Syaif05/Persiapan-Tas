import 'package:intl/intl.dart';

class TimezoneInfo {
  final String id;
  final String label;
  final String abbreviation;
  final int offsetHours;

  const TimezoneInfo({
    required this.id,
    required this.label,
    required this.abbreviation,
    required this.offsetHours,
  });
}

class AppDateTimeUtils {
  static const List<TimezoneInfo> supportedTimezones = [
    TimezoneInfo(
      id: 'Asia/Jakarta',
      label: 'WIB - Waktu Indonesia Barat (UTC+7)',
      abbreviation: 'WIB',
      offsetHours: 7,
    ),
    TimezoneInfo(
      id: 'Asia/Makassar',
      label: 'WITA - Waktu Indonesia Tengah (UTC+8)',
      abbreviation: 'WITA',
      offsetHours: 8,
    ),
    TimezoneInfo(
      id: 'Asia/Jayapura',
      label: 'WIT - Waktu Indonesia Timur (UTC+9)',
      abbreviation: 'WIT',
      offsetHours: 9,
    ),
    TimezoneInfo(
      id: 'UTC',
      label: 'UTC - Universal Time Coordinated (UTC+0)',
      abbreviation: 'UTC',
      offsetHours: 0,
    ),
  ];

  static const String defaultZoneId = 'Asia/Jakarta';

  static TimezoneInfo getTimezoneInfo(String? zoneId) {
    if (zoneId == null || zoneId.isEmpty) {
      return supportedTimezones.first;
    }
    return supportedTimezones.firstWhere(
      (z) => z.id == zoneId,
      orElse: () => TimezoneInfo(
        id: zoneId,
        label: zoneId,
        abbreviation: zoneId,
        offsetHours: 7,
      ),
    );
  }

  static String getZoneAbbreviation(String? zoneId) {
    return getTimezoneInfo(zoneId).abbreviation;
  }

  /// Menghitung instant UTC ISO-8601 dari tanggal lokal, jam lokal, dan zona waktu IANA
  /// Jika isDateOnly atau localTime kosong, mengembalikan null (SCH-12: jangan paksa ke 00.00)
  static String? computeUtcInstant(
    String localDate,
    String? localTime,
    String? zoneId, {
    bool isDateOnly = false,
  }) {
    if (isDateOnly || localTime == null || localTime.trim().isEmpty) {
      return null;
    }

    try {
      final dateParts = localDate.split('-');
      final timeParts = localTime.split(':');

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final tzInfo = getTimezoneInfo(zoneId);
      final offsetHours = tzInfo.offsetHours;

      // Buat DateTime sebagai UTC lalu kurangi offset
      final localUtcEquivalent = DateTime.utc(year, month, day, hour, minute);
      final actualUtc = localUtcEquivalent.subtract(Duration(hours: offsetHours));

      return actualUtc.toIso8601String();
    } catch (_) {
      return null;
    }
  }

  /// Format tampilan waktu dan zona (misal: "07:30 WIB" atau "Sepanjang hari")
  static String formatEventTime(
    String? localTime,
    String? zoneId, {
    bool isDateOnly = false,
    String? localEndTime,
    String? endZoneId,
  }) {
    if (isDateOnly || localTime == null || localTime.trim().isEmpty) {
      return 'Sepanjang hari';
    }

    final startAbbr = getZoneAbbreviation(zoneId);
    if (localEndTime != null && localEndTime.trim().isNotEmpty) {
      final endAbbr = getZoneAbbreviation(endZoneId ?? zoneId);
      if (startAbbr == endAbbr) {
        return '$localTime - $localEndTime $startAbbr';
      }
      return '$localTime $startAbbr - $localEndTime $endAbbr';
    }

    return '$localTime $startAbbr';
  }

  /// Format tanggal ramah pengguna dalam Bahasa Indonesia (misal: "18 Okt 2026")
  static String formatLocalDate(String localDate) {
    try {
      final dt = DateTime.parse(localDate);
      return DateFormat('d MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      try {
        final dt = DateTime.parse(localDate);
        return DateFormat('d MMM yyyy').format(dt);
      } catch (_) {
        return localDate;
      }
    }
  }

  /// Format tanggal lengkap dalam Bahasa Indonesia (misal: "Minggu, 18 Oktober 2026")
  static String formatFullDate(DateTime dt) {
    try {
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      try {
        return DateFormat('EEEE, d MMMM yyyy').format(dt);
      } catch (_) {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    }
  }

  /// Format waktu konfirmasi fisik (CORE-01)
  static String formatConfirmationTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      return 'Waktu konfirmasi belum tersedia';
    }
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final dateStr = DateFormat('d MMM', 'id_ID').format(dt);
      final timeStr = DateFormat('HH:mm').format(dt);
      return 'Terakhir dikonfirmasi: $dateStr, $timeStr';
    } catch (_) {
      try {
        final dt = DateTime.parse(isoString).toLocal();
        return 'Terakhir dikonfirmasi: ${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        return 'Waktu konfirmasi: $isoString';
      }
    }
  }

  /// Format bulan & tahun dalam Bahasa Indonesia (misal: "Oktober 2026")
  static String formatMonthYear(DateTime dt) {
    try {
      return DateFormat('MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      try {
        return DateFormat('MMMM yyyy').format(dt);
      } catch (_) {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      }
    }
  }

  /// Format tanggal hari & bulan dalam Bahasa Indonesia (misal: "18 Oktober 2026")
  static String formatDateMonthYear(DateTime dt) {
    try {
      return DateFormat('d MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      try {
        return DateFormat('d MMMM yyyy').format(dt);
      } catch (_) {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    }
  }

  /// Validasi apakah tanggal acara berada di dalam rentang tanggal perjalanan
  static bool isDateWithinTripRange(String eventDate, String tripStartDate, String? tripEndDate) {
    try {
      final ev = DateTime.parse(eventDate);
      final start = DateTime.parse(tripStartDate);
      if (ev.isBefore(start)) {
        return false;
      }
      if (tripEndDate != null && tripEndDate.isNotEmpty) {
        final end = DateTime.parse(tripEndDate);
        if (ev.isAfter(end)) {
          return false;
        }
      }
      return true;
    } catch (_) {
      return true;
    }
  }
}
