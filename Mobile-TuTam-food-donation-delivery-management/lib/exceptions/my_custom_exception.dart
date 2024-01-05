class MyCustomException implements Exception {
  final String message;
  final String status;
  MyCustomException(this.message, this.status);

  MyCustomException.fromObject(Map<String, dynamic> data)
      : message = data['message'] ?? 'Unknown message',
        status = data['status'] != null ? data['status'].toString() : 'Unknown status';

  @override
  String toString() => message;
}