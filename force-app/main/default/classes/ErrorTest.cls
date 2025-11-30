@IsTest
private class ErrorTest {
  // Simple concrete subclass to access protected helper methods for direct testing
  private class ErrorStub extends Error {
  }

  @IsTest
  static void getDefaultExceptionAndGetOverloads() {
    ErrorStub e = new ErrorStub();

    // get() -> HandledException with default message
    Exception ex1 = e.get();
    System.assertEquals(
      'System.HandledException',
      ex1.getTypeName(),
      'get() returns HandledException (System.HandledException)'
    );
    System.assertEquals(
      Error.UNKNOWN_ERROR,
      ex1.getMessage(),
      'Default unknown error message'
    );

    // get(String) non-blank message
    Exception ex2 = e.get('M1');
    System.assertEquals(
      'System.HandledException',
      ex2.getTypeName(),
      'get(message) returns HandledException (System.HandledException)'
    );
    System.assertEquals('M1', ex2.getMessage(), 'Message mirrors provided');

    // get(Exception) returns same exception reference
    Exception original = new IllegalArgumentException('boom');
    Exception ex3 = e.get(original);
    System.assertEquals(original, ex3, 'get(Exception) returns same instance');

    // get(String, Exception) returns Exception if provided, ignoring message as constructor returns provided exception
    Exception ex4 = e.get('ignored', original);
    System.assertEquals(
      original,
      ex4,
      'get(String, Exception) returns provided exception'
    );

    // getDefaultMessageIfEmpty via testVisible
    System.assertEquals(
      Error.UNKNOWN_ERROR,
      e.getDefaultMessageIfEmpty(''),
      'Empty becomes default unknown'
    );
    System.assertEquals(
      'abc',
      e.getDefaultMessageIfEmpty('abc'),
      'Non-empty remains'
    );
  }

  @IsTest
  static void alreadyNotRegisteredAlreadyGloballyThrowWhenConditionTrue() {
    Error err = new Error();
    IServiceProvider provider = new ServiceProvider();
    // Use try/catch to assert thrown exception types and messages
    // alreadyRegisteredGlobally
    try {
      ServiceDescriptor svcDesc = new TransientService(provider, Error.class);
      err.alreadyRegisteredGlobally(true, svcDesc);
      System.assert(false, 'Expected exception for alreadyRegisteredGlobally');
    } catch (Exception ex) {
      System.assertEquals(
        'System.HandledException',
        ex.getTypeName(),
        'HandledException expected'
      );
      System.assertEquals(
        'Error with Transient lifetime is already registered in global services.',
        ex.getMessage(),
        'Message should contain class name'
      );
    }

    // alreadyRegistered
    try {
      ServiceDescriptor svcDesc = new ScopedService(provider, Error.class);
      err.alreadyRegistered(true, svcDesc);
      System.assert(false, 'Expected exception for alreadyRegistered');
    } catch (Exception ex) {
      System.assertEquals(
        'System.HandledException',
        ex.getTypeName(),
        'HandledException expected'
      );
      System.assertEquals(
        'Error with Scoped lifetime is already registered.',
        ex.getMessage(),
        'Message should contain class name'
      );
    }

    // notRegistered
    try {
      err.notRegistered(true, Error.class);
      System.assert(false, 'Expected exception for notRegistered');
    } catch (Exception ex) {
      System.assertEquals(
        'System.HandledException',
        ex.getTypeName(),
        'HandledException expected'
      );
      System.assertEquals(
        'Error is not registered or active.',
        ex.getMessage(),
        'Message should contain class name'
      );
    }
  }

  @IsTest
  static void notImplementedOverloadsThrowWhenTrue() {
    Error err = new Error();

    // String overload
    try {
      err.notImplemented(true, 'BaseX', 'SvcY');
      System.assert(
        false,
        'Expected exception for notImplemented(String,String)'
      );
    } catch (Exception ex) {
      System.assertEquals(
        'System.HandledException',
        ex.getTypeName(),
        'HandledException expected'
      );
      System.assertEquals(
        'SvcY is not implemented or extended by BaseX, or not assignable.',
        ex.getMessage(),
        'Message matches format'
      );
    }

    // Type overload
    try {
      err.notImplemented(true, Error.class, ErrorTest.class);
      System.assert(false, 'Expected exception for notImplemented(Type,Type)');
    } catch (Exception ex) {
      System.assertEquals(
        'System.HandledException',
        ex.getTypeName(),
        'HandledException expected'
      );
      System.assertEquals(
        'ErrorTest is not implemented or extended by Error, or not assignable.',
        ex.getMessage(),
        'Message uses getName() for types'
      );
    }
  }

  @IsTest
  static void requiredOverloadsThrowExpectedExceptions() {
    Error err = new Error();

    // required(message) throws IllegalArgumentException
    try {
      err.required('FieldX');
      System.assert(false, 'Expected IllegalArgumentException');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'FieldX is required.',
        ex.getMessage(),
        'Required message'
      );
    }

