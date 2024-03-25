class WeatherException implements Exception {
  String message;
  WeatherException([this.message = 'Có điều gì đó không chính xác']) {
    message = 'Thông báo lỗi: $message';
  }

  @override
  String toString() {
    return message;
  }
}
