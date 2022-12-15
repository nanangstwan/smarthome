abstract class Result<T> {
  final String message;
  Result(this.message);
}

class Success<T> extends Result<T> {
  final T data;
  Success({String message = "Berhasil", required this.data}) : super(message);
}

class Error<T> extends Result<T> {
  Error(
      {String message =
          "Telah terjadi error yang tak diketahui, silahkan coba kembali"})
      : super(message);
}
