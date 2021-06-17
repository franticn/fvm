import '../../constants.dart';
import '../utils/helpers.dart';

/// Model for valid Flutter versions.
/// User for type safety across FVM
class ValidVersion {
  /// Name of the version
  String name;

  /// Is custom version
  bool custom;

  /// Constructor
  ValidVersion(
    this.name, {
    this.custom = false,
  });

  /// Version number
  String get version {
    if (forceChannel == null) {
      // Return name if channel is not forced
      return name;
    } else {
      // Return version number without channel
      final channel = '@$forceChannel';
      return name.substring(0, name.length - channel.length);
    }
  }

  /// Is [name] a release
  bool get isRelease {
    // Is a release if its not a channel or hash
    return !isGitHash && !isChannel;
  }

  /// Checks if [name] is a git hash
  bool get isGitHash {
    return checkIsGitHash(name);
  }

  /// Checks if need to reset after clone
  bool get needReset {
    return isGitHash || isRelease;
  }

  /// Is valid version a channel
  bool get isChannel {
    return kFlutterChannels.contains(name);
  }

  /// Forces a valid version within a channel
  String? get forceChannel {
    if (checkIsChannel(name)) {
      return null;
    }

    // Check if last part is channel
    // i.e. 2.2.2@beta
    final parts = name.split('@');

    if (checkIsChannel(parts.last)) {
      return parts.last;
    } else {
      return null;
    }
  }

  /// Is valid version is master channel
  bool get isMaster {
    return name == 'master';
  }

  @override
  String toString() {
    return name;
  }
}
