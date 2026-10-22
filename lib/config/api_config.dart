class ApiConfig {

  static const String _gateway = 'http://192.168.18.22:9090';

  static const String authUrl       = '$_gateway/api/auth';
  static const String inventarioUrl = '$_gateway/api/inventario';
  static const String logisticaUrl  = '$_gateway/api/logistica';
  static const String geoUrl        = '$_gateway/api/geo';

  static const String wsGeoUrl = 'ws://192.168.18.22:9090/api/geo';

  static const String osrmUrl = 'http://192.168.18.22:5000';
}