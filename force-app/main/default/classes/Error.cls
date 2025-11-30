public without sharing virtual class Error implements IError {
  public static final String UNKNOWN_ERROR = 'An unknown error occurred.';
  public static final String REQUIRED = 'required';
  public static final String SOMETHING = 'Something';
  public static final String NOT_REGISTERED = 'not registered or active';
  public static final String ALREADY_REGISTERED = 'already registered';
  public static final String IS_NOT_IMPLEMENTED_BY = 'is not implemented or extended by';
  public static final String BASE_TYPE = 'Base type';
  public static final String SERVICE_TYPE = 'Service type';
  public static final String NOT_FOUND = 'not found';
  public static final String NOT_FOUND_OR_ASSIGNABLE = 'not found or not assignable or not convertable to Object';
  public static final String NULL_EMPTY = 'null or empty';
  public static final String NOT_ACCESSIBLE = 'not accessible';
  public static final String CALLOUT_ERROR = 'API callout error';

  @TestVisible
  protected String requiredMessage() {
    return requiredMessage(null);
  }

  protected String requiredMessage(String message) {
    return requiredMessage(message, true);
  }

  protected String requiredMessage(String message, Boolean singular) {
    message = string.isBlank(message) ? SOMETHING : message;

    return String.format(
      '{0} {1} {2}.',
      new List<String>{ message, singular ? 'is' : 'are', REQUIRED }
    );
  }

  protected String notFoundMessageOrAssignableMessage(
    String message,
    Boolean singular
  ) {
    message = string.isBlank(message) ? SOMETHING : message;

    return String.format(
      '{0} {1} {2}.',
      new List<String>{
        message,
        singular ? 'is' : 'are',
        NOT_FOUND_OR_ASSIGNABLE
      }
    );
  }

  protected String notFoundMessage(String message, Boolean singular) {
    message = string.isBlank(message) ? SOMETHING : message;

    return String.format(
      '{0} {1} {2}.',
      new List<String>{ message, singular ? 'is' : 'are', NOT_FOUND }
    );
  }

  protected String nullOrEmpty(String message, Boolean singular) {
    message = string.isBlank(message) ? SOMETHING : message;

    return String.format(
      '{0} {1} {2}.',
      new List<String>{ message, singular ? 'is' : 'are', NULL_EMPTY }
    );
  }

  protected String nullOrEmptyParam(String message) {
    return nullOrEmptyParam(message, true);
  }

  protected String nullOrEmptyParam(String message, Boolean singular) {
    message = string.isBlank(message) ? SOMETHING : message;

    return String.format(
      'The {0} parameter {1} {2}.',
      new List<String>{ message, singular ? 'is' : 'are', NULL_EMPTY }
    );
  }

  protected String isNotRegistered(String service) {
    service = string.isBlank(service) ? SOMETHING : service;

    return String.format(
      '{0} is {1}.',
      new List<String>{ service, NOT_REGISTERED }
    );
  }

  protected String isAlreadyRegisteredGlobally(String service) {
    service = string.isBlank(service) ? SOMETHING : service;

    return String.format(
      '{0} is {1} in global services.',
      new List<String>{ service, ALREADY_REGISTERED }
    );
  }

  protected String isAlreadyRegistered(String service) {
    service = string.isBlank(service) ? SOMETHING : service;

    return String.format(
      '{0} is {1}.',
      new List<String>{ service, ALREADY_REGISTERED }
    );
  }

  protected String isNotImplemented(String baseType, String serviceType) {
    baseType = String.isBlank(baseType) ? BASE_TYPE : baseType;
    serviceType = String.isBlank(serviceType) ? SERVICE_TYPE : serviceType;

    return String.format(
      '{0} {1} {2}, or not assignable.',
      new List<String>{ serviceType, IS_NOT_IMPLEMENTED_BY, baseType }
    );
  }

  public Exception get() {
    return getDefaultException(null, '');
  }

  public Exception get(String message) {
    return getDefaultException(null, message);
  }

  public Exception get(Exception ex) {
    return getDefaultException(ex, '');
  }

  public Exception get(String message, Exception ex) {
    return getDefaultException(ex, message);
  }

  public void alreadyRegisteredGlobally(
    Boolean condition,
    ServiceDescriptor svcType
  ) {
    if (condition == true) {
      throw get(
        isAlreadyRegisteredGlobally(
          (svcType?.baseTypeName ?? svcType?.serviceName) +
            ' with ' +
            svcType.toString() +
            ' lifetime'
        ),
        null
      );
    }
  }

  public void alreadyRegistered(Boolean condition, ServiceDescriptor svcType) {
    if (condition == true) {
      throw get(
        isAlreadyRegistered(
          (svcType?.baseTypeName ?? svcType?.serviceName) +
            ' with ' +
            svcType.toString() +
            ' lifetime'
        ),
        null
      );
    }
  }

  public void notRegistered(Boolean condition, Type svcType) {
    if (condition == true) {
      throw get(isNotRegistered(svcType?.getName()), null);
    }
  }

  public void notImplemented(
    Boolean condition,
    String baseType,
    String serviceType
  ) {
    if (condition == true) {
      throw get(isNotImplemented(baseType, serviceType), null);
    }
  }

  public void notImplemented(
    Boolean condition,
    Type baseType,
    Type serviceType
  ) {
    if (condition == true) {
      throw get(
        isNotImplemented(baseType?.getName(), serviceType?.getName()),
        null
      );
    }
  }

  public void required(String message) {
    required(message, true);
  }

  public void required(String message, Boolean singular) {
    message = requiredMessage(message, singular);
    throw new IllegalArgumentException(message);
  }

  public void required(Boolean condition, String message) {
    required(condition, message, true);
  }

  public void required(Boolean condition, String message, Boolean singular) {
    if (condition == true) {
      required(message, singular);
    }
  }

  public void notFound(String message) {
    notFound(message, true);
  }

  public void notFound(String message, Boolean singular) {
    message = notFoundMessage(message, singular);
    throw new HandledException(message);
  }

  public void notFound(Boolean condition, String message) {
    notFound(condition, message, true);
  }

  public void notFound(Boolean condition, String message, Boolean singular) {
    if (condition == true) {
      notFound(message, singular);
    }
  }

  public void notFoundMessageOrAssignable(Boolean condition, String message) {
    if (condition == true) {
      message = notFoundMessageOrAssignableMessage(message, true);
      throw new HandledException(message);
    }
  }

  public void generalError(String message) {
    generalError(true, message);
  }

  public void generalError(Boolean condition, String message) {
    if (condition == true) {
      throw new HandledException(message);
    }
  }

  public void nullOrEmptyError(String message) {
    nullOrEmptyError(true, message);
  }

  public void nullOrEmptyError(Boolean condition, String message) {
    nullOrEmptyError(condition, message, true);
  }

  public void nullOrEmptyError(
    Boolean condition,
    String message,
    Boolean singular
  ) {
    if (condition == true) {
      throw new HandledException(nullOrEmpty(message, singular));
    }
  }

  public void paramRequired(Boolean condition, String paramName) {
    if (condition == true) {
      throw new IllegalArgumentException(nullOrEmptyParam(paramName));
    }
  }

  @testVisible
  protected String getDefaultMessageIfEmpty(String message) {
    return String.isBlank(message) ? UNKNOWN_ERROR : message;
  }

  @testVisible
  protected Exception getDefaultException(Exception ex, String message) {
    return ex != null
      ? ex
      : new HandledException(getDefaultMessageIfEmpty(message));
  }
}
