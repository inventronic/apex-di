public interface IServiceCollection {
  ServiceDescriptor getFromGlobal(Type serviceType);
  ServiceDescriptor getFromSingleton(Type serviceType);
  ServiceDescriptor getFromScoped(Type serviceType);
  ServiceDescriptor getFromTransient(Type serviceType);

  IServiceCollection loadRegistries();

  IServiceCollection addSingleton(Object instance);
  IServiceCollection addSingleton(Type serviceType);
  IServiceCollection addSingleton(String serviceType);
  IServiceCollection addSingleton(Type baseType, Object instance);
  IServiceCollection addSingleton(String baseType, Object instance);
  IServiceCollection addSingleton(Type baseType, Type serviceType);
  IServiceCollection addSingleton(String baseType, String serviceType);

  IServiceCollection addTransient(Type serviceType);
  IServiceCollection addTransient(Type baseType, Type serviceType);
  IServiceCollection addTransient(String serviceType);
  IServiceCollection addTransient(String baseType, String serviceType);

  IServiceCollection addScoped(Object instance);
  IServiceCollection addScoped(Type serviceType);
  IServiceCollection addScoped(String serviceType);
  IServiceCollection addScoped(Type baseType, Object instance);
  IServiceCollection addScoped(String baseType, Object instance);
  IServiceCollection addScoped(Type baseType, Type serviceType);
  IServiceCollection addScoped(String baseType, String serviceType);
}