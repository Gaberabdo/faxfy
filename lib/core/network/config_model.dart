import '../utils/enums/env_enums.dart';

class ConfigModel {
  static late String serverFirstHalfOfWebSocket;
  static late String baseApiUrlfaxfy;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.test:
        serverFirstHalfOfWebSocket = 'ws://172.20.10.14:7000/ws';
        baseApiUrlfaxfy = 'http://172.20.10.14:7000/';

        break;
      case Environment.pro:
        serverFirstHalfOfWebSocket = 'ws://192.168.1.6:7000/ws';
        baseApiUrlfaxfy = 'http://192.168.1.6:7000/';
        break;
    }
  }
}
