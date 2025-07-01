enum Environment { dev, test, uat, prod, default_env }

class EnvConfig {
  static Environment _environment = Environment.dev;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-mzgdjg.yuanzhiyijiantong.com/';
      case Environment.test:
        return 'http://8.138.182.179:8003/';
      case Environment.uat:
        return 'http://119.91.214.144:8003/';
      case Environment.prod:
        return 'http://10.194.68.14:8001/';
      case Environment.default_env:
        return 'http://8.138.182.179:8003/';
    }
  }

  static String get environmentName {
    switch (_environment) {
      case Environment.dev:
        return '开发环境';
      case Environment.test:
        return '测试环境';
      case Environment.uat:
        return 'UAT环境';
      case Environment.prod:
        return '生产环境';
      case Environment.default_env:
        return '默认环境';
    }
  }
}
