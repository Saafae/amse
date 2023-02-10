import 'dart:io';

void main() {
  stdout.write("Entrez un nombre: ");
  int number = int.parse(stdin.readLineSync()!);

  if (number % 2 == 0) {
    print("Pair");
  } else {
    print("Impair");
  }
}
