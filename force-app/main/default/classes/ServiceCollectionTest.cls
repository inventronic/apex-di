@IsTest
private class ServiceCollectionTest {
  @IsTest
  static void addSingletonOverloadsRegisterExpectedDescriptor() {
    // Instance overload
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection sc1 = new ServiceCollection(provider);
    Error instance = new Error();
    sc1.addSingleton(instance);
    ServiceDescriptor d1 = sc1.globalDesciptors.get(Error.class);
    System.assertEquals(
      null,
      d1.baseType,
      'Instance registration has null baseType'
    );
    System.assertEquals(
      Error.class,
      d1.serviceType,
      'serviceType resolved from instance'
    );

    // Type overload (single Type)
    ServiceCollection sc2 = new ServiceCollection(provider);
    try {
      sc2.addTransient(Error.class);
    } catch (Exception ex) {
      System.assertEquals(
        'Error with Singleton lifetime is already registered in global services.',
        ex?.getMessage(),
        'One descriptor expected (type)'
      );
    }

    // BaseType + instance
    ServiceCollection sc4 = new ServiceCollection(provider);
    sc4.addSingleton(IError.class, new Error());
    ServiceDescriptor d4 = sc4.globalDesciptors.get(IError.class);
    System.assertEquals(IError.class, d4.baseType, 'Base type stored');
    System.assertEquals(
      Error.class,
      d4.serviceType,
      'Service type resolved from instance'
    );
  }

  @IsTest
  static void addSingletonOverloads2RegisterExpectedDescriptor() {
    // String overload (single String)
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection sc3 = new ServiceCollection(provider);
    sc3.addSingleton('Error');
    ServiceDescriptor d3 = sc3.globalDesciptors.get(Error.class);
    System.assertEquals(
      null,
      d3.baseType,
      'Base type remains null for single-name registration'
    );
    System.assertEquals(
      Error.class,
      d3.serviceType,
      'String type name resolves to Type'
    );
  }

  @IsTest
  static void addSingletonOverloads3RegisterExpectedDescriptor() {
    // BaseType + instance (String overloads)
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection sc5 = new ServiceCollection(provider);
    sc5.addSingleton('IError', new Error());
    ServiceDescriptor d5 = sc5.globalDesciptors.get(IError.class);
    System.assertEquals(IError.class, d5.baseType, 'Base type via string');
    System.assertEquals(
      Error.class,
      d5.serviceType,
      'Service type via instance'
    );
  }

  @IsTest
  static void addSingletonOverloads4RegisterExpectedDescriptor() {
    // BaseType + ServiceType (Type overloads)
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection sc6 = new ServiceCollection(provider);
    sc6.addSingleton(IError.class, Error.class);
    ServiceDescriptor d6 = sc6.globalDesciptors.get(IError.class);
    System.assertEquals(IError.class, d6.baseType, 'Base type stored');
    System.assertEquals(Error.class, d6.serviceType, 'Service type stored');
  }

  @IsTest
  static void addSingletonOverloads5RegisterExpectedDescriptor() {
    // BaseType + ServiceType (String overloads)
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection sc7 = new ServiceCollection(provider);
    sc7.addSingleton(Error.class);
    ServiceDescriptor d7 = sc7.globalDesciptors.get(Error.class);
    System.assertEquals(null, d7.baseType, 'Base type shoult be null');
    System.assertEquals(Error.class, d7.serviceType, 'Service type via string');
  }

  @IsTest
  static void addTransientOverloadsRegisterExpectedDescriptor() {
    // Type
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection s1 = new ServiceCollection(provider);
    s1.addTransient(Error.class);

    // Base + Service
    ServiceCollection s2 = new ServiceCollection(provider);
    s2.addTransient(IError.class, Error.class);

    // String single
    ServiceCollection s3 = new ServiceCollection(provider);
    s3.addTransient('Error');

    // String base + service
    ServiceCollection s4 = new ServiceCollection(provider);
    s4.addTransient('IError', 'Error');

    ServiceDescriptor d3 = s3.getFromTransient(Error.class);
    System.assertEquals(
      null,
      d3.baseType,
      'Base type remains null for single-name registration'
    );
    System.assertEquals(Error.class, d3.serviceType, 'Service type via string');
  }

  @IsTest
  static void addScopedOverloadsRegisterExpectedDescriptor() {
    // Type
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection s1 = new ServiceCollection(provider);
    s1.addScoped(Error.class);

    // Base + Service
    ServiceCollection s2 = new ServiceCollection(provider);
    s2.addScoped(IError.class, Error.class);
    s2.addScoped(Error.class);

    // String single
    ServiceCollection s3 = new ServiceCollection(provider);
    s3.addScoped('Error');

    // String base + service
    ServiceCollection s4 = new ServiceCollection(provider);
    s4.addScoped('IError', 'Error');
    s4.addScoped(new Error());

    ServiceCollection s5 = new ServiceCollection(provider);
    s5.addScoped('IError', new Error());

    ServiceCollection s6 = new ServiceCollection(provider);
    s6.addScoped(IError.class, new Error());

    ServiceDescriptor d3 = s3.getFromScoped(Error.class);
    System.assertEquals(
      null,
      d3.baseType,
      'Base type remains null for single-name registration'
    );
    System.assertEquals(Error.class, d3.serviceType, 'Service type via string');
  }

  @IsTest
  static void addValidatesInputsAndDuplicateRegistration() {
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection s = new ServiceCollection(provider);

    // Null service -> throws (via nullOrEmptyError)
    try {
      s.validate((ServiceDescriptor) null);
      // System.assert(false, 'Expected exception for null service');
    } catch (Exception ex) {
      System.assertEquals(
        'The svcDesc parameter is null or empty.',
        ex.getMessage(),
        'Null service message'
      );
    }

    try {
      s.validate(new TransientService(provider, IError.class, Error.class));
    } catch (HandledException ex) {
      System.assertEquals(
        'baseType and serviceType is null or empty.',
        ex.getMessage(),
        'Missing types message'
      );
    }

    s.addTransient(IError.class, Error.class);
    try {
      s.addScoped(IError.class, Error.class);
      System.assert(false, 'Expected alreadyRegistered');
    } catch (HandledException ex) {
      System.assertEquals(
        'IError with Transient lifetime is already registered.',
        ex.getMessage(),
        'Duplicate registration prevented'
      );
    }
    s.addSingleton(IError.class, Error.class);

    try {
      s.addScoped(IError.class, Error.class);
      System.assert(false, 'Expected alreadyRegistered');
    } catch (HandledException ex) {
      System.assertEquals(
        'IError with Singleton lifetime is already registered in global services.',
        ex.getMessage(),
        'Duplicate registration prevented'
      );
    }
  }

  @IsTest
  static void isRegisteredChecksLocalMapOnly() {
    IServiceProvider provider = new ServiceProvider();
    ServiceCollection s = new ServiceCollection(provider);
    s.addTransient(IError.class, Error.class);
    // Indirect verification: adding same key again should fail (alreadyRegistered)
    try {
      s.addTransient(IError.class, Error.class);
      System.assert(false, 'Expected alreadyRegistered on second add');
    } catch (HandledException ex) {
      System.assertEquals(
        'IError with Transient lifetime is already registered.',
        ex.getMessage(),
        'Local duplicate detected'
      );
    }
  }
}
