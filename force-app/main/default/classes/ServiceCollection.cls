public inherited sharing class ServiceCollection implements IServiceCollection {
  private Map<Type, ServiceDescriptor> svcDescriptors;
  protected IError error = DI.ERROR;
  protected final IServiceProvider provider;

  {
    this.svcDescriptors = new Map<Type, ServiceDescriptor>();
  }

  private IServiceCollection globalServices {
    get {
      return ServiceProvider.GLOBAL_PROVIDER?.services();
    }
  }

  @TestVisible
  private Map<Type, ServiceDescriptor> globalDesciptors {
    get {
      return ((ServiceCollection) globalServices)?.svcDescriptors;
    }
  }

  public IServiceCollection loadRegistries() {
    this.loadServiceRegistries();
    return this;
  }

  public ServiceCollection(IServiceProvider provider) {
    this.error.paramRequired(provider == null, 'provider');
    this.provider = provider;
  }

  public IServiceCollection addSingleton(Object instance) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      instance
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(Type serviceType) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      serviceType
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(String serviceType) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      serviceType
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(Type baseType, Object instance) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      baseType,
      instance
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(String baseType, Object instance) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      baseType,
      instance
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(Type baseType, Type serviceType) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      baseType,
      serviceType
    );
    this.addToGlobal(sDesc);
    return this;
  }
  public IServiceCollection addSingleton(String baseType, String serviceType) {
    ServiceDescriptor sDesc = new SingletonService(
      ServiceProvider.GLOBAL_PROVIDER,
      baseType,
      serviceType
    );
    this.addToGlobal(sDesc);
    return this;
  }

  private void addToGlobal(ServiceDescriptor service) {
    this.validateGlobal(service);
    this.globalDesciptors
      ?.put(service.baseType ?? service.serviceType, service);
  }

  public IServiceCollection addTransient(Type serviceType) {
    ServiceDescriptor sDesc = new TransientService(this.provider, serviceType);
    this.addToDescriptors(sDesc);
    return this;
  }

  public IServiceCollection addTransient(Type baseType, Type serviceType) {
    ServiceDescriptor sDesc = new TransientService(
      this.provider,
      baseType,
      serviceType
    );
    this.addToDescriptors(sDesc);
    return this;
  }

  public IServiceCollection addTransient(String serviceType) {
    ServiceDescriptor sDesc = new TransientService(this.provider, serviceType);
    this.addToDescriptors(sDesc);
    return this;
  }

  public IServiceCollection addTransient(String baseType, String serviceType) {
    ServiceDescriptor sDesc = new TransientService(
      this.provider,
      baseType,
      serviceType
    );
    this.addToDescriptors(sDesc);
    return this;
  }

  public IServiceCollection addScoped(Object instance) {
    ServiceDescriptor sDesc = new ScopedService(this.provider, instance);
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(Type serviceType) {
    ServiceDescriptor sDesc = new ScopedService(this.provider, serviceType);
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(String serviceType) {
    ServiceDescriptor sDesc = new ScopedService(this.provider, serviceType);
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(Type baseType, Object instance) {
    ServiceDescriptor sDesc = new ScopedService(
      this.provider,
      baseType,
      instance
    );
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(String baseType, Object instance) {
    ServiceDescriptor sDesc = new ScopedService(
      this.provider,
      baseType,
      instance
    );
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(Type baseType, Type serviceType) {
    ServiceDescriptor sDesc = new ScopedService(
      this.provider,
      baseType,
      serviceType
    );
    this.addToDescriptors(sDesc);
    return this;
  }
  public IServiceCollection addScoped(String baseType, String serviceType) {
    ServiceDescriptor sDesc = new ScopedService(
      this.provider,
      baseType,
      serviceType
    );
    this.addToDescriptors(sDesc);
    return this;
  }

  private void addToDescriptors(ServiceDescriptor service) {
    this.validate(service);
    this.svcDescriptors?.put(service.baseType ?? service.serviceType, service);
  }

  @TestVisible
  private void validateGlobal(ServiceDescriptor svcDesc) {
    ServiceDescriptor resultSvcDesc = this.getFromGlobal(
      svcDesc?.baseType ?? svcDesc?.serviceType
    );
    this.error.alreadyRegisteredGlobally(resultSvcDesc != null, resultSvcDesc);
  }

  @TestVisible
  private void validate(ServiceDescriptor svcDesc) {
    Type currentType = svcDesc?.baseType ?? svcDesc?.serviceType;
    ServiceDescriptor resultSvcDesc = this.getFromSingleton(currentType);
    this.error.alreadyRegisteredGlobally(resultSvcDesc != null, resultSvcDesc);

    resultSvcDesc = this.getFromScoped(currentType);
    resultSvcDesc = resultSvcDesc ?? this.getFromTransient(currentType);
    this.error.alreadyRegistered(resultSvcDesc != null, resultSvcDesc);
  }

  public ServiceDescriptor getFromGlobal(Type serviceType) {
    ServiceDescriptor result = this.globalDesciptors?.get(serviceType);
    return result;
  }

  public ServiceDescriptor getFromSingleton(Type serviceType) {
    ServiceDescriptor result = this.getFromGlobal(serviceType);
    result = result instanceof SingletonService ? result : null;
    return result;
  }

  public ServiceDescriptor getFromScoped(Type serviceType) {
    ServiceDescriptor result = this.svcDescriptors?.get(serviceType);
    result = result instanceof ScopedService ? result : null;
    return result;
  }

  public ServiceDescriptor getFromTransient(Type serviceType) {
    ServiceDescriptor result = this.svcDescriptors?.get(serviceType);
    result = result instanceof TransientService ? result : null;
    return result;
  }

  private void loadServiceRegistries() {
    List<DI_Registry__mdt> lstRegistries = Test.isRunningTest()
      ? new List<DI_Registry__mdt>{
          new DI_Registry__mdt(
            DeveloperName = 'List<Decimal>',
            Service_Lifetime__c = 'Singleton',
            Implementation_Type__c = 'List<Decimal>',
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = 'List<String>',
            Service_Lifetime__c = 'Transient',
            Implementation_Type__c = 'List<String>',
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = 'List<Integer>',
            Service_Lifetime__c = 'Scoped',
            Implementation_Type__c = 'List<Integer>',
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = 'List<Boolean>',
            Service_Lifetime__c = 'Singleton',
            Implementation_Type__c = '',
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = 'List<Long>',
            Service_Lifetime__c = 'Transient',
            Implementation_Type__c = null,
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = 'List<ID>',
            Service_Lifetime__c = 'Scoped',
            Implementation_Type__c = null,
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = '',
            Service_Lifetime__c = 'Scoped',
            Implementation_Type__c = null,
            Active__c = true
          ),
          new DI_Registry__mdt(
            DeveloperName = '',
            Service_Lifetime__c = 'Scoped',
            Implementation_Type__c = null,
            Active__c = false
          )
        }
      : (DI_Registry__mdt.getAll()?.values() ?? new List<DI_Registry__mdt>());

    for (DI_Registry__mdt eachRegistry : lstRegistries) {
      if (
        eachRegistry.Active__c != true ||
        String.isBlank(eachRegistry.DeveloperName)
      ) {
        continue;
      }

      switch on eachRegistry.Service_Lifetime__c {
        when 'Transient' {
          if (String.isNotBlank(eachRegistry.Implementation_Type__c)) {
            addTransient(
              eachRegistry.DeveloperName,
              eachRegistry.Implementation_Type__c
            );
            continue;
          }
          addTransient(eachRegistry.DeveloperName);
        }
        when 'Singleton' {
          if (String.isNotBlank(eachRegistry.Implementation_Type__c)) {
            addSingleton(
              eachRegistry.DeveloperName,
              eachRegistry.Implementation_Type__c
            );
            continue;
          }
          addSingleton(eachRegistry.DeveloperName);
        }
        when else {
          if (String.isNotBlank(eachRegistry.Implementation_Type__c)) {
            addScoped(
              eachRegistry.DeveloperName,
              eachRegistry.Implementation_Type__c
            );
            continue;
          }
          addScoped(eachRegistry.DeveloperName);
        }
      }
    }
  }
}
