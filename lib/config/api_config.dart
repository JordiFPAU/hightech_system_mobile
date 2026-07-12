class ApiConfig {

  static const String baseUrl = 'http://192.168.18.22';

  static const String authUrl = '$baseUrl:8081';
  static const String inventarioUrl = '$baseUrl:8082';
  static const String logisticaUrl = '$baseUrl:8083';
  static const String geoUrl = '$baseUrl:8084';

  // WebSocket para GPS
  static const String wsGeoUrl = 'ws://192.168.18.22:8084';
}