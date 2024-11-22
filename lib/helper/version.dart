class Version implements Comparable<Version> {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch);

  factory Version.parse(String version) {
    final parts = version.split('.');
    final major = int.tryParse(parts[0]) ?? 0;
    final minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final patch = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return Version(major, minor, patch);
  }

  @override
  int compareTo(Version other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    } else if (minor != other.minor) {
      return minor.compareTo(other.minor);
    } else {
      return patch.compareTo(other.patch);
    }
  }

  @override
  String toString() {
    return '$major.$minor.$patch';
  }
}