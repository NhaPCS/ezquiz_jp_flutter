class DeviceToken {
  String os;
  String version;

  DeviceToken(this.os, this.version);

  Map<String, dynamic> toMap() => {"os": os, "version": version};
}
