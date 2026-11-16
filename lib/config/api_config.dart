class ApiConfig {

  static const String _gateway = 'https://mandate-coronary-animal.ngrok-free.dev';
  static const String wsGeoUrl = 'wss://mandate-coronary-animal.ngrok-free.dev/api/geo';

  static const String authUrl       = '$_gateway/api/auth';
  static const String inventarioUrl = '$_gateway/api/inventario';
  static const String logisticaUrl  = '$_gateway/api/logistica';
  static const String geoUrl        = '$_gateway/api/geo';

  static const String osrmUrl = 'https://mandate-coronary-animal.ngrok-free.dev/osrm';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  static Map<String, String> headersAuth(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'ngrok-skip-browser-warning': 'true',
  };
}