    // required(message, plural=true/false) - plural path
    try {
      err.requiredMessage();
      err.required('Fields', false);
      System.assert(false, 'Expected IllegalArgumentException');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'Fields are required.',
        ex.getMessage(),
        'Plural required message'
      );
    }

    // required(message, plural=true/false) - plural path
    try {
      err.requiredMessage();
      err.required(true, 'FieldY', true);
      System.assert(false, 'Expected IllegalArgumentException');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'FieldY is required.',
        ex.getMessage(),
        'Plural required message'
      );
    }

    // required(condition, message, singular) -> condition=false should NOT throw
    err.required(false, 'FieldY', true);
    err.required(false, 'FieldZ');
    System.assert(true, 'No exception expected when condition=false');
  }

  @IsTest
  static void notFoundOverloadsAndConditional() {
    Error err = new Error();

    // notFound(message) throws
    try {
      err.notFound('ItemX');
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals(
        'ItemX is not found.',
        ex.getMessage(),
        'Not found message'
      );
    }

    // notFound(message, plural)
    try {
      err.notFound('ItemsX', false);
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals(
        'ItemsX are not found.',
        ex.getMessage(),
        'Plural not found message'
      );
    }

    // notFound(condition=false, message) should not throw
    err.notFound(false, 'NoThrow');

    // notFound(condition=true, message, singular) should throw
    try {
      err.notFound(true, 'Unit', true);
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals(
        'Unit is not found.',
        ex.getMessage(),
        'Conditional not found message'
      );
    }
  }

  @IsTest
  static void notFoundOrAssignableConditional() {
    Error err = new Error();

    // condition=false -> no throw
    err.notFoundMessageOrAssignable(false, 'X');

    // condition=true -> throws HandledException with specific format
    try {
      err.notFoundMessageOrAssignable(true, 'X');
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals(
        'X is not found or not assignable or not convertable to Object.',
        ex.getMessage(),
        'notFoundOrAssignable message'
      );
    }
  }

  @IsTest
  static void generalErrorOverloadsAndValidation() {
    Error err = new Error();

    // generalError(message) -> throws HandledException
    try {
      err.generalError('GMsg');
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals('GMsg', ex.getMessage(), 'General error message');
    }

    // generalError(condition=null) -> throws IllegalArgumentException with required('condition')
    try {
      err.generalError((Boolean) null, 'X');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'The condition parameter is null or empty.',
        ex.getMessage(),
        'Null condition message'
      );
    }

    // generalError(blank message) -> throws IllegalArgumentException required('message')
    try {
      err.generalError(true, '');
      System.assert(
        false,
        'Expected IllegalArgumentException for blank message'
      );
    } catch (Exception ex) {
      System.assertEquals('', ex.getMessage(), 'Blank message required');
    }

    // generalError(condition=false) -> no throw
    err.generalError(false, 'Ignored');
  }

  @IsTest
  static void nullOrEmptyErrorOverloadsAndValidation() {
    Error err = new Error();

    // nullOrEmptyError(message) -> HandledException with formatted message
    try {
      err.nullOrEmptyError('ParamX');
      System.assert(false, 'Expected HandledException');
    } catch (HandledException ex) {
      System.assertEquals(
        'ParamX is null or empty.',
        ex.getMessage(),
        'Null or empty error message'
      );
    }

    // nullOrEmptyError(condition=null) -> IllegalArgumentException required('condition')
    try {
      err.nullOrEmptyError((Boolean) null, 'X');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'The Something parameter is null or empty.',
        ex.getMessage(),
        'Null condition message'
      );
    }

    // nullOrEmptyError(blank message) -> IllegalArgumentException required('message')
    try {
      err.nullOrEmptyError(true, '');
      System.assert(
        false,
        'Expected IllegalArgumentException for blank message'
      );
    } catch (Exception ex) {
      System.assertEquals(
        'Something is null or empty.',
        ex.getMessage(),
        'Blank message required'
      );
    }

    // nullOrEmptyError(condition=false) -> no throw
    err.nullOrEmptyError(false, 'Ignored');
  }

  @IsTest
  static void paramRequiredOverloadsAndValidation() {
    Error err = new Error();

    // paramRequired(condition=null) -> IllegalArgumentException required('condition')
    try {
      err.paramRequired((Boolean) null, 'X');
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'The condition parameter is null or empty.',
        ex.getMessage(),
        'Null condition message'
      );
    }

    // paramRequired(blank name) -> IllegalArgumentException required('paramName')
    try {
      err.paramRequired(true, '');
      System.assert(
        false,
        'Expected IllegalArgumentException for blank paramName'
      );
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'The Something parameter is null or empty.',
        ex.getMessage(),
        'Blank paramName required'
      );
    }

    // paramRequired(blank name) -> IllegalArgumentException required('paramName')
    try {
      err.paramRequired(true, 'Test');
      System.assert(
        false,
        'Expected IllegalArgumentException for blank paramName'
      );
    } catch (IllegalArgumentException ex) {
      System.assertEquals(
        'The Test parameter is null or empty.',
        ex.getMessage(),
        'Blank paramName required'
      );
    }

    // paramRequired(condition=false) -> no throw
    err.paramRequired(false, 'Ignored');
  }
}
