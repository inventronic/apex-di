public interface IError {
  Exception get();
  Exception get(String message);
  Exception get(Exception ex);
  Exception get(String message, Exception ex);
  void alreadyRegisteredGlobally(Boolean condition, ServiceDescriptor svcType);
  void alreadyRegistered(Boolean condition, ServiceDescriptor svcType);
  void notRegistered(Boolean condition, Type svcType);
  void notImplemented(Boolean condition, String baseType, String serviceType);
  void notImplemented(Boolean condition, Type baseType, Type serviceType);
  void required(String message);
  void required(String message, Boolean singular);
  void required(Boolean condition, String message);
  void required(Boolean condition, String message, Boolean singular);
  void notFound(String message);
  void notFound(String message, Boolean singular);
  void notFound(Boolean condition, String message);
  void notFound(Boolean condition, String message, Boolean singular);
  void notFoundMessageOrAssignable(Boolean condition, String message);
  void generalError(String message);
  void generalError(Boolean condition, String message);
  void nullOrEmptyError(String message);
  void nullOrEmptyError(Boolean condition, String message);
  void nullOrEmptyError(Boolean condition, String message, Boolean singular);
  void paramRequired(Boolean condition, String paramName);
}
