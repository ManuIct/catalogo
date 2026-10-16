abstract class AppException implements Exception {
  const AppException(this.message);


  final String message;

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AppException {
 const InvalidCredentialsException()
      : super('Username o password non corretti');  
}

class NetworkException extends AppException {
  const NetworkException()
      : super('connessione assente o troppo lenta. Riprova');
}

class SessionExpiredException extends AppException {
  const SessionExpiredException()
      : super('Sessione scaduta. Effettua di nuovo il login.');
}

class ServerException extends AppException {
  ServerException([int? statusCode])
      : super('Errore del server (${statusCode ?? 'sconosciuto'}).');
}