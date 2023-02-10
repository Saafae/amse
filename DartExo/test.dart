import 'dart:io';

void main() {
  stdout.write("Entrez un nombre: ");

  int num = int.parse(stdin.readLineSync()!);
  print('La liste des diviseurs: ');
  for (int i = 1; i <= num; i++) {
    if (num % i == 0) {
      print(i);
    }
  }
}
