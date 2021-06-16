import 'package:args/args.dart';

import '../models/valid_version_model.dart';
import '../services/project_service.dart';
import '../utils/commands.dart';
import '../utils/logger.dart';
import '../workflows/ensure_cache.workflow.dart';
import 'base_command.dart';

/// Proxies Flutter Commands
class FlutterCommand extends BaseCommand {
  @override
  final name = 'flutter';
  @override
  final description = 'Proxies Flutter Commands';
  @override
  final argParser = ArgParser.allowAnything();

  /// Constructor
  FlutterCommand();

  @override
  Future<int> run() async {
    final version = await ProjectService.findVersion();
    final args = argResults!.arguments;

    if (version != null) {
      final validVersion = ValidVersion(version);
      // Will install version if not already instaled
      final cacheVersion = await ensureCacheWorkflow(validVersion);

      logger.trace('fvm: running version "$version"\n');

      // Runs flutter command with pinned version
      return await flutterCmd(cacheVersion, args);
    } else {
      // Running null will default to flutter version on paths
      return await flutterGlobalCmd(args);
    }
  }
}
