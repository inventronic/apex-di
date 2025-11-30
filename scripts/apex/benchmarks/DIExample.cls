public without sharing class DIExample {
  public static void all() {
    DIExample.first();
    DIExample.second();
    DIExample.third();
    DIExample.fourth();
    DIExample.fifth();
    DIExample.sixth();
    DIExample.seventh();
    DIExample.eighth();
    DIExample.nineth();
  }

  public static void first() {
    DI.services.addScoped(Chicken.class, Chicken.class);

    IServiceProvider provider = new ServiceProvider();
    provider.services().addScoped('Cow');

    IAnimal animal = (Cow) provider.getService(Cow.class);
    System.debug(animal.speak());

    provider.services().addScoped(Chicken.class);

    animal = (Chicken) DI.getService(Chicken.class);
    System.debug(animal.speak());
    animal = (Chicken) DI.getService(Chicken.class);
    System.debug(animal.speak());

    animal = (Chicken) provider.getService(Chicken.class);
    System.debug(animal.speak());
    animal = (Chicken) provider.getService(Chicken.class);
    System.debug(animal.speak());
  }

  public static void second() {
    IServiceProvider provider1 = new ServiceProvider();

    provider1.services().addSingleton(IAnimal.class, Cow.class);
    provider1.services().addScoped('Cow');

    IAnimal animal = (Cow) provider1.getService(Cow.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider1.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider1.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());
  }

  public static void third() {
    // DI.services.addScoped(IAnimal.class, Cow.class);

    IAnimal animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());
  }

  public static void fourth() {
    IAnimal animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();
    provider2.services().addScoped(IAnimal.class, Cow.class);

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());
  }

  public static void fifth() {
    IAnimal animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();
    provider2.services().addScoped(IAnimal.class, Chicken.class);
    provider2.services().addTransient(Cow.class);

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(Cow.class);
    System.debug(animal.speak());
  }

  public static void sixth() {
    IAnimal animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();
    provider2.services().addScoped(IAnimal.class, Chicken.class);

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());
  }

  public static void seventh() {
    IAnimal animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) DI.getService(IAnimal.class);
    System.debug(animal.speak());

    IServiceProvider provider2 = new ServiceProvider();
    provider2.services().addTransient(IAnimal.class, Chicken.class);
    provider2.services().addTransient(Cow.class);

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(IAnimal.class);
    System.debug(animal.speak());

    animal = (IAnimal) provider2.getService(Cow.class);
    System.debug(animal.speak());
  }

  public static void eighth() {
    IAnimal animal = (Cow) DI.getService(Cow.class);
    System.debug(animal.speak());
  }

  public static void nineth() {
    DI.services.addScoped(IError.class, Error.class);

    IServiceProvider provider2 = new ServiceProvider();
    // provider2.services().addSingleton(IError.class, Error.class);
    provider2.services().addScoped('IError', 'Error');
    provider2.services()
      .addScoped(IAccountService.class, AccountService.Factory.class);
    // DI.services.addScoped(AccountService.Factory.class);
    DI.services.addTransient(
      IAccountService.class,
      AccountService.Factory.class
    );
    IAccountService accountService1 = (IAccountService) provider2.getService(
      IAccountService.class
    );
    IError err1 = accountService1.run();

    IAccountService accountService2 = (IAccountService) provider2.getService(
      IAccountService.class
    );
    err1 = accountService2.run();
    System.debug(
      'Account Services are same instance: ' +
      (accountService1 == accountService2)
    );

    IAccountService accountService3 = (IAccountService) DI.getService(
      IAccountService.class
    );
    IError err2 = accountService3.run();

    IAccountService accountService4 = (IAccountService) DI.getService(
      IAccountService.class
    );
    err2 = accountService4.run();
    System.debug('Errors are same instance: ' + (err1 == err2));
    System.debug(
      'Account Services are same instance: ' +
      (accountService3 == accountService4)
    );
  }
}
