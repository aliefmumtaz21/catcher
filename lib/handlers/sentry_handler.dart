import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

class SentryHandler extends ReportHandler {
  ///Sentry Client instance
  final SentryClient sentryClient;

  ///Enable device parameters to be generated by Catcher
  final bool enableDeviceParameters;

  ///Enable application parameters to be generated by Catcher
  final bool enableApplicationParameters;

  ///Enable custom parameters to be generated by Catcher
  final bool enableCustomParameters;

  ///Custom environment, if null, Catcher will generate it
  final String? customEnvironment;

  ///Custom release, if null, Catcher will generate it
  final String? customRelease;

  ///Enable additional logs printing
  final bool printLogs;
  final Logger _logger = Logger("SentryHandler");

  SentryHandler(
    this.sentryClient, {
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableCustomParameters = true,
    this.printLogs = true,
    this.customEnvironment,
    this.customRelease,
  });

  @override
  Future<bool> handle(Report error) async {
    try {
      _printLog("Logging to sentry...");

      final tags = <String, dynamic>{};
      if (enableApplicationParameters) {
        tags.addAll(error.applicationParameters);
      }
      if (enableDeviceParameters) {
        tags.addAll(error.deviceParameters);
      }
      if (enableCustomParameters) {
        tags.addAll(error.customParameters);
      }

      final event = buildEvent(error, tags);
      await sentryClient.captureEvent(event);

      _printLog("Logged to sentry!");
      return true;
    } catch (exception, stackTrace) {
      _printLog("Failed to send sentry event: $exception $stackTrace");
      return false;
    }
  }

  String _getApplicationVersion(Report report) {
    String applicationVersion = "";
    final applicationParameters = report.applicationParameters;
    if (applicationParameters.containsKey("appName")) {
      applicationVersion += (applicationParameters["appName"] as String?)!;
    }
    if (applicationParameters.containsKey("version")) {
      applicationVersion += " ${applicationParameters["version"]}";
    }
    if (applicationVersion.isEmpty) {
      applicationVersion = "?";
    }
    return applicationVersion;
  }

  SentryEvent buildEvent(Report report, Map<String, dynamic> tags) {
    return SentryEvent(
      logger: "Catcher",
      serverName: "Catcher",
      release: customRelease ?? _getApplicationVersion(report),
      environment: customEnvironment ??
          (report.applicationParameters["environment"] as String?),
      throwable: report.error,
      level: SentryLevel.error,
      culprit: "",
      tags: changeToSentryMap(tags),
    );
  }

  Map<String, String> changeToSentryMap(Map<String, dynamic> map) {
    final sentryMap = <String, String>{};
    map.forEach((key, dynamic value) {
      if (value.toString().isEmpty) {
        sentryMap[key] = "none";
      } else {
        sentryMap[key] = value.toString();
      }
    });
    return sentryMap;
  }

  void _printLog(String message) {
    if (printLogs) {
      _logger.info(message);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.web, PlatformType.android, PlatformType.iOS];
}
