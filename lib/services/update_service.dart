import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ReleaseInfo {
  final String tagName;
  final String body;
  final String publishedAt;
  final List<ReleaseAsset> assets;

  ReleaseInfo({
    required this.tagName,
    required this.body,
    required this.publishedAt,
    required this.assets,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) {
    var list = json['assets'] as List? ?? [];
    List<ReleaseAsset> assetList = list.map((i) => ReleaseAsset.fromJson(i)).toList();
    return ReleaseInfo(
      tagName: json['tag_name'] ?? 'v1.0.0',
      body: json['body'] ?? '',
      publishedAt: json['published_at'] ?? '',
      assets: assetList,
    );
  }
}

class ReleaseAsset {
  final String name;
  final String downloadUrl;

  ReleaseAsset({required this.name, required this.downloadUrl});

  factory ReleaseAsset.fromJson(Map<String, dynamic> json) {
    return ReleaseAsset(
      name: json['name'] ?? '',
      downloadUrl: json['browser_download_url'] ?? '',
    );
  }
}

class UpdateService {
  static const String repoOwner = 'CluvexStudio';
  static const String repoName = 'Aether';

  static Future<ReleaseInfo?> fetchLatestPublisherRelease() async {
    try {
      final url = Uri.parse('https://api.github.com/repos/$repoOwner/$repoName/releases/latest');
      final response = await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ReleaseInfo.fromJson(data);
      }
    } catch (e) {
      // Return null on offline / error
    }
    return null;
  }

  static String? getMatchingBinaryUrl(ReleaseInfo release, String abi) {
    String pattern;
    if (abi.contains('arm64')) {
      pattern = 'aether-android-arm64';
    } else if (abi.contains('armv7') || abi.contains('arm')) {
      pattern = 'aether-android-armv7';
    } else {
      pattern = 'aether-android-x86_64';
    }

    for (var asset in release.assets) {
      if (asset.name.contains(pattern) && asset.name.endsWith('.tar.gz')) {
        return asset.downloadUrl;
      }
    }
    return null;
  }

  static Future<Uint8List?> downloadBinary(String downloadUrl) async {
    try {
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      // Exception handled
    }
    return null;
  }
}
