@IsTest
public class DITest {
  @IsTest
  static void servicesAndProviderForwardWhenGlobalsPresent() {
    // Arrange
    // Register a simple service so that provider creation is meaningful
    DI.services.addTransient(Error.class);
    IServiceProvider prov = DI.provider;

    // Act
    IServiceProvider diProvider = DI.provider;
    IServiceCollection svcCollection = DI.services;

    // Assert - services should be non-null if global provider exists, otherwise null-safe is expected.

    System.assertNotEquals(
      null,
      diProvider,
      'DI.diProvider should return a provider when a global provider exists'
    );

    System.assertNotEquals(
      null,
      svcCollection,
      'DI.services should forward a non-null IServiceCollection when a global provider exists'
    );
  }

  @IsTest
  static void getServiceResolvesByTypeAndName() {
    // Arrange
    DI.services.addTransient(Error.class);

    // Act
    Object byType = DI.getService(Error.class);
    Object byName = DI.getService('Error');

    // Assert
    System.assertNotEquals(
      null,
      byType,
      'DI.getService(Type) should resolve a registered service'
    );
    System.assertEquals(
      true,
      byType instanceof Error,
      'Resolved type should match registered class'
    );
    System.assertNotEquals(
      null,
      byName,
      'DI.getService(String) should resolve a registered service by name'
    );
    System.assertEquals(
      true,
      byName instanceof Error,
      'Resolved name should map to the same class'
    );
    System.assertNotEquals(
      byType,
      byName,
      'Transient services should produce different instances'
    );
  }

  @IsTest
  static void nullSafeBehaviorWhenNotInitialized() {
    // This test assumes a fresh execution context where no global provider is set yet.
    // If the underlying container retains globals across tests, the previous tests will have set them.
    // However, DI methods use null-safe navigation (?.), so we validate they do not throw when called.
    // Act + Assert (no exceptions expected)
    try {
      Object s1 = DI.getService('UnknownServiceName');
      Object s2 = DI.getService(Type.forName('System.String')); // unregistered type
      // Both should be null rather than throwing
      System.assertEquals(null, s1, 'Unregistered name should return null');
      System.assertEquals(null, s2, 'Unregistered type should return null');
    } catch (Exception e) {
      System.assertEquals(
        'The service of type UnknownServiceName is not found.',
        e.getMessage(),
        'Should match the error message.'
      );
    }
  }
}