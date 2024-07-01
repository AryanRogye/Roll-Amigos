import 'dart:math';

class GeneratePassword {
  static int genPassword() {
    //need to generate a random number between 1000 and 9999
    Random random = new Random();
    int password = random.nextInt(9999 - 1000) + 1000;
    return password;
  }
}
