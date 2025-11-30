public inherited sharing abstract class ServiceDescriptor {
  public static final String FAILED_TO_INSTANTIATE_SERVICE = 'Failed to instantiate service: ';
  protected IError error = DI.ERROR;
  protected Object instantiatedObject;
  protected final IServiceProvider provider;
  public Type baseType { get; protected set; }
  public Type serviceType { get; protected set; }
  public String baseTypeName { get; protected set; }
  public String serviceName { get; protected set; }
  public Object instance {
    get {
      return this.resolve();
    }
  }

  public abstract Object resolve();

  public boolean isValid(Type baseType, Type serviceType) {
    if (serviceType == null || baseType == null) {
      return false;
    }
    return IServiceFactory.class.isAssignableFrom(serviceType) == true ||
      baseType?.isAssignableFrom(serviceType) == true;
  }

  protected void assignTypes(Type serviceType) {
    this.serviceType = serviceType;
    this.serviceName = serviceType?.getName() ?? 'Class';
  }

  protected void assignTypes(Type baseType, Type serviceType) {
    this.assignTypes(serviceType);

    this.baseType = baseType != null &&
      baseType != serviceType
      ? baseType
      : null;
    this.baseTypeName = baseType?.getName();

    this.error
      .notImplemented(
        (this.baseType != null && isValid(this.baseType, serviceType) == false),
        baseType,
        serviceType
      );
  }

  protected Object getInstance(Object obj) {
    if (obj instanceof IServiceFactory) {
      this.error.required(
        this.provider == null,
        'For service factory initialization, provider'
      );
      obj = ((IServiceFactory) obj).initialize(this.provider);
    }
    this.error.generalError(
      obj == null,
      FAILED_TO_INSTANTIATE_SERVICE + this.serviceName
    );
    return obj;
  }

  protected String getClassName(Object instance) {
    String instanceName;
    try {
      instanceName = String.valueOf(instance);
      instanceName = instanceName?.contains(':')
        ? instanceName.split(':')[0]
        : null;
    } catch (Exception ex) {
      instanceName = null;
    }

    return instanceName;
  }
}
