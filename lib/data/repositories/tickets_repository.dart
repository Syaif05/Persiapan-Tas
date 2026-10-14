import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../services/asset_storage_service.dart';

class TicketAttachmentWithAsset {
  final TicketAttachmentEntry attachment;
  final AssetEntry asset;

  TicketAttachmentWithAsset({
    required this.attachment,
    required this.asset,
  });

  String get id => attachment.id;
  String get assetId => asset.id;
  String get relativePath => asset.relativePath;
  String get mimeType => asset.mimeType;
  int get sizeBytes => asset.sizeBytes;
  String get originalName => asset.originalName;
  String get sha256 => asset.sha256;

  bool get isPdf => mimeType == 'application/pdf' || originalName.toLowerCase().endsWith('.pdf');
  bool get isImage => mimeType.startsWith('image/') ||
      originalName.toLowerCase().endsWith('.jpg') ||
      originalName.toLowerCase().endsWith('.jpeg') ||
      originalName.toLowerCase().endsWith('.png');
}

class TicketWithDetails {
  final TicketEntry ticket;
  final TripEntry trip;
  final ScheduleEventEntry? schedule;
  final List<TicketAttachmentWithAsset> attachments;

  TicketWithDetails({
    required this.ticket,
    required this.trip,
    this.schedule,
    this.attachments = const [],
  });

  String get id => ticket.id;
  String get title => ticket.title;
  String? get provider => ticket.provider;
  String? get bookingCode => ticket.bookingCode;
  String? get notes => ticket.notes;
  String get tripId => ticket.tripId;
  String? get scheduleEventId => ticket.scheduleEventId;
}

class TicketsRepository {
  final AppDatabase _db;
  final AssetStorageService _assetStorageService;
  final Uuid _uuid = const Uuid();

  TicketsRepository(this._db, this._assetStorageService);

  /// Membuat tiket baru (dengan atau tanpa jadwal, SCH-07)
  Future<String> createTicket({
    required String tripId,
    required String title,
    String? provider,
    String? bookingCode,
    String? notes,
    String? scheduleEventId,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Judul tiket tidak boleh kosong');
    }

    final id = _uuid.v4();

    await _db.into(_db.tickets).insert(
          TicketsCompanion.insert(
            id: id,
            tripId: tripId,
            scheduleEventId: Value(scheduleEventId),
            title: cleanTitle,
            provider: Value(provider?.trim()),
            bookingCode: Value(bookingCode?.trim()),
            notes: Value(notes?.trim()),
          ),
        );

    return id;
  }

  /// Memperbarui informasi tiket
  Future<void> updateTicket(
    String ticketId, {
    required String title,
    String? provider,
    String? bookingCode,
    String? notes,
    String? scheduleEventId,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Judul tiket tidak boleh kosong');
    }

    await (_db.update(_db.tickets)..where((t) => t.id.equals(ticketId))).write(
      TicketsCompanion(
        title: Value(cleanTitle),
        provider: Value(provider?.trim()),
        bookingCode: Value(bookingCode?.trim()),
        notes: Value(notes?.trim()),
        scheduleEventId: Value(scheduleEventId),
      ),
    );
  }

  /// Menghapus tiket beserta seluruh lampiran filenya
  Future<void> deleteTicket(String ticketId) async {
    // Ambil semua attachment untuk dibersihkan filenya dari storage
    final attachments = await (_db.select(_db.ticketAttachments)
          ..where((a) => a.ticketId.equals(ticketId)))
        .get();

    // Hapus tiket (cascade akan menghapus ticketAttachments di db)
    await (_db.delete(_db.tickets)..where((t) => t.id.equals(ticketId))).go();

    for (final att in attachments) {
      await _assetStorageService.deleteAsset(att.assetId);
    }
  }

