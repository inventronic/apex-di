public interface IServiceProvider {
  IServiceCollection services();
  Object getService(Type serviceType);
  Object getService(String serviceName);
}