import 'dart:math';

class GeneratePassword {
  static int genPassword() {
    // Generate a random number between 100000 and 999999
    Random random = new Random();
    int password = random.nextInt(999999 - 100000 + 1) + 100000;
    return password;
  }
}
