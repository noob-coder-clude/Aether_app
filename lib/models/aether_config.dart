class AetherConfig {
  String protocol; // masque, wg, gool
  String scanMode; // turbo, balanced, thorough, stealth
  String noiseProfile; // firewall, gfw, balanced, aggressive, light, off
  bool useHttp2;
  bool enableFragment;
  String fragmentSize;
  String fragmentDelay;
  bool quickReconnect;
  String bindAddr;
  String customPeer;
  bool isSystemVpn;

  AetherConfig({
    this.protocol = 'masque',
    this.scanMode = 'balanced',
    this.noiseProfile = 'firewall',
    this.useHttp2 = false,
    this.enableFragment = false,
    this.fragmentSize = '16-32',
    this.fragmentDelay = '2-10',
    this.quickReconnect = true,
    this.bindAddr = '127.0.0.1:1819',
    this.customPeer = '',
    this.isSystemVpn = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'protocol': protocol,
      'scan': scanMode,
      'noise': noiseProfile,
      'http2': useHttp2,
      'fragment': enableFragment,
      'fragmentSize': fragmentSize,
      'fragmentDelay': fragmentDelay,
      'quickReconnect': quickReconnect,
      'bind': bindAddr,
      'peer': customPeer,
      'isSystemVpn': isSystemVpn,
    };
  }
}
