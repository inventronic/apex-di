public with sharing class AccountServiceInitializationCode implements IAccountService {
  UUID randomUUID = UUID.randomUUID();
  private IError error { get; set; }

  // // Using Initialization Code for Static Classes
  // static {
  //   error = (IError) DI.getService(IError.class);
  // }

  // Using Initialization Code
  {
    error = (IError) DI.getService(IError.class);
  }

  public IError run() {
    System.debug('AccountService :-> ' + randomUUID.toString());
    System.debug(
      'AccountService :-> error has ' +
        (error == null ? 'not ' : '') +
        'been injected'
    );
    return error;
  }
}
