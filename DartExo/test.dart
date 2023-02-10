import 'dart:io';

void main() {
  stdout.write("Your name? ");
  String? name = stdin.readLineSync();
  print("Hi, $name! Your age?");

  String? age = stdin.readLineSync();
  int yearsleft = 100 - int.parse(age?.toString() ?? '0');

  print("$name, You have $yearsleft years to be 100 !!");
}
