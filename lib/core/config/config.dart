class AppConfig {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const int fetchSize = 1500;

  static String get baseURL {
    if (isProduction) {
      // 배포 환경: nginx 프록시 경유
      return '/explorer';
    } else {
      // 개발 환경: 백엔드 서버 직접 접근
      return 'http://l4.ai-capstone.store:8081/explorer';
    }
  }

  static String get homeURL {
    if (isProduction) {
      return 'https://voting.jw-capstone.store/';
    } else {
      return 'http://l1.ai-capstone.store:8081/';
    }
  }
}
