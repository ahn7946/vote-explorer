class AppConfig {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const int fetchSize = 20;

  static String get baseURL {
    if (isProduction) {
      // 배포 환경: nginx 프록시 경유
      return '/explorer';
    } else {
      // 개발 환경: 백엔드 서버 직접 접근
      return '$homeURL/explorer';
    }
  }

  static String homeURL = 'https://voting.jw-capstone.store/';
}
