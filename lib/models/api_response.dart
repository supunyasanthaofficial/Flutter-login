/// Standard API response wrapper to represent network/service outcomes.
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final String? errorMessage;
  final int statusCode;

  const ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.errorMessage,
    this.statusCode = 200,
  });

  factory ApiResponse.success(T data, {String? message, int statusCode = 200}) {
    return ApiResponse._(
      isSuccess: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String errorMessage, {int statusCode = 400}) {
    return ApiResponse._(
      isSuccess: false,
      errorMessage: errorMessage,
      statusCode: statusCode,
    );
  }
}
