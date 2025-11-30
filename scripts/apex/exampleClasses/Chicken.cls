public without sharing class Chicken implements IAnimal {
  UUID randomUUID = UUID.randomUUID();
  public String speak() {
    return 'Cluck Cluck ' + randomUUID.toString();
  }
}
