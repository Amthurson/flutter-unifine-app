class HomeUrlInfo {
  final String? windowsId;
  final String? windowsName;
  final String? serviceName;
  final String? indexUrl;
  final String? mainWindowUrl;
  final String? bannerUrl;
  final String? navMobileUrl;
  final String? navName;

  HomeUrlInfo({
    this.windowsId,
    this.windowsName,
    this.serviceName,
    this.indexUrl,
    this.mainWindowUrl,
    this.bannerUrl,
    this.navMobileUrl,
    this.navName,
  });

  factory HomeUrlInfo.fromJson(Map<String, dynamic> json) {
    return HomeUrlInfo(
      windowsId: json['windowsId'],
      windowsName: json['windowsName'],
      serviceName: json['serviceName'],
      indexUrl: json['indexUrl'],
      mainWindowUrl: json['mainWindowUrl'],
      bannerUrl: json['bannerUrl'],
      navMobileUrl: json['navMobileUrl'],
      navName: json['navName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'windowsId': windowsId,
      'windowsName': windowsName,
      'serviceName': serviceName,
      'indexUrl': indexUrl,
      'mainWindowUrl': mainWindowUrl,
      'bannerUrl': bannerUrl,
      'navMobileUrl': navMobileUrl,
      'navName': navName,
    };
  }

  @override
  String toString() {
    return 'HomeUrlInfo{windowsId: $windowsId, windowsName: $windowsName, serviceName: $serviceName, indexUrl: $indexUrl, mainWindowUrl: $mainWindowUrl, bannerUrl: $bannerUrl, navMobileUrl: $navMobileUrl, navName: $navName}';
  }

  HomeUrlInfo copyWith({
    String? windowsId,
    String? windowsName,
    String? serviceName,
    String? indexUrl,
    String? mainWindowUrl,
    String? bannerUrl,
    String? navMobileUrl,
    String? navName,
  }) {
    return HomeUrlInfo(
      windowsId: windowsId ?? this.windowsId,
      windowsName: windowsName ?? this.windowsName,
      serviceName: serviceName ?? this.serviceName,
      indexUrl: indexUrl ?? this.indexUrl,
      mainWindowUrl: mainWindowUrl ?? this.mainWindowUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      navMobileUrl: navMobileUrl ?? this.navMobileUrl,
      navName: navName ?? this.navName,
    );
  }
}
