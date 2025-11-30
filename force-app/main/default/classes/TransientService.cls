public inherited sharing class TransientService extends ServiceDescriptor {
  public TransientService(IServiceProvider provider, Type serviceType) {
    this(provider, serviceType, serviceType);
  }

  public TransientService(
    IServiceProvider provider,
    Type baseType,
    Type serviceType
  ) {
    this.assignTypes(baseType, serviceType);
    super.provider = provider;
  }

  public TransientService(IServiceProvider provider, String serviceType) {
    this(provider, serviceType, serviceType);
  }

  public TransientService(
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

  public override Object resolve() {
    return this.getInstance(serviceType?.newInstance());
  }

  public virtual override String toString() {
    return 'Transient';
  }
}
