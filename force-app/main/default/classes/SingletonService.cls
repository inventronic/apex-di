public inherited sharing virtual class SingletonService extends ServiceDescriptor {
  public SingletonService(IServiceProvider provider, Object instance) {
    String instanceName = getClassName(instance);
    Type instanceType = Type.forName(instanceName ?? '');
    this.error.notFoundMessageOrAssignable(
      instanceType == null,
      instanceName ?? 'Unknown Typed Class'
    );
    this.assignTypes(null, instanceType);
    super.instantiatedObject = instance;
    super.provider = provider;
  }

  public SingletonService(IServiceProvider provider, Type serviceType) {
    this(provider, serviceType, serviceType);
  }

  public SingletonService(
    IServiceProvider provider,
    Type baseType,
    Object instance
  ) {
    this(provider, instance);
    this.assignTypes(baseType, this.serviceType);
    this.error
      .notImplemented(
        isValid(baseType, this.serviceType) == false,
        baseType,
        this.serviceType
      );
  }

  public SingletonService(
    IServiceProvider provider,
    Type baseType,
    Type serviceType
  ) {
    this.assignTypes(baseType, serviceType);
    super.provider = provider;
  }

  public SingletonService(IServiceProvider provider, String serviceType) {
    this(provider, serviceType, serviceType);
  }

  public SingletonService(
    IServiceProvider provider,
    String baseType,
    Object instance
  ) {
    this(provider, instance);
    Type bType = Type.forName(baseType ?? '');
    this.assignTypes(bType, this.serviceType);
    this.error
      .notImplemented(
        isValid(bType, this.serviceType) == false,
        bType,
        this.serviceType
      );
  }

  public SingletonService(
    IServiceProvider provider,
    String baseType,
    String serviceType
  ) {
    Type bType = Type.forName(baseType ?? '');
    Type sType = Type.forName(serviceType ?? '');
    this.error.notFoundMessageOrAssignable(
      sType == null,
      serviceType ?? 'serviceType class'
    );
    this.error.notFoundMessageOrAssignable(
      bType == null,
      baseType ?? 'baseType class'
    );
    this.assignTypes(bType, sType);
    super.provider = provider;
  }

  public virtual override Object resolve() {
    return this.getInstance(
      super.instantiatedObject ?? serviceType?.newInstance()
    );
  }

  public virtual override String toString() {
    return 'Singleton';
  }
}