  /// Menambah lampiran berkas (PDF atau Foto) ke tiket
  Future<TicketAttachmentWithAsset> addAttachment({
    required String ticketId,
    required File file,
    String? originalName,
    String? mimeType,
  }) async {
    // Simpan file ke sandbox storage
    final asset = await _assetStorageService.saveFile(
      file,
      kind: 'ticket_attachment',
      originalName: originalName,
      mimeType: mimeType,
    );

    // Ambil order terakhir
    final existing = await (_db.select(_db.ticketAttachments)
          ..where((a) => a.ticketId.equals(ticketId)))
        .get();

    final attachmentId = _uuid.v4();
    final attachmentEntry = TicketAttachmentEntry(
      id: attachmentId,
      ticketId: ticketId,
      assetId: asset.id,
      sortOrder: existing.length,
    );

    await _db.into(_db.ticketAttachments).insert(
          TicketAttachmentsCompanion.insert(
            id: attachmentId,
            ticketId: ticketId,
            assetId: asset.id,
            sortOrder: Value(existing.length),
          ),
        );

    return TicketAttachmentWithAsset(
      attachment: attachmentEntry,
      asset: asset,
    );
  }

  /// Menghapus lampiran tiket
  Future<void> removeAttachment(String attachmentId) async {
    final att = await (_db.select(_db.ticketAttachments)
          ..where((a) => a.id.equals(attachmentId)))
        .getSingleOrNull();

    if (att != null) {
      await (_db.delete(_db.ticketAttachments)..where((a) => a.id.equals(attachmentId))).go();
      await _assetStorageService.deleteAsset(att.assetId);
    }
  }

  /// Mengamati daftar tiket untuk perjalanan tertentu
  Stream<List<TicketWithDetails>> watchTripTickets(String tripId) {
    final query = _db.select(_db.tickets).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tickets.tripId)),
      leftOuterJoin(_db.scheduleEvents, _db.scheduleEvents.id.equalsExp(_db.tickets.scheduleEventId)),
    ])..where(_db.tickets.tripId.equals(tripId));

    return query.watch().asyncMap((rows) async {
      final results = <TicketWithDetails>[];
      for (final row in rows) {
        final ticket = row.readTable(_db.tickets);
        final trip = row.readTable(_db.trips);
        final schedule = row.readTableOrNull(_db.scheduleEvents);

        final attachments = await _getAttachmentsForTicket(ticket.id);

        results.add(TicketWithDetails(
          ticket: ticket,
          trip: trip,
          schedule: schedule,
          attachments: attachments,
        ));
      }
      return results;
    });
  }

  /// Mengamati detail tiket berdasarkan ID
  Stream<TicketWithDetails?> watchTicketById(String ticketId) {
    final query = _db.select(_db.tickets).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tickets.tripId)),
      leftOuterJoin(_db.scheduleEvents, _db.scheduleEvents.id.equalsExp(_db.tickets.scheduleEventId)),
    ])..where(_db.tickets.id.equals(ticketId));

    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;

      final ticket = row.readTable(_db.tickets);
      final trip = row.readTable(_db.trips);
      final schedule = row.readTableOrNull(_db.scheduleEvents);

      final attachments = await _getAttachmentsForTicket(ticket.id);

      return TicketWithDetails(
        ticket: ticket,
        trip: trip,
        schedule: schedule,
        attachments: attachments,
      );
    });
  }

  /// Mengambil detail tiket berdasarkan ID
  Future<TicketWithDetails?> getTicketById(String ticketId) async {
    final query = _db.select(_db.tickets).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tickets.tripId)),
      leftOuterJoin(_db.scheduleEvents, _db.scheduleEvents.id.equalsExp(_db.tickets.scheduleEventId)),
    ])..where(_db.tickets.id.equals(ticketId));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final ticket = row.readTable(_db.tickets);
    final trip = row.readTable(_db.trips);
    final schedule = row.readTableOrNull(_db.scheduleEvents);

    final attachments = await _getAttachmentsForTicket(ticket.id);

    return TicketWithDetails(
      ticket: ticket,
      trip: trip,
      schedule: schedule,
      attachments: attachments,
    );
  }

  Future<List<TicketAttachmentWithAsset>> _getAttachmentsForTicket(String ticketId) async {
    final query = _db.select(_db.ticketAttachments).join([
      innerJoin(_db.assets, _db.assets.id.equalsExp(_db.ticketAttachments.assetId)),
    ])
      ..where(_db.ticketAttachments.ticketId.equals(ticketId))
      ..orderBy([OrderingTerm.asc(_db.ticketAttachments.sortOrder)]);

    final rows = await query.get();
    return rows.map((r) {
      return TicketAttachmentWithAsset(
        attachment: r.readTable(_db.ticketAttachments),
        asset: r.readTable(_db.assets),
      );
    }).toList();
  }
}
