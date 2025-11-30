public inherited sharing class ServiceProvider implements IServiceProvider {
  private static final String FAILED_TO_INSTANTIATE_SERVICE = 'Failed to instantiate service: ';
  public static final IServiceProvider GLOBAL_PROVIDER = new ServiceProvider();
  public IServiceCollection services { get; private set; }
  private final Map<Type, Object> instances;
  private final IError error = DI.ERROR;

  static {
    GLOBAL_PROVIDER.services()?.loadRegistries();
  }

  {
    this.instances = new Map<Type, Object>();
    this.services = new ServiceCollection(this);
  }

  public IServiceCollection services() {
    return this.services;
  }

  public Object getService(Type serviceType) {
    Object result = this.findInstance(serviceType);
    this.error.generalError(
      result == null,
      FAILED_TO_INSTANTIATE_SERVICE + serviceType?.getName() ?? 'Unknown'
    );
    return result;
  }

  public Object getService(String serviceName) {
    Type sType = Type.forName(serviceName ?? '');
    this.error.notFound(sType == null, 'The service of type ' + serviceName);
    return getService(sType);
  }

  private Object findInstance(Type serviceType) {
    Object result = getOrAddFromSingleton(serviceType);
    result = result ?? getOrAddFromScoped(serviceType);
    result = result ?? getFromTransient(serviceType);
    return result;
  }

  private Object getOrAddFromSingleton(Type serviceType) {
    Object result;
    Map<System.Type, Object> singletonInstances = ((ServiceProvider) GLOBAL_PROVIDER)
      ?.instances;
    ServiceDescriptor svcDesc = GLOBAL_PROVIDER.services()
      .getFromSingleton(serviceType);
    result = svcDesc != null ? singletonInstances?.get(serviceType) : null;
    if (result == null && svcDesc instanceof SingletonService) {
      result = svcDesc.instance;
      singletonInstances?.put(serviceType, result);
    }
    return result;
  }

  private Object getOrAddFromScoped(Type serviceType) {
    Object result;
    ServiceDescriptor svcDesc = this.services.getFromScoped(serviceType);
    result = svcDesc != null ? this.instances.get(serviceType) : null;
    if (result == null && svcDesc instanceof ScopedService) {
      result = svcDesc.instance;
      this.instances.put(serviceType, result);
    }
    return result;
  }

  private Object getFromTransient(Type serviceType) {
    ServiceDescriptor svcDesc = this.services.getFromTransient(serviceType);
    this.error.notRegistered(svcDesc == null, serviceType);
    return svcDesc?.instance;
  }
}
