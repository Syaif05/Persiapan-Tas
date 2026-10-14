import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Model data hasil tap notifikasi
class NotificationPayloadData {
  final String? tripId;
  final String? scheduleEventId;
  final String? reminderId;

  NotificationPayloadData({
    this.tripId,
    this.scheduleEventId,
    this.reminderId,
  });

  Map<String, dynamic> toMap() => {
        if (tripId != null) 'tripId': tripId,
        if (scheduleEventId != null) 'scheduleEventId': scheduleEventId,
        if (reminderId != null) 'reminderId': reminderId,
      };

  String toJson() => jsonEncode(toMap());

  factory NotificationPayloadData.fromJson(String jsonStr) {
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return NotificationPayloadData(
        tripId: map['tripId'] as String?,
        scheduleEventId: map['scheduleEventId'] as String?,
        reminderId: map['reminderId'] as String?,
      );
    } catch (_) {
      return NotificationPayloadData();
    }
  }
}

/// Status izin notifikasi & exact alarm
class NotificationPermissionStatus {
  final bool notificationsAllowed;
  final bool exactAlarmsAllowed;

  const NotificationPermissionStatus({
    required this.notificationsAllowed,
    required this.exactAlarmsAllowed,
  });

  bool get isFullyActive => notificationsAllowed && exactAlarmsAllowed;
}

/// Service pengelola notifikasi lokal Android
class NotificationService {
  static const String channelId = 'bawa_schedule_reminders';
  static const String channelName = 'Pengingat Jadwal & Perjalanan';
  static const String channelDescription =
      'Notifikasi pengingat untuk kegiatan dan jadwal perjalanan Bawa';

  final FlutterLocalNotificationsPlugin _plugin;
  final bool isTestMode;
  bool _exactAlarmsAllowed = true;
  bool _notificationsAllowed = true;

  final List<int> scheduledNotificationIds = [];
  final List<int> cancelledNotificationIds = [];

  final StreamController<NotificationPayloadData> _payloadStreamController =
      StreamController<NotificationPayloadData>.broadcast();

  Stream<NotificationPayloadData> get onNotificationTapped =>
      _payloadStreamController.stream;

  NotificationPayloadData? _initialLaunchPayload;
  NotificationPayloadData? get initialLaunchPayload => _initialLaunchPayload;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this.isTestMode = false,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Setter untuk testing exact alarm state
  @visibleForTesting
  void setExactAlarmsAllowedForTesting(bool allowed) {
    _exactAlarmsAllowed = allowed;
  }

  /// Setter untuk testing notification permission state
  @visibleForTesting
  void setNotificationsAllowedForTesting(bool allowed) {
    _notificationsAllowed = allowed;
  }

  /// Inisialisasi plugin notifikasi dan timezone
  Future<void> initialize({
    void Function(NotificationPayloadData)? onTapped,
  }) async {
    if (_initialized) return;

    tz.initializeTimeZones();

    if (isTestMode) {
      _initialized = true;
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payloadStr = response.payload;
        if (payloadStr != null && payloadStr.isNotEmpty) {
          final data = NotificationPayloadData.fromJson(payloadStr);
          _payloadStreamController.add(data);
          onTapped?.call(data);
        }
      },
    );

    // Cek apakah aplikasi dibuka dari klik notifikasi (cold start - SCH-11, AT-16)
    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        final payloadStr = launchDetails.notificationResponse?.payload;
        if (payloadStr != null && payloadStr.isNotEmpty) {
          _initialLaunchPayload = NotificationPayloadData.fromJson(payloadStr);
          _payloadStreamController.add(_initialLaunchPayload!);
          onTapped?.call(_initialLaunchPayload!);
        }
      }
    } catch (e) {
      debugPrint('Notification launch details check failed: $e');
    }

    _initialized = true;
  }

  /// Memeriksa status izin saat ini
  Future<NotificationPermissionStatus> checkPermissionStatus() async {
    if (isTestMode) {
      return NotificationPermissionStatus(
        notificationsAllowed: _notificationsAllowed,
        exactAlarmsAllowed: _exactAlarmsAllowed,
      );
    }

    bool notificationsAllowed = true;

    if (Platform.isAndroid) {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final areNotificationsEnabled =
            await androidImplementation.areNotificationsEnabled();
        notificationsAllowed = areNotificationsEnabled ?? true;
      }
    }

    return NotificationPermissionStatus(
      notificationsAllowed: notificationsAllowed,
      exactAlarmsAllowed: _exactAlarmsAllowed,
    );
  }

  /// Meminta izin notifikasi runtime (Android 13+)
  Future<bool> requestNotificationPermission() async {
    if (isTestMode) return _notificationsAllowed;

    if (Platform.isAndroid) {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        _notificationsAllowed = granted ?? false;
        return _notificationsAllowed;
      }
    }
    return true;
  }

  /// Meminta izin exact alarm (Android 12+)
  Future<bool> requestExactAlarmsPermission() async {
    if (isTestMode) return _exactAlarmsAllowed;

    if (Platform.isAndroid) {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestExactAlarmsPermission();
        _exactAlarmsAllowed = granted ?? false;
        return _exactAlarmsAllowed;
      }
    }
    return true;
  }

  /// Menjadwalkan pengingat jadwal
  Future<void> scheduleReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledUtc,
    required NotificationPayloadData payload,
    bool isExact = true,
  }) async {
    if (isTestMode) {
      scheduledNotificationIds.add(notificationId);
      return;
    }

    final tzDateTime = tz.TZDateTime.from(scheduledUtc, tz.UTC);

    // Detail notifikasi Android (lock screen aman tanpa kode booking rahasia)
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      visibility: NotificationVisibility.private, // Proteksi lock screen
    );

    final details = NotificationDetails(android: androidDetails);

    final scheduleMode = isExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzDateTime,
      details,
      payload: payload.toJson(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: scheduleMode,
    );
  }

  /// Membatalkan notifikasi berdasarkan ID
  Future<void> cancelNotification(int notificationId) async {
    if (isTestMode) {
      cancelledNotificationIds.add(notificationId);
      return;
    }
    await _plugin.cancel(notificationId);
  }

  /// Membatalkan daftar ID notifikasi
  Future<void> cancelNotifications(List<int> notificationIds) async {
    if (isTestMode) {
      cancelledNotificationIds.addAll(notificationIds);
      return;
    }
    for (final id in notificationIds) {
      await _plugin.cancel(id);
    }
  }

  /// Membatalkan seluruh notifikasi terjadwal
  Future<void> cancelAll() async {
    if (isTestMode) {
      cancelledNotificationIds.addAll(scheduledNotificationIds);
      return;
    }
    await _plugin.cancelAll();
  }

  void dispose() {
    _payloadStreamController.close();
  }
}
