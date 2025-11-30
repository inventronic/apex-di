/**
 * @description     : DI class is the main entry point for Dependency Injection (DI) container.
 * @author          : Adeel Ahmed
 * @last modified   : 2025-10-03
 */

public inherited sharing class DI {
  public static final IError ERROR = new Error();
  public static IServiceCollection services {
    get {
      return provider?.services();
    }
  }

  public static IServiceProvider provider {
    get {
      return ServiceProvider.GLOBAL_PROVIDER;
    }
  }

  public static Object getService(Type serviceType) {
    return provider?.getService(serviceType);
  }

  public static Object getService(String serviceName) {
    return provider?.getService(serviceName);
  }
}
