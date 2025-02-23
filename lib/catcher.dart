library catcher;

export 'package:catcher/core/catcher.dart';
export "package:catcher/handlers/console_handler.dart";
export "package:catcher/handlers/discord_handler.dart";
export "package:catcher/handlers/email_auto_handler.dart";
export "package:catcher/handlers/email_manual_handler.dart";
export "package:catcher/handlers/file_handler.dart";
export "package:catcher/handlers/http_handler.dart";
export "package:catcher/handlers/sentry_handler.dart";
export "package:catcher/handlers/slack_handler.dart";
export "package:catcher/handlers/toast_handler.dart";
export 'package:catcher/mode/dialog_report_mode.dart';
export 'package:catcher/mode/page_report_mode.dart';
export 'package:catcher/mode/report_mode_action_confirmed.dart';
export 'package:catcher/mode/silent_report_mode.dart';
export 'package:catcher/model/catcher_options.dart';
export 'package:catcher/model/http_request_type.dart';
export 'package:catcher/model/localization_options.dart';
export 'package:catcher/model/report.dart';
export 'package:catcher/model/report_handler.dart';
export 'package:catcher/model/report_mode.dart';
export 'package:catcher/model/toast_handler_gravity.dart';
export 'package:catcher/model/toast_handler_length.dart';

/// TODO:
/// Just a dummy code to fix pubdev score
/// This should be removed later
@Deprecated("Don't use this!")
void dummyCode() {}
