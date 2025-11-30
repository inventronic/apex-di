public with sharing class AccountService implements IAccountService {
  UUID randomUUID = UUID.randomUUID();
  private IError error { get; set; }
  public IError run() {
    System.debug('AccountService :-> ' + randomUUID.toString());
    System.debug(
      'AccountService :-> error has ' +
        (error == null ? 'not ' : '') +
        'been injected'
    );
    return error;
  }

  // private constructor
  private AccountService(IError error) {
    this.error = error;
  }

  public class Factory implements IServiceFactory {
    public IAccountService initialize(IServiceProvider provider) {
      return new AccountService((IError) provider.getService(IError.class));
    }
  }
}
