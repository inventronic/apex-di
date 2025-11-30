public without sharing class Cow implements IAnimal {
  UUID randomUUID = UUID.randomUUID();
  public String speak() {
    return 'Moo ' + randomUUID.toString();
  }
}
