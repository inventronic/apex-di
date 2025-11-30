@IsTest
private class ServiceProviderTest {
  public class TestServiceFactory implements IServiceFactory {
    public Object initialize(IServiceProvider provider) {
      return new Error();
    }
  }

  @IsTest
  static void getServiceWithTypeReturnsRegisteredServiceFactory() {
    // Arrange
    DI.services.addSingleton(TestServiceFactory.class);

    ServiceProvider provider = new ServiceProvider();

    // Act
    Object result = provider.getService(TestServiceFactory.class);

    // Assert
    System.assertNotEquals(null, result, 'Service should be returned');
  }

  @IsTest
  static void getServiceWithTypeReturnsRegisteredService() {
    // Arrange
    DI.services.addSingleton(IError.class, Error.class);

    ServiceProvider provider = new ServiceProvider();

    // Act
    Object result = provider.getService(IError.class);

    // Assert
    System.assertNotEquals(null, result, 'Service should be returned');
  }

  @IsTest
  static void getServiceWithStringTypeReturnsRegisteredService() {
    // Arrange
    DI.services.addSingleton(Error.class);

    ServiceProvider provider = new ServiceProvider();

    // Act
    Object result = provider.getService('Error');

    // Assert
    System.assertNotEquals(null, result, 'Service should be returned');
  }

  @IsTest
  static void getServiceWithStringReturnsRegisteredService() {
    // Arrange

    DI.services.addScoped(IError.class, Error.class);

    // Act
    Object result = DI.getService(IError.class);

    // Assert
    System.assertNotEquals(null, result, 'Service should be returned');
  }

  @IsTest
  static void getServiceWithTypeThrowsExceptionForUnregisteredService() {
    ServiceProvider provider = new ServiceProvider();

    // Act & Assert
    try {
      provider.getService(String.class);
      System.assert(false, 'Expected exception for unregistered service');
    } catch (HandledException ex) {
      System.assertEquals(
        true,
        ex.getMessage().contains('not registered'),
        'Should contain resolution error message'
      );
    }
  }

  @IsTest
  static void getServiceWithStringThrowsExceptionForInvalidServiceName() {
    ServiceProvider provider = new ServiceProvider();

    // Act & Assert
    try {
      provider.getService('NonExistentService');
      System.assert(false, 'Expected exception for invalid service name');
    } catch (HandledException ex) {
      System.assertEquals(
        true,
        ex.getMessage().contains('not found'),
        'Should contain resolution error message'
      );
    }
  }

  @IsTest
  static void getServiceWithTypeHandlesNullServiceTypeGracefully() {
    ServiceProvider provider = new ServiceProvider();

    // Act & Assert
    try {
      provider.getService((Type) null);
      System.assert(false, 'Expected exception for null service type');
    } catch (Exception ex) {
      System.assertEquals(
        true,
        ex.getMessage().contains('not registered'),
        'Should mention serviceType parameter'
      );
    }
  }

  @IsTest
  static void getServiceWithStringHandlesNullServiceNameGracefully() {
    ServiceProvider provider = new ServiceProvider();

    // Act & Assert
    try {
      provider.getService((String) null);
      System.assert(false, 'Expected exception for null service name');
    } catch (Exception ex) {
      System.assertEquals(
        true,
        ex.getMessage().contains('service of type'),
        'Should mention serviceName parameter'
      );
    }
  }

  @IsTest
  static void getServiceWithStringHandlesEmptyServiceNameGracefully() {
    ServiceProvider provider = new ServiceProvider();

    // Act & Assert
    try {
      provider.getService('');
      System.assert(false, 'Expected exception for empty service name');
    } catch (Exception ex) {
      System.assertEquals(
        true,
        ex.getMessage().contains('service of type'),
        'Should mention serviceName parameter'
      );
    }
  }

  @IsTest
  static void getServicesReturnsServiceCollection() {
    // Arrange
    DI.services.addSingleton(IError.class, Error.class);

    ServiceProvider provider = new ServiceProvider();

    // Act
    IServiceCollection result = provider.services();

    // Assert
    System.assertNotEquals(DI.services, result, 'Should not equal.');
  }

  @IsTest
  static void findInstanceHandlesSingletonServicesCorrectly() {
    // Arrange
    Error mockError = new Error();

    DI.services.addSingleton(mockError);

    ServiceProvider provider = new ServiceProvider();

    // Act
    Object result = provider.getService(Error.class);

    // Assert
    System.assertNotEquals(null, result, 'Should find the singleton service');
    System.assertEquals(
      mockError,
      result,
      'Should return the singleton instance'
    );
  }

  @IsTest
  static void findInstanceHandlesTransientServicesCorrectly() {
    // Arrange
    DI.services.addTransient(Error.class);

    // Act
    Object result = DI.getService(Error.class);

    // Assert
    System.assertNotEquals(null, result, 'Should find the transient service');
    System.assertEquals(
      true,
      result instanceof Error,
      'Should return an Error instance'
    );
  }
}
